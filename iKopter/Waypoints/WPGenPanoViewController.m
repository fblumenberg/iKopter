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


#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

#import "WPGenPanoViewController.h"
#import "WPGenPanoDataSource.h"
#import "WPGenConfigViewController.h"
#import "WPGenPanoView.h"

#import "IKPoint.h"

@interface WPGenPanoViewController () <UIPopoverControllerDelegate,WPGenBaseDataSourceDelegate,UIGestureRecognizerDelegate> {
}

@property(retain) WPGenPanoDataSource* dataSource;

@end

@implementation WPGenPanoViewController

@synthesize dataSource;

- (id)initForMapView:(MKMapView*)mapView {

  WPGenPanoView* shapeView = [[[WPGenPanoView alloc] initWithFrame:CGRectZero] autorelease];
  
  self = [super initWithShapeView:shapeView forMapView:mapView];
  if (self) {

    [self.wpData setValue:[NSNumber numberWithInteger:shapeView.noPoints] forKey:WPnoPoints];
    [self.wpData setValue:[NSNumber numberWithBool:NO] forKey:WPclockwise];

    self.dataSource = [[[WPGenPanoDataSource alloc] initWithModel:self.wpData]autorelease];
    self.dataSource.delegate = self;
  }
  return self;
}

- (void)dealloc {
  self.dataSource = nil;

  [super dealloc];
}

- (void)viewDidLoad {
  [super viewDidLoad];

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[self.shapeView addGestureRecognizer:tapRecognizer];
  [tapRecognizer release];
} 

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

-(void)tapped:(UITapGestureRecognizer*)gestureRecognizer {
  
  [self showConfig:self.shapeView];
}


-(void) dataSource:(WPGenBaseDataSource *)changed {
  
  WPGenPanoView* v=(WPGenPanoView*)self.shapeView;
  
  v.noPoints = [[self.wpData objectForKey:WPnoPoints] integerValue];
  v.clockwise= [[self.wpData objectForKey:WPclockwise] boolValue];
  [v updatePoints];
  [v setNeedsDisplay];
}


-(NSArray*) generatePointsList{
  
  WPGenPanoView* v = (WPGenPanoView*)self.shapeView;

  NSMutableArray* points=[NSMutableArray arrayWithCapacity:[v.points count]];
  
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:v.poi toCoordinateFromView:self.shapeView];
  
  
  [points addObject:[self pointOfType:POINT_TYPE_POI forCoordinate:coordinate]];

  
  [v.points enumerateObjectsUsingBlock:^(NSValue* obj, NSUInteger idx, BOOL *stop){

      CGPoint p = [obj CGPointValue];
      CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.shapeView];
      NSLog(@"%d lat:%f long:%f",idx,coordinate.latitude,coordinate.longitude);
      [points addObject:[self pointOfType:POINT_TYPE_WP forCoordinate:coordinate]];
  }];

  if( [[self.wpData objectForKey:WPclosed] boolValue]){
    CGPoint p = [[v.points objectAtIndex:0] CGPointValue];
    CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.shapeView];
    [points addObject:[self pointOfType:POINT_TYPE_WP forCoordinate:coordinate]];
  }
  
  return points;
}

@end
