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

#import "FollowMeOsdViewController.h"

@implementation FollowMeOsdViewController

@synthesize followMeSwitch;
@synthesize followMeRequests;
@synthesize followMeActive;
@synthesize osdValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)dealloc
{
  [followMeRequests release];
  [followMeActive release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateViewWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:orientation duration:duration];
  [self updateViewWithOrientation: orientation];
}

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation  {
  
  [super updateViewWithOrientation:orientation];

  BOOL f=self.osdValue.followMe;
  [self.followMeSwitch setOn:f];
}

- (void) newValue:(OsdValue*)value {
  
  self.followMeSwitch.enabled = value.canFollowMe;
  self.followMeRequests.text=[NSString stringWithFormat:@"%d",value.followMeRequests];

  self.followMeActive.text = value.followMeActive?@"\ue21a":@"\ue219";
  
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

- (IBAction) followMeChanged {
  self.osdValue.followMe = followMeSwitch.on;
}

- (void)viewDidUnload {
  [self setFollowMeRequests:nil];
  [self setFollowMeActive:nil];
  [super viewDidUnload];
}
@end
