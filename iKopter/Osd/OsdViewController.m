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
/////////////////////////////////////////////////////////////////////////////////

#import "OsdViewController.h"
#import "ValueOsdViewController.h"
#import "HorizonOsdViewController.h"
#import "RawOsdViewController.h"
#import "MapOsdViewController.h"

/////////////////////////////////////////////////////////////////////////////////
@interface OsdViewController()
- (void)conceal;
- (void)concealAfterDelay:(NSTimeInterval)delay;
- (void)updateSelectedViewFrame;
- (void)doScreenLock;
- (void)showNavigationBar;
- (void)updateSelectedView;
@end


/////////////////////////////////////////////////////////////////////////////////
@implementation OsdViewController

@synthesize viewControllers;
@synthesize tabBar;
@synthesize	horizonOsdTabBarItem;
@synthesize valuesOsdTabBarItem;
@synthesize mapOsdTabBarItem;
@synthesize selectedViewController;
@synthesize screenLockButton;

/////////////////////////////////////////////////////////////////////////////////

- (void)dealloc {
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  HorizonOsdViewController* horizonViewController=[[HorizonOsdViewController alloc]initWithNibName:@"HorizonOsdViewController" bundle:nil];
  ValueOsdViewController* valueViewController=[[ValueOsdViewController alloc]initWithNibName:@"ValueOsdViewController" bundle:nil];
  RawOsdViewController* rawViewController=[[RawOsdViewController alloc]initWithNibName:@"RawOsdViewController" bundle:nil];
  MapOsdViewController* mapViewController=[[MapOsdViewController alloc]initWithNibName:@"MapOsdViewController" bundle:nil];
  
  NSArray *array = [[NSArray alloc] initWithObjects:valueViewController, rawViewController, mapViewController, nil];
  self.viewControllers = array;
  
//  [self.view insertSubview:valueViewController.view belowSubview:self.tabBar];
//  self.selectedViewController = valueViewController;
  
  [array release];
//  [horizonViewController release];
  [valueViewController release];
  [rawViewController release];
  [mapViewController release];
  
  self.tabBar.selectedItem=self.valuesOsdTabBarItem;
  
  osdValue = [[OsdValue alloc] init];
  osdValue.delegate = self;
}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];

  [osdValue startRequesting];
  
//  [self.selectedViewController viewWillAppear:animated];

  [self.navigationController setToolbarHidden:YES animated:YES];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  
  self.navigationController.navigationBar.translucent=YES;
  
//  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action: nil] autorelease];
//  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"screenlock-locked.png"] style:UIBarButtonItemStylePlain target:self action: nil] autorelease];
  
  self.screenLockButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock.png"] forState:UIControlStateNormal];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock.png"] forState:UIControlStateDisabled];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock-locked.png"] forState:UIControlStateSelected];
  [self.screenLockButton setSelected:NO];
  
  [self.screenLockButton addTarget:self action:@selector(doScreenLock) forControlEvents:UIControlEventTouchUpInside];
  
  
  self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithCustomView:screenLockButton]autorelease];
  
  [self updateSelectedView];
  
  [[NSNotificationCenter defaultCenter] addObserver:self 
                                           selector:@selector(showNavigationBar) 
                                               name:UIApplicationWillResignActiveNotification 
                                             object:[UIApplication sharedApplication]];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateSelectedView];
  [self concealAfterDelay:2.0f];
}  

- (void) viewWillDisappear:(BOOL)animated
{
  if (self.navigationController.topViewController != self)
  {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.navigationBar.translucent=NO;
  }
  
  osdValue.delegate = nil;
  [osdValue stopRequesting];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

  [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  self.selectedViewController=nil;
  self.viewControllers=nil;
  self.screenLockButton=nil;
  
  [osdValue release];
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark - View rotation 

- (void)doScreenLock {
  [self.screenLockButton setSelected:!self.screenLockButton.selected];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  
  BOOL result=YES;
  
  if( self.screenLockButton.selected )
    return NO;
  
  for (UIViewController* controller in self.viewControllers) {
    result &= [controller shouldAutorotateToInterfaceOrientation:interfaceOrientation];
  }
  
  return result;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  for (UIViewController* controller in self.viewControllers) {
    [controller willRotateToInterfaceOrientation:orientation duration:duration];
  }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self updateSelectedViewFrame];
}

-(void) updateSelectedViewFrame {
  self.selectedViewController.view.frame=CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-CGRectGetHeight(self.tabBar.frame));
  
  [selectedViewController newValue:osdValue];
  
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
  if ([self.selectedViewController isKindOfClass:[MapOsdViewController class]]) {
    [((MapOsdViewController*)self.selectedViewController).mapView addGestureRecognizer:singleTap];  
  }
  else{
    [self.selectedViewController.view addGestureRecognizer:singleTap];
  }
  [singleTap release];    
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation bar Hideing 

- (void)showNavigationBar{
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  self.navigationController.navigationBar.translucent=NO;
}


- (void)conceal {
  qltrace(@"Hiding navigation bar");
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)concealAfterDelay:(NSTimeInterval)delay
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(conceal) object:nil];
  qltrace(@"Calling performSelector with delay %f",delay);
  [self performSelector:@selector(conceal) withObject:nil afterDelay:delay];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self concealAfterDelay:2.0f];
} 

/////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)updateSelectedView{
  UIViewController<OsdValueDelegate> *newSelectedViewController = [viewControllers objectAtIndex:tabBar.selectedItem.tag];
  
  [self.selectedViewController viewWillDisappear:NO];
  [self.selectedViewController.view removeFromSuperview];
  
  [self.view insertSubview:newSelectedViewController.view belowSubview:self.tabBar];
  self.selectedViewController = newSelectedViewController;
  [self.selectedViewController viewWillAppear:NO];
  [self updateSelectedViewFrame];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
  [self updateSelectedView];
}

- (void) newValue:(OsdValue*)value {
  [self.selectedViewController newValue:value];
}

- (void) noDataAvailable {
  if([self.selectedViewController respondsToSelector:@selector(noDataAvailable)])
    [self.selectedViewController noDataAvailable];
}


@end
