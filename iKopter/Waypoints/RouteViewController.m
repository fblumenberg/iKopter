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

#import "RouteViewController.h"
#import "RouteListViewController.h"
#import "RouteMapViewController.h"
#import "RouteController.h"
#import "UIViewController+SplitView.h"

#import "MKConnectionController.h"
#import "MKDataConstants.h"
#import "IKPoint.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+RFhelpers.h"


@interface RouteViewController ()

@property(retain) UIBarButtonItem *spacer;
@property(retain) UIBarButtonItem *addButton;
@property(retain) UIBarButtonItem *addWithGpsButton;
@property(retain) UIBarButtonItem *ulButton;
@property(retain) UIBarButtonItem *dlButton;
@property(retain) UIBarButtonItem *wpGenButton;
@property(retain) CLLocationManager *lm;
@property(retain) RouteController *routeController;


- (void)updateSelectedViewFrame;
- (void)changeView;
- (void)uploadRoute;
- (void)downloadRoute;
- (void)addPointWithGps;
- (void)showWpGenerator;


@end

@implementation RouteViewController

@synthesize viewControllers;
@synthesize selectedViewController;
@synthesize route;
@synthesize routeController;
@synthesize segment=_segment;
@synthesize addButton;
@synthesize addWithGpsButton;
@synthesize spacer;
@synthesize ulButton;
@synthesize dlButton;
@synthesize wpGenButton;
@synthesize lm;

/////////////////////////////////////////////////////////////////////////////////

- (id)initWithRoute:(Route *)theRoute {
  self = [super initWithNibName:@"RouteViewController" bundle:nil];
  if (self) {
    self.route = theRoute;
    self.title = NSLocalizedString(@"Route", @"Waypoint Lists title");
  }
  return self;
}

- (void)dealloc {
  self.selectedViewController = nil;
  self.viewControllers = nil;
  self.route = nil;
  self.addButton = nil;
  self.addWithGpsButton = nil;
  self.spacer = nil;
  self.dlButton = nil;
  self.ulButton = nil;
  self.wpGenButton = nil;
  self.routeController = nil;
  self.segment = nil;

  [self.lm stopUpdatingLocation];
  self.lm.delegate = nil;
  self.lm = nil;

  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  RouteListViewController *listViewController = [[RouteListViewController alloc] initWithRoute:self.route];
  listViewController.surrogateParent = self;
  RouteMapViewController *mapViewController = [[RouteMapViewController alloc] initWithRoute:self.route];
  mapViewController.surrogateParent = self;

  NSArray *array = [[NSArray alloc] initWithObjects:listViewController, mapViewController, nil];
  self.viewControllers = array;
  [array release];

  [listViewController release];
  [mapViewController release];

  NSArray *segmentItems = [NSArray arrayWithObjects:@"List", @"Map", nil];
  self.segment = [[[UISegmentedControl alloc] initWithItems:segmentItems] autorelease];
  self.segment.segmentedControlStyle = UISegmentedControlStyleBar;

  self.segment.tintColor = [UIColor darkGrayColor];
  [self.segment setImage:[UIImage imageNamed:@"list-mode.png"] forSegmentAtIndex:0];
  [self.segment setWidth:50.0 forSegmentAtIndex:0];
  [self.segment setWidth:50.0 forSegmentAtIndex:1];
  [self.segment setImage:[UIImage imageNamed:@"map-mode.png"] forSegmentAtIndex:1];


  [self.segment addTarget:self
              action:@selector(changeView)
    forControlEvents:UIControlEventValueChanged];

  UIBarButtonItem *segmentButton;
  segmentButton = [[[UIBarButtonItem alloc]
          initWithCustomView:self.segment] autorelease];

  if (!self.isPad)
    [self.navigationItem setRightBarButtonItem:segmentButton animated:NO];

  self.spacer = [[[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil] autorelease];

  self.wpGenButton = [[[UIBarButtonItem alloc] initWithTitle:@"WP" 
                                                      style:UIBarButtonItemStyleBordered 
                                                      target:self action:@selector(showWpGenerator)]autorelease];

  self.addButton = [[[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                               target:nil action:@selector(addPoint)] autorelease];
  self.addButton.style = UIBarButtonItemStyleBordered;

  self.addWithGpsButton = [[[UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"icon-add-gps.png"]
                  style:UIBarButtonItemStyleBordered
                 target:self
                 action:@selector(addPointWithGps)] autorelease];


  if ([[MKConnectionController sharedMKConnectionController] isRunning]) {

    self.ulButton = [[[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"icon-ul1.png"]
                    style:UIBarButtonItemStyleBordered
                   target:self
                   action:@selector(uploadRoute)] autorelease];

    self.dlButton = [[[UIBarButtonItem alloc]
            initWithImage:[UIImage imageNamed:@"icon-dl1.png"]
                    style:UIBarButtonItemStyleBordered
                   target:self
                   action:@selector(downloadRoute)] autorelease];
  }


  self.lm = [[[CLLocationManager alloc] init] autorelease];
  self.lm.delegate = self;
  self.lm.desiredAccuracy = kCLLocationAccuracyBest;

  if ([[CLLocationManager class] respondsToSelector:@selector(authorizationStatus)]) {
    self.addWithGpsButton.enabled = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
  }
  else {
    self.addWithGpsButton.enabled = [CLLocationManager locationServicesEnabled];
  }

  self.segment.selectedSegmentIndex = 0;
}

- (void)viewDidUnload {
  [super viewDidUnload];

  self.route = nil;
  self.selectedViewController = nil;

  self.viewControllers = nil;
  self.addButton = nil;
  self.addWithGpsButton = nil;
  self.spacer = nil;
  self.dlButton = nil;
  self.ulButton = nil;

  [self.lm stopUpdatingLocation];
  self.lm.delegate = nil;
  self.lm = nil;

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self changeView];

  self.routeController = [[[RouteController alloc] initWithDelegate:self] autorelease];

  if (self.isPad) {
    UIViewController *newSelectedViewController = [self.viewControllers objectAtIndex:1];
    [self.detailViewController pushViewController:newSelectedViewController animated:YES];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  self.routeController = nil;
  [self.selectedViewController viewWillDisappear:NO];

  if (self.isPad) {
    [self.detailViewController popViewControllerAnimated:YES];
  }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self updateSelectedViewFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)updateSelectedViewFrame {
  self.selectedViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds),
          CGRectGetHeight(self.view.bounds));

  self.addButton.target = self.selectedViewController;
  
  NSMutableArray *tbArray = [NSMutableArray array];
  
  if ([self.selectedViewController isKindOfClass:[RouteListViewController class]]) 
    [tbArray addObject:self.selectedViewController.editButtonItem];
  else {
    UIBarButtonItem *curlBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl
                                                                                  target:((RouteMapViewController *) self.selectedViewController).curlBarItem
                                                                                  action:@selector(touched)] autorelease];
    [tbArray addObject:curlBarItem];
  }
  
  if(!self.isPad){
    [tbArray addObject:self.wpGenButton];
  }

  
  if ([[MKConnectionController sharedMKConnectionController] isRunning]) {
    [tbArray addObject:spacer];
    [tbArray addObject:self.ulButton];
  }

  [tbArray addObject:spacer];
  [tbArray addObject:self.addWithGpsButton];
  [tbArray addObject:self.addButton];
  
  [self setToolbarItems:tbArray animated:YES];
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITabBarDelegate

- (void)changeView {
  UIViewController *newSelectedViewController = [self.viewControllers objectAtIndex:self.segment.selectedSegmentIndex];

  [self.selectedViewController setEditing:NO animated:YES];
  [self.selectedViewController viewWillDisappear:NO];
  [self.selectedViewController.view removeFromSuperview];

  [self.view addSubview:newSelectedViewController.view];
  self.selectedViewController = newSelectedViewController;
  [self.selectedViewController viewWillAppear:NO];

  [self updateSelectedViewFrame];
}

#pragma mark - Upload

- (void)downloadRoute {
  [routeController downloadRouteFromNaviCtrl];
}

#pragma mark - RouteControllerDelegate

- (void)routeControllerFinishedDownload:(RouteController *)controller {
  qldebug(@"Downloaded route from NC %@", routeController.route);
  qldebug(@"Downloaded route from NC %@", controller.route.points);
}


- (void)uploadRoute {
  [self.routeController uploadRouteToNaviCtrl:self.route];
}

- (void)routeControllerFinishedUpload:(RouteController *)controller {

  MBProgressHUD *hud = [MBProgressHUD sharedNotificationHUD];

  hud.customView = [[[UIImageView alloc] initWithImage:
          [UIImage imageNamed:@"icon-check.png"]] autorelease];
  hud.mode = MBProgressHUDModeCustomView;
  hud.labelText = NSLocalizedString(@"Upload successful", @"Route Upload success");
  [hud show:YES];
  [hud hide:YES afterDelay:0.7];
}


#pragma mark - WPGenerator

- (void)showWpGenerator{
  if(!self.isPad){
   
    RouteMapViewController* controller = [[RouteMapViewController alloc] initWithRoute:self.route];
    
    controller.forWpGenModal = YES;
    
    UINavigationController *modalNavController = [[UINavigationController alloc]
                                                  initWithRootViewController:controller];
    
    [self.navigationController presentModalViewController:modalNavController
                                                 animated:YES];
    
    [controller release];
    [modalNavController release];
  }
}


#pragma mark - CLLocationManagerDelegate Methods

- (void)addPointWithGps {
  [self.lm startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {

  if ([newLocation.timestamp timeIntervalSince1970] < [NSDate timeIntervalSinceReferenceDate] - 60)
    return;

  [manager stopUpdatingLocation];
  if ([self.selectedViewController respondsToSelector:@selector(addPointWithLocation:)])
    [self.selectedViewController addPointWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

  NSString *errorType = (error.code == kCLErrorDenied) ?
          NSLocalizedString(@"Access Denied", @"Access Denied") :
          NSLocalizedString(@"Unknown Error", @"Unknown Error");

  UIAlertView *alert = [[UIAlertView alloc]
          initWithTitle:NSLocalizedString(@"Error getting Location", @"Error getting Location") message:errorType
               delegate:self
      cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil];
  [alert show];
  [alert release];


  if ([[CLLocationManager class] respondsToSelector:@selector(authorizationStatus)]) {
    self.addWithGpsButton.enabled = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
  }
  else {
    self.addWithGpsButton.enabled = [CLLocationManager locationServicesEnabled];
  }

  self.lm = nil;
}

@end