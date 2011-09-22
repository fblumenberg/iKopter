//
//  RouteMapViewController.m
//  iKopter
//
//  Created by Frank Blumenberg on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RouteMapViewController.h"
#import "IKPoint.h"
#import "MapLocation.h"
#import "WaypointViewController.h"
#import "HeadingOverlayView.h"
#import "HeadingOverlay.h"
#import "UIViewController+SplitView.h"

@interface RouteMapViewController()

-(void)updateRouteOverlay;

@end


@implementation RouteMapViewController

@synthesize route;
@synthesize mapView;
@synthesize curlBarItem;
@synthesize segmentedControl;
@synthesize surrogateParent;

- (id)initWithRoute:(Route*) theRoute {
  self = [super initWithNibName:@"RouteMapViewController" bundle:nil];
  if (self) {
    qltrace(@"Initialized");
    self.route = theRoute;
  }
  return self;
}

- (void)dealloc
{
  self.route = nil;
  self.curlBarItem = nil;
  self.mapView = nil;
  self.segmentedControl = nil;
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
  
  qltrace(@"View loaded");
  
  self.curlBarItem = [[[FDCurlViewControl alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl]autorelease];
  [self.curlBarItem setHidesWhenAnimating:NO];
  [self.curlBarItem setTargetView:self.mapView];
  
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.curlBarItem 
                                                                              action:@selector(curlViewDown)];  
  [self.view addGestureRecognizer:singleTap];
  [singleTap release];    
  
  NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"RouteMapViewType"];
  if (testValue) {
    self.segmentedControl.selectedSegmentIndex=[[NSUserDefaults standardUserDefaults] integerForKey:@"RouteMapViewType"];
    [self changeMapViewType];
  }
  
}

- (void)viewDidUnload
{
  self.curlBarItem = nil;
  self.mapView = nil;
  self.segmentedControl = nil;
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotations:route.points];
  [self updateRouteOverlay];

  if([route.points count]>1){
    
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
  else if([route.points count]==1){
    IKPoint* pt=[route.points objectAtIndex:0];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(pt.coordinate, 2000, 2000); 
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
  }
  else{
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance([Route defaultCoordinate], 2000, 2000); 
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
  }
  
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)addPoint{
  qltrace(@"addPoint route list");
  NSIndexPath* editingPoint=[self.route addPointAtCenter];
  
  IKPoint* point = [self.route pointAtIndexPath:editingPoint];
  [mapView addAnnotation:point];
  [self updateRouteOverlay];
}

- (void)addPointWithLocation:(CLLocation*)location{
  qltrace(@"addPoint route list");
  NSIndexPath* editingPoint=[self.route addPointAtCoordinate:location.coordinate];
  
  IKPoint* point = [self.route pointAtIndexPath:editingPoint];
  [mapView addAnnotation:point];
  [self updateRouteOverlay];
}

#pragma mark - Page Curl stuff

- (void)changeMapViewType {
	[self.mapView setMapType:self.segmentedControl.selectedSegmentIndex];
  [self.curlBarItem curlViewDown];
  [[NSUserDefaults standardUserDefaults] setInteger:self.segmentedControl.selectedSegmentIndex forKey:@"RouteMapViewType"];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
  
  static NSString *pointIdentifier = @"IKPointIdentifier";
  
  if ([annotation isKindOfClass:[IKPoint class]]) {
    
    MKAnnotationView *annotationView;
    
    annotationView = [theMapView dequeueReusableAnnotationViewWithIdentifier:pointIdentifier];
    if (annotationView == nil)
      annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointIdentifier]autorelease];
    
    annotationView.annotation = annotation;
    ((MKPinAnnotationView*)annotationView).animatesDrop = NO;
    ((MKPinAnnotationView*)annotationView).pinColor=((IKPoint*)annotation).type==POINT_TYPE_WP?MKPinAnnotationColorGreen:MKPinAnnotationColorPurple;

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
                        initWithTitle:NSLocalizedString(@"Error loading map", @"Error loading map")
                        message:[error localizedDescription] 
                        delegate:nil 
                        cancelButtonTitle:NSLocalizedString(@"Okay", @"Okay") 
                        otherButtonTitles:nil];
  [alert show];
  [alert release];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
  if ([view.annotation isKindOfClass:[IKPoint class]]) {
    IKPoint* point=(IKPoint*)view.annotation;
    
    WaypointViewController* hostView = [[WaypointViewController alloc] initWithPoint:point];
    
    if( self.isPad ){
      UIPopoverController* popOverController = [[UIPopoverController alloc] initWithContentViewController:hostView];
      popOverController.delegate = self;
      popOverController.popoverContentSize = CGSizeMake(320, 400);
      
      [popOverController presentPopoverFromRect:control.bounds inView:control 
                       permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    else{
      [self.surrogateParent.navigationController pushViewController:hostView animated:YES];
    }
  }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [popoverController release];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	
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
  else if([overlay isKindOfClass:[MKCircle class]]) {
    MKCircleView* circleView=[[[MKCircleView alloc] initWithCircle:overlay] autorelease];
    if([((MKCircle*)overlay).title length]>0){ 
      circleView.strokeColor = [UIColor redColor];
    }
    else{
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
      fromOldState:(MKAnnotationViewDragState)oldState{

  if(newState==MKAnnotationViewDragStateEnding || newState==MKAnnotationViewDragStateDragging){
    [self updateRouteOverlay]; 
  }
}

#pragma mark Overlays

-(void)updateRouteOverlay{
  CLLocationCoordinate2D coordinates[[self.route.points count]];

  [self.mapView removeOverlays:self.mapView.overlays];
  
  int i=0;
  for (IKPoint* p in self.route.points) {
    if(p.type==POINT_TYPE_WP){
      coordinates[i]=p.coordinate;
      
      MKCircle* c=[MKCircle circleWithCenterCoordinate:p.coordinate radius:p.toleranceRadius];
      if(i==0)
        c.title=@"start";
      
      [self.mapView addOverlay:c];
      
      BOOL createOverlay=YES;
      if (p.heading!=0) {
        
        double angle=p.heading;
        if(p.heading<0){
          
          int idx=(-p.heading)-1;
          if(idx >= 0 && idx<[route.points count]){
            
            IKPoint* poi=[route.points objectAtIndex:idx];
            
            MKMapPoint pPoint=MKMapPointForCoordinate(p.coordinate);
            MKMapPoint poiPoint=MKMapPointForCoordinate(poi.coordinate);
            
            double ank=poiPoint.x-pPoint.x;
            double gek=poiPoint.y-pPoint.y;
            
            angle = (atan(gek/ank)*180.0)/M_PI;
            if(ank<0)
              angle+=180.0;
          }
          else{
            createOverlay=NO;
          }
        }
        if(createOverlay){
          HeadingOverlay* h=[HeadingOverlay headingWithCenterCoordinate:p.coordinate radius:10 angle:angle];
          [self.mapView addOverlay:h];
        }
      }
      
      i++;
      
    }
  }

  [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coordinates count:i]];
  
  qltrace(@"Overlays %@",self.mapView.overlays);
}

@end
