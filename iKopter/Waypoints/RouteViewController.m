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
#import "MKConnectionController.h"
#import "MKDataConstants.h"
#import "IKPoint.h"

@interface RouteViewController()

@property (retain) UIBarButtonItem* spacer;
@property (retain) UIBarButtonItem* addButton;
@property (retain) UIBarButtonItem* addWithGpsButton;
@property (retain) UIBarButtonItem* ulButton;
@property (retain) UIBarButtonItem* dlButton;
@property(retain) CLLocationManager *lm;


-(void) updateSelectedViewFrame;
-(void) changeView;
-(void) uploadRoute;
-(void) downloadRoute;
-(void) addPointWithGps;


@end

@implementation RouteViewController

@synthesize viewControllers;
@synthesize selectedViewController;
@synthesize route;
@synthesize segment;
@synthesize addButton;
@synthesize addWithGpsButton;
@synthesize spacer;
@synthesize ulButton;
@synthesize dlButton;
@synthesize lm;

/////////////////////////////////////////////////////////////////////////////////

- (id)initWithRoute:(Route*) theRoute {
  self = [super initWithNibName:@"RouteViewController" bundle:nil];
  if (self) {
    self.route=theRoute;
    self.title=NSLocalizedString(@"Route", @"Waypoint Lists title");
  }
  return self;
}

- (void)dealloc {
  self.selectedViewController = nil;
  self.viewControllers = nil;
  self.route = nil;
  self.addButton=nil;
  self.addWithGpsButton=nil;
  self.spacer=nil;
  self.dlButton=nil;
  self.ulButton=nil;
  self.lm = nil;
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  RouteListViewController*  listViewController=[[RouteListViewController alloc] initWithRoute:self.route];
  listViewController.surrogateParent=self;
  RouteMapViewController* mapViewController=[[RouteMapViewController alloc] initWithRoute:self.route];
  mapViewController.surrogateParent=self;
  
  NSArray *array = [[NSArray alloc] initWithObjects:listViewController, mapViewController, nil];
  self.viewControllers = array;
  [array release];
  
  [listViewController release];
  [mapViewController release];
  
  NSArray* segmentItems = [NSArray arrayWithObjects:@"List",@"Map",nil];
  segment = [[[UISegmentedControl alloc] initWithItems:segmentItems] autorelease];
  segment.segmentedControlStyle=UISegmentedControlStyleBar;
  
  segment.tintColor = [UIColor darkGrayColor];
  [segment setImage:[UIImage imageNamed:@"list-mode.png"] forSegmentAtIndex:0];
  [segment setWidth:50.0 forSegmentAtIndex:0];
  [segment setWidth:50.0 forSegmentAtIndex:1];
  [segment setImage:[UIImage imageNamed:@"map-mode.png"] forSegmentAtIndex:1];
  
  
  [segment addTarget:self
              action:@selector(changeView)
    forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem* segmentButton;
  segmentButton =  [[[UIBarButtonItem alloc]
                     initWithCustomView:segment] autorelease];
  
  [self.navigationItem setRightBarButtonItem:segmentButton animated:NO];
  
  self.spacer =  [[[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                   target:nil
                   action:nil] autorelease];
  
  
  self.addButton =  [[[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                      target:nil
                      action:@selector(addPoint)] autorelease];
  self.addButton.style = UIBarButtonItemStyleBordered;

  self.addWithGpsButton =  [[[UIBarButtonItem alloc]
                     initWithImage:[UIImage imageNamed:@"icon-add-gps.png"] 
                     style:UIBarButtonItemStyleBordered
                     target:self
                     action:@selector(addPointWithGps)] autorelease];

  
  if ([[MKConnectionController sharedMKConnectionController] isRunning]) {
    
    self.ulButton =  [[[UIBarButtonItem alloc]
                       initWithImage:[UIImage imageNamed:@"icon-ul1.png"] 
                       style:UIBarButtonItemStyleBordered
                       target:self
                       action:@selector(uploadRoute)] autorelease];
    
    self.dlButton =  [[[UIBarButtonItem alloc]
                       initWithImage:[UIImage imageNamed:@"icon-dl1.png"] 
                       style:UIBarButtonItemStyleBordered
                       target:nil
                       action:@selector(downloadRoute)] autorelease];
  }
  
  
  self.lm = [[[CLLocationManager alloc] init]autorelease];
  self.lm.delegate = self;
  self.lm.desiredAccuracy = kCLLocationAccuracyBest;
  
  segment.selectedSegmentIndex=0;
}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.route = nil;
  self.selectedViewController = nil;
  
  self.viewControllers = nil;
  self.addButton=nil;
  self.addWithGpsButton=nil;
  self.spacer=nil;
  self.dlButton=nil;
  self.ulButton=nil;
  self.lm = nil;

}

- (void) viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.selectedViewController viewWillAppear:animated];
  [self updateSelectedViewFrame];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(writePointNotification:)
             name:MKWritePointNotification
           object:nil];

}

- (void) viewWillDisappear:(BOOL)animated {
  [self.selectedViewController viewWillDisappear:NO];

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [self updateSelectedViewFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

-(void) updateSelectedViewFrame {
  self.selectedViewController.view.frame=CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 
                                                    CGRectGetHeight(self.view.bounds));
  
  self.addButton.target = self.selectedViewController;
  
  if ([self.selectedViewController isKindOfClass:[RouteListViewController class]]){
    if ([[MKConnectionController sharedMKConnectionController] isRunning]) {
      [self setToolbarItems:[NSArray arrayWithObjects:self.selectedViewController.editButtonItem,
                             self.spacer,
                             self.ulButton,
                             //self.dlButton,
                             self.spacer,
                             self.addWithGpsButton,
                             self.addButton,nil] animated:YES];
    }
    else{
      [self setToolbarItems:[NSArray arrayWithObjects:self.selectedViewController.editButtonItem,
                             self.spacer,self.addWithGpsButton,
                             self.addButton,nil] animated:YES];
    }
  } else {
    UIBarButtonItem* curlBarItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl
                                                                                  target:((RouteMapViewController*)self.selectedViewController).curlBarItem 
                                                                                  action:@selector(touched)]autorelease];
    
    if ([[MKConnectionController sharedMKConnectionController] isRunning]) {
      [self setToolbarItems:[NSArray arrayWithObjects:self.selectedViewController.editButtonItem,
                             self.spacer,
                             self.ulButton,
                             //self.dlButton,
                             self.spacer,
                             self.addWithGpsButton,
                             self.addButton,
                             curlBarItem, nil] animated:YES];
    }
    else{
      [self setToolbarItems:[NSArray arrayWithObjects:self.selectedViewController.editButtonItem,
                             self.spacer,
                             self.addButton,
                             self.addWithGpsButton,
                             curlBarItem, nil] animated:YES];
    }
  }
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITabBarDelegate

-(void) changeView{
  UIViewController *newSelectedViewController = [self.viewControllers objectAtIndex:segment.selectedSegmentIndex];
  
  [self.selectedViewController setEditing:NO animated:YES];
  [self.selectedViewController viewWillDisappear:NO];
  [self.selectedViewController.view removeFromSuperview];
  
  [self.view addSubview:newSelectedViewController.view];
  self.selectedViewController = newSelectedViewController;
  [self.selectedViewController viewWillAppear:NO];

  [self updateSelectedViewFrame];
}

#pragma mark - Up-/Download 

-(void) uploadClearPoint{
  
  IKPoint* p=[[[IKPoint alloc]init]autorelease];
  
  p.status = INVALID;
  p.index = 0;
  
  qlinfo(@"Upload clear list point %@",p);
  [[MKConnectionController sharedMKConnectionController] writePoint:p];
}


-(void) uploadPoint:(NSUInteger)index{

  IKPoint* p=(IKPoint*)[self.route.points objectAtIndex:index];
  qlinfo(@"Upload point (%d) %@",index,p);
  [[MKConnectionController sharedMKConnectionController] writePoint:p];
}

-(void) uploadRoute{
  currIndex=0;
  [self uploadClearPoint];
}

- (void) writePointNotification:(NSNotification *)aNotification {
  NSDictionary* d=[aNotification userInfo];
  NSInteger index = [[d objectForKey:kMKDataKeyIndex] integerValue]-1;

  qlinfo(@"Upload point (%d) finished",index);

  if (currIndex<[self.route.points count]) {
    [self uploadPoint:currIndex++];
  }
}


-(void) downloadRoute{
  
}

#pragma mark - CLLocationManagerDelegate Methods

-(void) addPointWithGps{
  [self.lm startUpdatingLocation];
}


- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
  
  if ([newLocation.timestamp timeIntervalSince1970] < [NSDate timeIntervalSinceReferenceDate] - 60)
    return;
  
  [manager stopUpdatingLocation];
  if([self.selectedViewController respondsToSelector:@selector(addPointWithLocation:)])
    [self.selectedViewController addPointWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager 
       didFailWithError:(NSError *)error {
  
  NSString *errorType = (error.code == kCLErrorDenied) ? 
  NSLocalizedString(@"Access Denied", @"Access Denied") : 
  NSLocalizedString(@"Unknown Error", @"Unknown Error");
  
  UIAlertView *alert = [[UIAlertView alloc] 
                        initWithTitle:NSLocalizedString(@"Error getting Location", @"Error getting Location")
                        message:errorType 
                        delegate:self 
                        cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") 
                        otherButtonTitles:nil];
  [alert show];
  [alert release];
  [manager release];
}

@end

