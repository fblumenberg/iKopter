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

#import "HorizonOsdViewController.h"

@implementation HorizonOsdViewController

@synthesize indicator;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void) viewWillAppear:(BOOL)animated {
  
  [self.navigationController setToolbarHidden:YES animated:NO];

  osdValue = [[OsdValue alloc] init];
  osdValue.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
  [osdValue release];
}  


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  if ( UIInterfaceOrientationIsPortrait(orientation) ){
    [[NSBundle mainBundle] loadNibNamed:@"HorizonOsdViewController" owner:self options:nil];
  }
  else if (UIInterfaceOrientationIsLandscape(orientation)){
    [[NSBundle mainBundle] loadNibNamed:@"HorizonOsdViewControllerLandscape" owner:self options:nil];
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) newValue:(IKNaviData*)data {
  
  NSMutableString* info=[NSMutableString stringWithString:@"INFO\r\n"];
  
  [info appendFormat:@"SatsInUse: %d\r\n",data.data->SatsInUse];
  [info appendFormat:@"Altimeter: %d\r\n",data.data->Altimeter];
  [info appendFormat:@"Variometer: %d\r\n",data.data->Variometer];
  [info appendFormat:@"FlyingTime: %d\r\n",data.data->FlyingTime];
  [info appendFormat:@"UBat: %d\r\n",data.data->UBat];
  [info appendFormat:@"Heading: %d\r\n",data.data->Heading];
  [info appendFormat:@"CompassHeading: %d\r\n",data.data->CompassHeading];
  [info appendFormat:@"AngleNick: %d\r\n",data.data->AngleNick];
  [info appendFormat:@"AngleRoll: %d\r\n",data.data->AngleRoll];
  [info appendFormat:@"RC_Quality: %d\r\n",data.data->RC_Quality];
  [info appendFormat:@"FCFlags: %d\r\n",data.data->FCStatusFlags];
  [info appendFormat:@"NCFlags: %d\r\n",data.data->NCFlags];
  [info appendFormat:@"Errorcode: %d\r\n",data.data->Errorcode];
  [info appendFormat:@"RC_RSSI: %d\r\n",data.data->RC_RSSI];
  [info appendFormat:@"Current: %d\r\n",data.data->Current];
  [info appendFormat:@"UsedCapacity: %d\r\n",data.data->UsedCapacity];
  
  self.indicator.pitch=data.data->AngleNick;
  self.indicator.roll=data.data->AngleRoll;
}

@end
