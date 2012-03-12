// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
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

#import "OsdTabBarController.h"
#import "ValueOsdViewController.h"
#import "MapOsdViewController.h"
#import "FollowMeOsdViewController.h"
#import "RawOsdViewController.h"

#import "UIViewController+SplitView.h"

/////////////////////////////////////////////////////////////////////////////////
@interface OsdTabBarController ()
- (void)conceal;
- (void)concealAfterDelay:(NSTimeInterval)delay;
- (void)doScreenLock;
- (void)showNavigationBar;

- (void)updateSelectedView;
- (void)dismissView;
//- (void)updateSelectedViewFrame;

@property(nonatomic, retain) UIButton *screenLockButton;
@property(nonatomic, retain) OsdValue *osdValue;
@property(nonatomic, retain) FollowMeOsdViewController *followMeViewController;
@end


@implementation OsdTabBarController


@synthesize screenLockButton;
@synthesize osdValue;
@synthesize followMeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.delegate = self;


    NSString *nibName;
    nibName = @"ValueOsdViewController";
    if (self.isPad) nibName = [nibName stringByAppendingString:@"-iPad"];
    ValueOsdViewController *valueViewController = [[[ValueOsdViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    valueViewController.tabBarItem.title = NSLocalizedString(@"Values", @"Values tab item");
    valueViewController.tabBarItem.image = [UIImage imageNamed:@"tabValues.png"];

    nibName = @"RawOsdViewController";
//    if(self.isPad) nibName = [nibName stringByAppendingString:@"-iPad"];
    RawOsdViewController *rawViewController = [[[RawOsdViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    rawViewController.tabBarItem.title = NSLocalizedString(@"Raw Values", @"Raw Values tab item");
    rawViewController.tabBarItem.image = [UIImage imageNamed:@"icon-receipt.png"];

    nibName = @"MapOsdViewController";
    if (self.isPad) nibName = [nibName stringByAppendingString:@"-iPad"];
    MapOsdViewController *mapViewController = [[[MapOsdViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    mapViewController.tabBarItem.title = NSLocalizedString(@"Map", @"Map tab item");
    mapViewController.tabBarItem.image = [UIImage imageNamed:@"icon-map1.png"];

    nibName = @"FollowMeOsdViewController";
    if (self.isPad) nibName = [nibName stringByAppendingString:@"-iPad"];
    self.followMeViewController = [[[FollowMeOsdViewController alloc] initWithNibName:nibName bundle:nil] autorelease];
    self.followMeViewController.tabBarItem.title = NSLocalizedString(@"Follow Me", @"Follow me tab item");
    self.followMeViewController.tabBarItem.image = [UIImage imageNamed:@"icon-flying.png"];
    self.followMeViewController.osdValue = self.osdValue;
    self.viewControllers = [NSArray arrayWithObjects:
            valueViewController,
            mapViewController,
            self.followMeViewController,
            rawViewController,
            nil];
    self.selectedViewController = valueViewController;

  }
  return self;
}

- (void)dealloc {
  self.screenLockButton = nil;
  self.osdValue = nil;
  self.followMeViewController = nil;

  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

/////////////////////////////////////////////////////////////////////////////////
#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];

  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"OSD BackButton") style:UIBarButtonItemStyleBordered
                                                              target:self
                                                              action:@selector(dismissView)];
  self.navigationItem.leftBarButtonItem = backItem;
  [backItem release];

  self.screenLockButton = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock.png"] forState:UIControlStateNormal];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock.png"] forState:UIControlStateDisabled];
  [self.screenLockButton setImage:[UIImage imageNamed:@"screenlock-locked.png"] forState:UIControlStateSelected];
  [self.screenLockButton setSelected:NO];

  [self.screenLockButton addTarget:self action:@selector(doScreenLock) forControlEvents:UIControlEventTouchUpInside];


  self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:screenLockButton] autorelease];


  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
  self.navigationController.navigationBar.translucent = YES;


  self.osdValue = [[[OsdValue alloc] init] autorelease];
  self.osdValue.delegate = self;

  self.followMeViewController.osdValue = self.osdValue;
}

- (void)viewDidUnload {
  [super viewDidUnload];

  self.screenLockButton = nil;
  self.osdValue = nil;
  self.followMeViewController = nil;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self updateSelectedView];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(dismissView)
                                               name:UIApplicationWillResignActiveNotification
                                             object:[UIApplication sharedApplication]];

  osdValue.delegate = self;
  [osdValue startRequesting];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [self concealAfterDelay:2.0f];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

  osdValue.delegate = nil;
  [osdValue stopRequesting];
}

- (void)dismissView {
  [self dismissModalViewControllerAnimated:YES];
}

/////////////////////////////////////////////////////////////////////////////////
#pragma mark - View rotation 

- (void)doScreenLock {
  [self.screenLockButton setSelected:!self.screenLockButton.selected];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

  BOOL result = YES;

  if (self.screenLockButton.selected)
    return NO;

  for (UIViewController *controller in self.viewControllers) {
    result &= [controller shouldAutorotateToInterfaceOrientation:interfaceOrientation];
  }

  return result;
}

/////////////////////////////////////////////////////////////////////////////////

- (void)updateSelectedView {

  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
  if ([self.selectedViewController isKindOfClass:[MapOsdViewController class]]) {
    [((MapOsdViewController *) self.selectedViewController).mapView addGestureRecognizer:singleTap];
  }
  else {
    [self.selectedViewController.view addGestureRecognizer:singleTap];
  }
  [singleTap release];

  [self newValue:self.osdValue];
}

/////////////////////////////////////////////////////////////////////////////////
#pragma mark - Navigation bar Hideing 

- (void)showNavigationBar {
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  self.navigationController.navigationBar.translucent = NO;
}


- (void)conceal {
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)concealAfterDelay:(NSTimeInterval)delay {
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(conceal) object:nil];
  [self performSelector:@selector(conceal) withObject:nil afterDelay:delay];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  [self concealAfterDelay:2.0f];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

  [self updateSelectedView];
}

/////////////////////////////////////////////////////////////////////////////////
#pragma - OsdValueDelegate
- (void)newValue:(OsdValue *)value {

  if ([self.selectedViewController respondsToSelector:@selector(newValue:)])
    [(id <OsdValueDelegate>) self.selectedViewController newValue:value];
}

- (void)noDataAvailable {
  if ([self.selectedViewController respondsToSelector:@selector(noDataAvailable)])
    [(id <OsdValueDelegate>) self.selectedViewController noDataAvailable];
}

@end
