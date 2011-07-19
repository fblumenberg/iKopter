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

#import "MapOsdViewController.h"
#import "MapLocation.h"
#import "HeadingOverlay.h"
#import "HeadingOverlayView.h"
#import "IKPoint.h"

@interface MapOsdViewController()

  -(void)updateRouteOverlay;

@end

@implementation MapOsdViewController

@synthesize mapView;
@synthesize mapTypeSwitch;
@synthesize routeController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
    self.routeController = [[[RouteController alloc] initWithDelegate:self] autorelease];
  }
  return self;
}

- (void)dealloc
{
  self.mapView=nil;
  self.mapTypeSwitch=nil;
  self.routeController=nil;
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
  needRegionAdjustment=YES;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

#pragma mark - Map View Delegate Methods

- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
  static NSString *placemarkIdentifierDevice = @"Device Map Location Identifier";
  static NSString *placemarkIdentifier = @"Map Location Identifier";
  if ([annotation isKindOfClass:[MapLocation class]]) {
    MKAnnotationView *annotationView;
    
    if(((MapLocation*)annotation).type==IKMapLocationDevice){
      annotationView = [theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifierDevice];
      if (annotationView == nil)
        annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifierDevice]autorelease];
      else 
        annotationView.annotation = annotation;
      ((MKPinAnnotationView*)annotationView).animatesDrop = YES;
      ((MKPinAnnotationView*)annotationView).pinColor=MKPinAnnotationColorPurple;
      
      annotationView.enabled = YES;
      annotationView.canShowCallout = YES;
    }
    else{
      annotationView = (MKAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:placemarkIdentifier];
      if (annotationView == nil)
        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placemarkIdentifier]autorelease];
      else 
        annotationView.annotation = annotation;
      
      annotationView.enabled = YES;
      switch (((MapLocation*)annotation).type) {
        case IKMapLocationCurrentPosition:
          annotationView.image=[UIImage imageNamed:@"annotation-current.png"];
          [annotationView setSelected:YES animated:NO];
          break;
        case IKMapLocationHomePosition:
          annotationView.image=[UIImage imageNamed:@"annotation-home.png"];
          break;
        case IKMapLocationTargetPosition:
          annotationView.image=[UIImage imageNamed:@"annotation-target.png"];
          break;
        default:
          break;
      }
      
      annotationView.centerOffset=CGPointMake(0.0, -16.0);
    }
    
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

- (void)updateAnnotationForType:(IKMapLocationType) type coordinate:(CLLocationCoordinate2D)coordinate{
  
  __block BOOL needNewAnnotation=YES;
  
  [self.mapView.annotations enumerateObjectsUsingBlock:^(id x, NSUInteger index, BOOL *stop){
    if ([x isKindOfClass:[MapLocation class]]) {
      MapLocation* ml=x;
      if (ml.type==type) {
        ml.coordinate=coordinate;
        needNewAnnotation=NO;
        *stop=YES;
      }
    }
  }];
  
  if (needNewAnnotation) {
    MapLocation *annotation = [[MapLocation alloc] init];
    annotation.type=type;
    annotation.coordinate=coordinate;
    [mapView addAnnotation:annotation];
    [annotation release];
  }
}

#pragma mark - OsdValueDelegate

- (void) newValue:(OsdValue*)value {
  IKGPSPos* gpsPos;

  gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->TargetPosition)];
  [self updateAnnotationForType:IKMapLocationTargetPosition coordinate:gpsPos.coordinate];
  gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->CurrentPosition)];
  [self updateAnnotationForType:IKMapLocationCurrentPosition coordinate:gpsPos.coordinate];
  gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->HomePosition)];
  [self updateAnnotationForType:IKMapLocationHomePosition coordinate:gpsPos.coordinate];
  
  if( needRegionAdjustment ){
     MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(gpsPos.coordinate, 500, 500); 
     MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
     [self.mapView setRegion:adjustedRegion animated:YES];
    needRegionAdjustment=NO;
  }

  if (value.data.data->WaypointNumber>0 && self.routeController.route==nil && self.routeController.state==RouteControllerIsIdle ) {
    [routeController downloadRouteFromNaviCtrl];
  }
}

- (void) noDataAvailable {
  
}

#pragma mark - RouteControllerDelegate

-(void) routeControllerFinishedDownload:(RouteController *)controller{
  
  if([controller.route.points count]>0)
    [self updateRouteOverlay];
}


#pragma mark Overlays

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


-(void)updateRouteOverlay{
  
  NSArray* points=self.routeController.route.points;
  CLLocationCoordinate2D coordinates[[points count]];
  
  [self.mapView removeOverlays:self.mapView.overlays];
  
  int i=0;
  for (IKPoint* p in points) {
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
          if(idx >= 0 && idx<[points count]){
            
            IKPoint* poi=[points objectAtIndex:idx];
            
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
