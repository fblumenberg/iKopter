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

#import "WPGenAreaViewController.h"
#import "WPGenAreaDataSource.h"
#import "WPGenConfigViewController.h"
#import "WPGenAreaView.h"

#import "IKPoint.h"

IK_DEFINE_KEY_WITH_VALUE(WPnoPointsX, @"noPointsX");
IK_DEFINE_KEY_WITH_VALUE(WPnoPointsY, @"noPointsY");

@interface WPGenAreaViewController () <UIPopoverControllerDelegate,WPGenBaseDataSourceDelegate,UIGestureRecognizerDelegate> {
}

@property(retain) WPGenAreaDataSource* dataSource;

@end

@implementation WPGenAreaViewController

@synthesize dataSource;

- (id)initForMapView:(MKMapView*)mapView {

  WPGenAreaView* shapeView = [[[WPGenAreaView alloc] initWithFrame:CGRectZero] autorelease];
  
  self = [super initWithShapeView:shapeView forMapView:mapView];
  if (self) {

    [self.wpData setValue:[NSNumber numberWithInteger:2] forKey:WPnoPointsX];
    [self.wpData setValue:[NSNumber numberWithInteger:2] forKey:WPnoPointsY];

    self.dataSource = [[[WPGenAreaDataSource alloc] initWithModel:self.wpData]autorelease];
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
  
  WPGenAreaView* v=(WPGenAreaView*)self.shapeView;
  
  v.noPointsX = [[self.wpData objectForKey:WPnoPointsX] integerValue];
  v.noPointsY = [[self.wpData objectForKey:WPnoPointsY] integerValue];
  [v updatePoints];
  [v setNeedsDisplay];
}

-(NSArray*) generatePointsList{
  
  WPGenAreaView* v = (WPGenAreaView*)self.shapeView;
  
  NSMutableArray* points=[NSMutableArray arrayWithCapacity:[v.points count]];
  
  [v.points enumerateObjectsUsingBlock:^(id obj, NSUInteger idxY, BOOL *stop){

    NSArray* x=obj;    
    if(idxY % 2)
      x = [[x reverseObjectEnumerator]allObjects];
    
    [x enumerateObjectsUsingBlock:^(id obj, NSUInteger idxX, BOOL *stop){
      CGPoint p = [[x objectAtIndex:idxX] CGPointValue];
      
      CLLocationCoordinate2D coordinate = [self.mapView convertPoint:p toCoordinateFromView:self.shapeView];
      
      NSLog(@"%d,%d lat:%f long:%f",idxX,idxY,coordinate.latitude,coordinate.longitude);
      
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
  }];

  return points;
}

@end
