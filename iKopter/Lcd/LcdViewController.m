// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////

#import "LcdViewController.h"
#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "MKDataConstants.h"

#import "IKLcdDisplay.h"

#import "UIViewController+SplitView.h"

@implementation LcdViewController

@synthesize label;
@synthesize segment;

- (void) viewDidLoad {
  label.text = NSLocalizedString(@"Not connected\r\nNo data\r\n\r\n",@"NOT CONNECTED LCD");
  lcdCount = 0;
  [super viewDidLoad];
  
  UISwipeGestureRecognizer *swipe;
  swipe = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(nextScreen)] autorelease];
  swipe.direction =UISwipeGestureRecognizerDirectionLeft;
  [[self view] addGestureRecognizer:swipe];
  swipe = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(prevScreen)] autorelease];
  swipe.direction =UISwipeGestureRecognizerDirectionRight;
  [[self view] addGestureRecognizer:swipe];

}

#pragma mark -
#pragma mark UIViewController delegate methods

- (void) adjustViewsForOrientation:(UIInterfaceOrientation)orientation {
  if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
    self.label.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:30.0];
  }
  else if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
    self.label.font=[UIFont fontWithName:@"CourierNewPS-BoldMT" size:22.0];
  }
}


- (void) updateSegment {
  
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasNaviCtrl] forSegmentAtIndex:0];
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasFlightCtrl] forSegmentAtIndex:1];
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasMK3MAG] forSegmentAtIndex:2];

  IKMkAddress currentDevice=[MKConnectionController sharedMKConnectionController].currentDevice;
  switch (currentDevice) {
    case kIKMkAddressNC:
      segment.selectedSegmentIndex=0;
      break;
    case kIKMkAddressFC:
      segment.selectedSegmentIndex=1;
      break;
    case kIKMkAddressMK3MAg:
      segment.selectedSegmentIndex=2;
      break;
    default:
      break;
  }
}

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{	
  [super viewWillAppear:animated];
  
  if(self.isPad)
    self.navigationItem.hidesBackButton=YES;

  [self.navigationController setToolbarHidden:YES animated:NO];

	// for aesthetic reasons (the background is black), make the nav bar black for this particular page
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	// match the status bar with the nav bar
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;

  [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];
  [self updateSegment];

  [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}

- (void) viewDidAppear:(BOOL)animated {
  
 	// for aesthetic reasons (the background is black), make the nav bar black for this particular page
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	// match the status bar with the nav bar
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

  [nc addObserver:self
         selector:@selector(lcdNotification:)
             name:MKLcdNotification
           object:nil];

  [self startRequesting];
}

- (void) viewWillDisappear:(BOOL)animated {
  
  [self stopRequesting];

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];

	// restore the nav bar and status bar color to default
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  
  [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)newInterfaceOrientation duration:(NSTimeInterval)duration {
  [self adjustViewsForOrientation:newInterfaceOrientation];
}


//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) startRequesting {
  
  requestTimer=[NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:
                @selector(sendMenuRefreshRequest) userInfo:nil repeats:YES];
  
  [self performSelector:@selector(sendMenuRefreshRequest) withObject:self afterDelay:0.1];
}

- (void) stopRequesting {
  
  [requestTimer invalidate];
  requestTimer=nil;
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) sendMenuRequestForKeys:(uint8_t)keys;
{
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  uint8_t lcdReq[2];

  lcdReq[0] = keys;
  lcdReq[1] = 50;

  NSData * data = [NSData dataWithCommand:MKCommandLcdRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:lcdReq
                                   length:2];

  [cCtrl sendRequest:data];
}

- (void) sendMenuRefreshRequest {
  [self sendMenuRequestForKeys:0xFF];
}

- (void) lcdNotification:(NSNotification *)aNotification {

  IKLcdDisplay* lcdDisplay=[[aNotification userInfo] objectForKey:kIKDataKeyLcdDisplay];
  
  label.text = [lcdDisplay screenTextJoinedByString:@"\r\n"];
  
  if (lcdCount++ > 4 ) {
//    [self sendMenuRefreshRequest];
    lcdCount = 0;
  }
}

- (IBAction) changeDevice {
  
  [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];

  switch (segment.selectedSegmentIndex) {
    case 1:
      [[MKConnectionController sharedMKConnectionController] activateFlightCtrl];
      break;
    case 2:
      [[MKConnectionController sharedMKConnectionController] activateMK3MAG];
      break;
  }

#ifdef DEBUG
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  qltrace(@"Device set to %d", cCtrl.currentDevice);
#endif
  
  [self performSelector:@selector(sendMenuRefreshRequest) withObject:self afterDelay:0.1];
}

- (IBAction) nextScreen {
  [self sendMenuRequestForKeys:0xFD];
}

- (IBAction) prevScreen {
  [self sendMenuRequestForKeys:0xFE];
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
  [super viewDidUnload];
}

- (void) dealloc {
  [super dealloc];
}

@end
