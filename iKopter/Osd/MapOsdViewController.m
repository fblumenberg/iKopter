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

@implementation MapOsdViewController

@synthesize mapView;
@synthesize mapTypeSwitch;
@synthesize lm;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc
{
  self.mapView=nil;
  self.mapTypeSwitch=nil;
  self.lm=nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];

  self.lm = [[[CLLocationManager alloc] init]autorelease];
  self.lm.delegate = self;
  self.lm.desiredAccuracy = kCLLocationAccuracyBest;
  [self.lm startUpdatingLocation];

}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [self.lm startUpdatingLocation];
  self.lm=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (IBAction)mapTypeChange{
  if(self.mapTypeSwitch.on){
    mapView.mapType=MKMapTypeHybrid;
  }
  else{
    mapView.mapType=MKMapTypeStandard;
  }
}

#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
  
  if ([newLocation.timestamp timeIntervalSince1970] < [NSDate timeIntervalSinceReferenceDate] - 60)
    return;
  
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 250, 250); 
  MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
  [mapView setRegion:adjustedRegion animated:YES];
  
  MapLocation *annotation = [[MapLocation alloc] init];
  annotation.type=IKMapLocationDevice;
  annotation.coordinate=newLocation.coordinate;
  [mapView addAnnotation:annotation];
  
  [annotation release];

  manager.delegate = nil;
  [manager stopUpdatingLocation];
  [manager autorelease];
  
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
  IKGPSPos* gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->HomePosition)];
  [self updateAnnotationForType:IKMapLocationHomePosition coordinate:gpsPos.location.coordinate];
  
  gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->TargetPosition)];
  [self updateAnnotationForType:IKMapLocationTargetPosition coordinate:gpsPos.location.coordinate];

  gpsPos=[IKGPSPos positionWithMkPos:&(value.data.data->CurrentPosition)];
  [self updateAnnotationForType:IKMapLocationCurrentPosition coordinate:gpsPos.location.coordinate];
}

- (void) noDataAvailable {
  
}

@end
