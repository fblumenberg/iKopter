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


#import "ValueOsdViewController.h"
#import "UIImage+Tint.h"
#import "UIColor+ColorWithHex.h"
#import "InnerShadowView.h"


/////////////////////////////////////////////////////////////////////////////////
@interface ValueOsdViewController()

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation;
- (void) hideInfoViewAnimated;
- (void) hideInfoView:(BOOL)animated;
- (void) showInfoView;



@end

/////////////////////////////////////////////////////////////////////////////////
@implementation ValueOsdViewController

@synthesize noData;
@synthesize infoView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)dealloc {
  self.noData=nil;
  self.infoView=nil;

  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateViewWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
  
  [self hideInfoViewAnimated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation  {
  
  NSString* nibName=@"ValueOsdViewController";
  
  if (UIInterfaceOrientationIsLandscape(orientation)){
    nibName = [nibName stringByAppendingString:@"Landscape"];
  }
  
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    nibName = [nibName stringByAppendingString:@"-iPad"];
  }
  
  [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
  
  [super updateViewWithOrientation:orientation];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  [self updateViewWithOrientation: orientation];
}

/////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation bar Hideing 

- (void)showInfoView{
  
  CGRect frame = infoView.bounds;
  
  frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height - frame.size.height;
  
  self.infoView.hidden=NO;
  
  [UIView animateWithDuration:0.75
                   animations:^ {
                     self.infoView.frame = frame;
                   }];
  
  
  
  
}

- (void)hideInfoView:(BOOL)animated{
  
  CGRect frame = infoView.bounds;
  frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
  
  if(!animated){
    infoView.frame = frame;
    infoView.hidden=YES;
  }
  else{
    [UIView animateWithDuration:0.75
                     animations:^ {
                       self.infoView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                       infoView.hidden=YES;
                     }];
  }
}

- (void)hideInfoViewAnimated{
  [self hideInfoView:YES];
}

- (void)hideInfoViewAfterDelay:(NSTimeInterval)delay
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInfoViewAnimated) object:nil];
  qltrace(@"Calling performSelector with delay %f",delay);
  [self performSelector:@selector(hideInfoViewAnimated) withObject:nil afterDelay:delay];
}

#pragma mark OsdValueDelegate implementation
- (void) newValue:(OsdValue*)value {
  
  self.noData.hidden=YES;
  
  IKMkNaviData*data=value.data.data;
  
  if (data->Errorcode>0 && self.infoView.hidden) {
    infoView.text = [NSString stringWithFormat:NSLocalizedString(@"Error: %d", @"OSD NC error"),data->Errorcode];
    [self showInfoView];
  }
  else if(data->Errorcode==0 && !self.infoView.hidden) {
    [self hideInfoViewAnimated];
  }
  
  //-----------------------------------------------------------------------
  [self updateHeightView:value];
  //-----------------------------------------------------------------------
  [self updateBatteryView:value];
  //-----------------------------------------------------------------------
  [self updateStateView:value];
  //-----------------------------------------------------------------------
  [self updateAttitueViews:value];
  //-----------------------------------------------------------------------
  [self updateSpeedViews:value];
  //-----------------------------------------------------------------------
  [self updateWaypointViews:value];
  //-----------------------------------------------------------------------
  [self updateTargetHomeViews:value];
  //-----------------------------------------------------------------------

}  

- (void) noDataAvailable {
  self.noData.hidden=NO;
}

@end
