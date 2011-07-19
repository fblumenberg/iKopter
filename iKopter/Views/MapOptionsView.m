//
//  MapOptionsView.m
//  iKopter
//
//  Created by Frank Blumenberg on 22.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MKMapView.h>
#import "MapOptionsView.h"


@implementation MapOptionsView

@synthesize segmentedControl;
@synthesize mapView;
@synthesize delegate;
@synthesize paddingTop;


- (void)awakeFromNib {
  
  [self.segmentedControl setTintColor:self.backgroundColor];
  [self.segmentedControl setSelectedSegmentIndex:0];
}

- (void)dealloc
{
  [super dealloc];
  self.mapView=nil;
}

-(IBAction) changeMapViewType{
  
  [self.mapView setMapType:self.segmentedControl.selectedSegmentIndex];
  if ([self.delegate respondsToSelector:@selector(curlMapOptionsViewDidCaptureTouchOnPaddingRegion:)]) {
    [self.delegate curlMapOptionsViewDidCaptureTouchOnPaddingRegion:self];
  }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
  for (UITouch *touch in touches) {
    CGPoint point = [touch locationInView:self];
    if (point.y < self.paddingTop) {
      if ([self.delegate respondsToSelector:@selector(curlMapOptionsViewDidCaptureTouchOnPaddingRegion:)]) {
        [self.delegate curlMapOptionsViewDidCaptureTouchOnPaddingRegion:self];
      }
    }
  }
}

@end
