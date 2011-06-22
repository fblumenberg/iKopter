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

@implementation RouteMapViewController

@synthesize route;
@synthesize mapView;
@synthesize curlBarItem;
@synthesize segmentedControl;

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
}

#pragma mark - Page Curl stuff

- (void)changeMapViewType {
	[self.mapView setMapType:self.segmentedControl.selectedSegmentIndex];
  [self.curlBarItem curlViewDown];
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
    ((MKPinAnnotationView*)annotationView).pinColor=MKPinAnnotationColorGreen;

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

@end
