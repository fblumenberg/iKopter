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

#import "WPGenCircleViewController.h"
#import "WPGenCircleDataSource.h"
#import "WPGenConfigViewController.h"
#import "WPGenCircleView.h"

#import "IKPoint.h"

IK_DEFINE_KEY_WITH_VALUE(WPnoPoints, @"noPoints");
IK_DEFINE_KEY_WITH_VALUE(WPstartangle, @"startangle");
IK_DEFINE_KEY_WITH_VALUE(WPclockwise, @"clockwise");

@interface WPGenCircleViewController () <UIPopoverControllerDelegate,WPGenBaseDataSourceDelegate,UIGestureRecognizerDelegate> {
}

@property(retain) WPGenCircleDataSource* dataSource;

@end

@implementation WPGenCircleViewController

@synthesize dataSource;

- (id)initForMapView:(MKMapView*)mapView {

  WPGenCircleView* shapeView = [[WPGenCircleView alloc] initWithFrame:CGRectZero];
  
  
  
  self = [super initWithShapeView:shapeView forMapView:mapView];
  if (self) {

    [self.wpData setValue:[NSNumber numberWithInteger:shapeView.noPoints] forKey:WPnoPoints];
    [self.wpData setValue:[NSNumber numberWithBool:NO] forKey:WPclockwise];

    self.dataSource = [[WPGenCircleDataSource alloc] initWithModel:self.wpData];
    self.dataSource.delegate = self;
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
  self.dataSource = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];

	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
	[tapRecognizer setNumberOfTapsRequired:1];
	[self.shapeView addGestureRecognizer:tapRecognizer];
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
  
  WPGenCircleView* v=(WPGenCircleView*)self.shapeView;
  
  v.noPoints = [[self.wpData objectForKey:WPnoPoints] integerValue];
  v.clockwise= [[self.wpData objectForKey:WPclockwise] boolValue];
  [v updatePoints];
  [v setNeedsDisplay];
}

-(NSArray*) generatePointsList{
  
  WPGenCircleView* v = (WPGenCircleView*)self.shapeView;

  NSMutableArray* points=[NSMutableArray arrayWithCapacity:[v.points count]];
  
  CLLocationCoordinate2D coordinate = [self.mapView convertPoint:v.poi toCoordinateFromView:self.shapeView];
  
  IKPoint *newPoint = [[IKPoint alloc] initWithCoordinate:coordinate];
  
  newPoint.heading=[[self.wpData objectForKey:WPheading] integerValue];
  newPoint.toleranceRadius=[[self.wpData objectForKey:WPtoleranceRadius] integerValue];    
  newPoint.holdTime=[[self.wpData objectForKey:WPholdTime] integerValue];
  newPoint.eventFlag=0;
  newPoint.index=255;
  newPoint.type=POINT_TYPE_POI;
  newPoint.wpEventChannelValue=[[self.wpData objectForKey:WPaltitude] integerValue];
  newPoint.altitudeRate=[[self.wpData objectForKey:WPaltitudeRate] integerValue];
  newPoint.speed=[[self.wpData objectForKey:WPspeed] integerValue];
  newPoint.camAngle=[[self.wpData objectForKey:WPcamAngle] integerValue];
  
  [points addObject:newPoint];

  
  [v.points enumerateObjectsUsingBlock:^(NSValue* obj, NSUInteger idx, BOOL *stop){

      CGPoint p = [obj CGPointValue];
      
      CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.shapeView];
      
      NSLog(@"%d lat:%f long:%f",idx,coordinate.latitude,coordinate.longitude);
      
      IKPoint *newPoint = [[IKPoint alloc] initWithCoordinate:coordinate];

      newPoint.heading=[[self.wpData objectForKey:WPheading] integerValue];
      newPoint.toleranceRadius=[[self.wpData objectForKey:WPtoleranceRadius] integerValue];    
      newPoint.holdTime=[[self.wpData objectForKey:WPholdTime] integerValue];
      newPoint.eventFlag=0;
      newPoint.index=255;
      newPoint.type=POINT_TYPE_WP;
      newPoint.wpEventChannelValue=[[self.wpData objectForKey:WPaltitude] integerValue];
      newPoint.altitudeRate=[[self.wpData objectForKey:WPaltitudeRate] integerValue];
      newPoint.speed=[[self.wpData objectForKey:WPspeed] integerValue];
      newPoint.camAngle=[[self.wpData objectForKey:WPcamAngle] integerValue];

      [points addObject:newPoint];

      [newPoint release];
  }];

  return points;
}

@end
