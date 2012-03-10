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
// ///////////////////////////////////////////////////////////////////////////////


#import <MapKit/MapKit.h>
#import "RouteMapViewController.h"
#import "IKPoint.h"
#import "MapLocation.h"
#import "WaypointViewController.h"
#import "HeadingOverlayView.h"
#import "HeadingOverlay.h"
#import "UIViewController+SplitView.h"

#import "WPGenAreaViewController.h"
#import "WPGenCircleViewController.h"

@interface RouteMapViewController ()<WPGenBaseViewControllerDelegate>

- (void)updateRouteOverlay;
- (void)routeChangedNotification:(NSNotification *)aNotification;
- (void)updateMapView;
- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer;

- (void)showWpGen:(id)sender;
- (void)generateWayPoints;
- (void)configWayPoints:(id)sender;
- (void)updateWpToolbar;

@property(nonatomic,retain)WPGenBaseViewController *wpgenController;
@property(retain) IBOutlet UISegmentedControl *wpGeneratorSelection;
@property(retain) IBOutlet UIBarButtonItem *wpGenerateItem;
@property(retain) IBOutlet UIBarButtonItem *wpGenerateConfigItem;

@end


@implementation RouteMapViewController

@synthesize route;
@synthesize scaleLabel;
@synthesize mapView;
@synthesize curlBarItem;
@synthesize segmentedControl;
@synthesize surrogateParent;

@synthesize wpgenController;
@synthesize wpGenerateItem;
@synthesize wpGeneratorSelection;
@synthesize wpGenerateConfigItem;

- (id)initWithRoute:(Route *)theRoute {
  self = [super initWithNibName:@"RouteMapViewController" bundle:nil];
  if (self) {
    qltrace(@"Initialized");
    self.route = theRoute;
  }
  return self;
}

- (void)dealloc {
  self.route = nil;
  self.curlBarItem = nil;
  self.mapView = nil;
  self.segmentedControl = nil;
  self.scaleLabel = nil;
  self.wpgenController = nil;
  self.wpGenerateItem=nil;
  self.wpGeneratorSelection=nil;
  self.wpGenerateConfigItem=nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  qltrace(@"View loaded");

  self.curlBarItem = [[[FDCurlViewControl alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl] autorelease];
  [self.curlBarItem setHidesWhenAnimating:NO];
  [self.curlBarItem setTargetView:self.mapView];

  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.curlBarItem
                                                                              action:@selector(curlViewDown)];
  [self.view addGestureRecognizer:singleTap];
  [singleTap release];

  self.segmentedControl.selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"RouteMapViewType"];
  [self changeMapViewType];

  UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];

  [self.mapView addGestureRecognizer:longTap];
  [longTap release];
  
  if (self.isPad) {
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem *curlBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl
                                                                                        target:self.curlBarItem
                                                                                        action:@selector(touched)] autorelease];

    UIBarButtonItem *spacer = [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil action:nil] autorelease];


    self.wpGenerateItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Generate", @"Gernerate WP")  
                                                                           style:UIBarButtonItemStyleBordered 
                                                                          target:self action:@selector(generateWayPoints)] autorelease];


    self.wpGenerateConfigItem  = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"CFG", @"Gernerate WP")  
                                                            style:UIBarButtonItemStyleBordered 
                                                                  target:self action:@selector(configWayPoints:)] autorelease];

    NSArray *segmentItems = [NSArray arrayWithObjects:@"AREA", @"CIRCLE", @"PANO", nil];
    self.wpGeneratorSelection = [[[UISegmentedControl alloc] initWithItems:segmentItems] autorelease];
    self.wpGeneratorSelection.segmentedControlStyle = UISegmentedControlStyleBar;
    
//    [self.segment setImage:[UIImage imageNamed:@"list-mode.png"] forSegmentAtIndex:0];
//    [self.segment setWidth:50.0 forSegmentAtIndex:0];
//    [self.segment setWidth:50.0 forSegmentAtIndex:1];
//    [self.segment setImage:[UIImage imageNamed:@"map-mode.png"] forSegmentAtIndex:1];

    self.wpGeneratorSelection.momentary = YES;
    
    [self.wpGeneratorSelection addTarget:self
                                  action:@selector(showWpGen:)
           forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *segmentButton;
    segmentButton = [[[UIBarButtonItem alloc]
                      initWithCustomView:self.wpGeneratorSelection] autorelease];

    [self setToolbarItems:[NSArray arrayWithObjects:curlBarButtonItem, spacer, self.wpGenerateConfigItem, self.wpGenerateItem, segmentButton, nil] 
                 animated:YES];

    self.navigationController.toolbarHidden = NO;
    [self updateWpToolbar];

  }
}

- (void)viewDidUnload {
  self.curlBarItem = nil;
  self.mapView = nil;
  self.segmentedControl = nil;
  self.scaleLabel = nil;
  self.wpGenerateItem=nil;
  self.wpGeneratorSelection=nil;
  self.wpgenController=nil;
  self.wpGenerateConfigItem=nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.mapView.delegate = self;
  [self updateMapView];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(routeChangedNotification:)
                                               name:MKRouteChangedNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  self.mapView.delegate = nil;
  [self.mapView removeAnnotations:self.mapView.annotations];
}


- (void)updateMapView {
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotations:route.points];
  [self updateRouteOverlay];

  if ([route.points count] > 1) {

    MKMapRect flyTo = MKMapRectNull;

    for (id <MKOverlay> overlay in mapView.overlays) {
      if (MKMapRectIsNull(flyTo)) {
        flyTo = [overlay boundingMapRect];
      } else {
        flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
      }
    }

    for (id <MKAnnotation> annotation in mapView.annotations) {
      MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
      MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);

      if (MKMapRectIsNull(flyTo)) {
        flyTo = pointRect;
      } else {
        flyTo = MKMapRectUnion(flyTo, pointRect);
      }
    }

    flyTo = [mapView mapRectThatFits:flyTo];

    // Position the map so that all overlays and annotations are visible on screen.
    [mapView setVisibleMapRect:flyTo animated:YES];
  }
  else if ([route.points count] == 1) {
    IKPoint *pt = [route.points objectAtIndex:0];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pt.coordinate, 2000, 2000);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
  }
  else {
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([Route defaultCoordinate], 2000, 2000);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
  }
}

- (void)addPoint {
  qltrace(@"addPoint route list");
  NSIndexPath *editingPoint = [self.route addPointAtCenter];

  IKPoint *point = [self.route pointAtIndexPath:editingPoint];
  [mapView addAnnotation:point];
  [self updateRouteOverlay];
}

- (void)addPointWithLocation:(CLLocation *)location {
  qltrace(@"addPoint route list");
  NSIndexPath *editingPoint = [self.route addPointAtCoordinate:location.coordinate];

  IKPoint *point = [self.route pointAtIndexPath:editingPoint];
  [mapView addAnnotation:point];
  [self updateRouteOverlay];
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer{
  CGPoint p = [gestureRecognizer locationInView:self.mapView];
  NSLog(@"Long press %@ %d",NSStringFromCGPoint(p),gestureRecognizer.state);
  
  if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
    CLLocationCoordinate2D coordinate=[self.mapView convertPoint:p toCoordinateFromView:self.mapView];
    NSIndexPath *editingPoint = [self.route addPointAtCoordinate:coordinate];
    
    IKPoint *point = [self.route pointAtIndexPath:editingPoint];
    [mapView addAnnotation:point];
    [self updateRouteOverlay];
    [Route sendChangedNotification:self];
  }
}

#pragma mark - Page Curl stuff

- (void)changeMapViewType {
  [self.mapView setMapType:self.segmentedControl.selectedSegmentIndex];
  [self.curlBarItem curlViewDown];
  [[NSUserDefaults standardUserDefaults] setInteger:self.segmentedControl.selectedSegmentIndex forKey:@"RouteMapViewType"];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation {

  static NSString *pointIdentifier = @"IKPointIdentifier";

  if ([annotation isKindOfClass:[IKPoint class]]) {

    MKAnnotationView *annotationView;

    annotationView = [theMapView dequeueReusableAnnotationViewWithIdentifier:pointIdentifier];
    if (annotationView == nil)
      annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointIdentifier] autorelease];

    annotationView.annotation = annotation;
    ((MKPinAnnotationView *) annotationView).animatesDrop = NO;
    ((MKPinAnnotationView *) annotationView).pinColor = ((IKPoint *) annotation).type == POINT_TYPE_WP ? MKPinAnnotationColorGreen : MKPinAnnotationColorPurple;

    UIButton* closeButton=[UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(0, 0, 29, 29);
    [closeButton setImage:[UIImage imageNamed:@"CloseButton.png"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"CloseButtonPressed.png"] forState:UIControlStateHighlighted];

    annotationView.leftCalloutAccessoryView = closeButton;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.draggable = YES;

    return annotationView;
  }
  return nil;
}


- (void)mapViewDidFailLoadingMap:(MKMapView *)theMapView withError:(NSError *)error {
  UIAlertView *alert = [[UIAlertView alloc]
          initWithTitle:NSLocalizedString(@"Error loading map", @"Error loading map") message:[error localizedDescription]
               delegate:nil cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
  
  if ([view.annotation isKindOfClass:[IKPoint class]]) {
    IKPoint *point = (IKPoint *) view.annotation;
    
    if( view.rightCalloutAccessoryView==control){
      WaypointViewController *hostView = [[[WaypointViewController alloc] initWithPoint:point] autorelease];
      
      if (self.isPad) {
        UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:hostView];
        popOverController.delegate = self;
        popOverController.popoverContentSize = CGSizeMake(320, 500);
        
        
        CGRect rect = CGRectMake(CGRectGetMidX(view.bounds)+view.calloutOffset.x-3, 0, 3, 1);
        [popOverController presentPopoverFromRect:rect inView:view
                         permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        [self.mapView deselectAnnotation:[view annotation] animated:NO];
      }
      else {
        [self.surrogateParent.navigationController pushViewController:hostView animated:YES];
      }
    }
    else {
      [self.route deletePointAtIndexPath:[NSIndexPath indexPathForRow:(point.index-1) inSection:0]];
    }
  }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [popoverController release];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {

  if ([overlay isKindOfClass:[MKPolyline class]]) {

    MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
    polylineView.strokeColor = [UIColor blueColor];
    polylineView.lineWidth = 1.5;
    return polylineView;
  }
  else if ([overlay isKindOfClass:[HeadingOverlay class]]) {

    HeadingOverlayView *circleView = [[[HeadingOverlayView alloc] initWithHeadingOverlay:overlay] autorelease];
    circleView.strokeColor = [UIColor yellowColor];

    circleView.fillColor = [circleView.strokeColor colorWithAlphaComponent:0.4];
    circleView.lineWidth = 1.5;
    return circleView;
  }
  else if ([overlay isKindOfClass:[MKCircle class]]) {
    MKCircleView *circleView = [[[MKCircleView alloc] initWithCircle:overlay] autorelease];
    if ([((MKCircle *) overlay).title length] > 0) {
      circleView.strokeColor = [UIColor redColor];
    }
    else {
      circleView.strokeColor = [UIColor greenColor];
    }
    circleView.fillColor = [circleView.strokeColor colorWithAlphaComponent:0.4];
    circleView.lineWidth = 1.5;
    return circleView;
  }

  return nil;
}

- (void)mapView:(MKMapView *)mapView
    annotationView:(MKAnnotationView *)view
didChangeDragState:(MKAnnotationViewDragState)newState
      fromOldState:(MKAnnotationViewDragState)oldState {

  if (newState == MKAnnotationViewDragStateEnding || newState == MKAnnotationViewDragStateDragging) {
    [self updateRouteOverlay];
    [Route sendChangedNotification:self];
  }
}

-(void) mapView:(MKMapView *)theMapView regionDidChangeAnimated:(BOOL)animated{
  CGRect frame=scaleLabel.frame;
  
  CGFloat maxLabelWidth=150;
  CGPoint p1=CGPointMake(0, CGRectGetMinY(frame));
  CGPoint p2=CGPointMake(maxLabelWidth, CGRectGetMinY(frame));
  
  CLLocationCoordinate2D lc1=[theMapView convertPoint:p1 toCoordinateFromView:self.mapView];
  CLLocationCoordinate2D lc2=[theMapView convertPoint:p2 toCoordinateFromView:self.mapView];
  CLLocation *l1 = [[[CLLocation alloc] initWithLatitude:lc1.latitude longitude:lc1.longitude]autorelease];
  CLLocation *l2 = [[[CLLocation alloc] initWithLatitude:lc2.latitude longitude:lc2.longitude]autorelease];
  CLLocationDistance dist = [l1 distanceFromLocation:l2];
  
  CGFloat labelWidth=maxLabelWidth;
  
  NSInteger widthFactor;
  CGFloat   mul;
  for(widthFactor=6;widthFactor>0;widthFactor--){
    mul = pow(10, widthFactor);
    
    labelWidth = (mul*maxLabelWidth)/dist;
    if(labelWidth < maxLabelWidth)
      break;
  }
  

  if(labelWidth<(maxLabelWidth/5)){
    labelWidth*=5;
    mul*=5;
  }
  else if(labelWidth<(maxLabelWidth/2)){
    labelWidth*=2;
    mul*=2;
  }
  
  
  if (widthFactor>2) {
    scaleLabel.text = [NSString stringWithFormat:@"%d km",(int)(mul/1000)];
  }
  else{
    scaleLabel.text = [NSString stringWithFormat:@"%d m",(int)(mul)];
  }
  
  CGFloat rightX=CGRectGetMaxX(frame);
  scaleLabel.frame = CGRectMake(rightX-labelWidth, frame.origin.y, labelWidth, frame.size.height);
}


#pragma mark Overlays

- (void)updateRouteOverlay {
  CLLocationCoordinate2D coordinates[[self.route.points count]];

  [self.mapView removeOverlays:self.mapView.overlays];

  int i = 0;
  for (IKPoint *p in self.route.points) {
    if (p.type == POINT_TYPE_WP) {
      coordinates[i] = p.coordinate;

      MKCircle *c = [MKCircle circleWithCenterCoordinate:p.coordinate radius:p.toleranceRadius];
      if (i == 0)
        c.title = @"start";

      [self.mapView addOverlay:c];

      BOOL createOverlay = YES;
      if (p.heading != 0) {

        double angle = p.heading;
        if (p.heading < 0) {

          int idx = (-p.heading) - 1;
          if (idx >= 0 && idx < [route.points count]) {

            IKPoint *poi = [route.points objectAtIndex:idx];

            MKMapPoint pPoint = MKMapPointForCoordinate(p.coordinate);
            MKMapPoint poiPoint = MKMapPointForCoordinate(poi.coordinate);

            double ank = poiPoint.x - pPoint.x;
            double gek = poiPoint.y - pPoint.y;

            angle = (atan(gek / ank) * 180.0) / M_PI;
            if (ank < 0)
              angle += 180.0;
          }
          else {
            createOverlay = NO;
          }
        }
        else {
          angle -= 90.0;
        }
        if (createOverlay) {
          HeadingOverlay *h = [HeadingOverlay headingWithCenterCoordinate:p.coordinate radius:10 angle:angle];
          [self.mapView addOverlay:h];
        }
      }

      i++;

    }
  }

  [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coordinates count:i]];

  qltrace(@"Overlays %@", self.mapView.overlays);
}

- (void)routeChangedNotification:(NSNotification *)aNotification {
  if (![aNotification.object isEqual:self])
    [self updateMapView];
}

#pragma mark - Waypoint Generator

- (void)updateWpToolbar{
  self.wpGenerateItem.enabled = self.wpgenController!=nil;
  self.wpGeneratorSelection.enabled = self.wpgenController==nil;
}

- (void)showWpGen:(id)sender{

  switch (self.wpGeneratorSelection.selectedSegmentIndex) {
    case 0:
      self.wpgenController = [[[WPGenAreaViewController alloc] initForMapView:self.mapView]autorelease];
      break;
      
    case 1:
      self.wpgenController = [[[WPGenCircleViewController alloc] initForMapView:self.mapView]autorelease];
      break;

    default:
      self.wpgenController = nil;
      break;
  }
  self.wpgenController.delegate = self;
  
  [self updateWpToolbar];
  [self.mapView addSubview: self.wpgenController.view];
  
}

- (void) generateWayPoints {
  [self.wpgenController generatePoints:self];
}

- (void)configWayPoints:(id)sender{
  [self.wpgenController showConfig:sender];
}

#pragma mark - Waypoint Generator Delegate

- (void) controllerWillClose:(WPGenBaseViewController*)controller{
  self.wpgenController=nil;
  [self updateWpToolbar];
}

- (void) controller:(WPGenBaseViewController*)controller generatedPoints:(NSArray*)points clearList:(BOOL)clear {
  
  if(clear)
    [self.route removeAllPoints];
  
  [self.route addPoints:points];
  
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotations:route.points];
  [self updateRouteOverlay];

  [Route sendChangedNotification:self];
}


@end
