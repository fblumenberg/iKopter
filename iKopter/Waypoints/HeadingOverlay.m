//
//  HeadingOverlayView.m
//  iKopter
//
//  Created by Frank Blumenberg on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeadingOverlay.h"

@implementation HeadingOverlay

@synthesize circle;
@synthesize coordinate;
@synthesize boundingMapRect;
@synthesize angle;

-(CLLocationCoordinate2D) coordinate {
  return circle.coordinate;
}

-(MKMapRect) boundingMapRect{
  return circle.boundingMapRect;
}



+(HeadingOverlay *)headingWithCenterCoordinate:(CLLocationCoordinate2D)coord 
                                        radius:(CLLocationDistance)radius
                                         angle:(double)angle{
 
  HeadingOverlay* overlay=[[[HeadingOverlay alloc] initWithCenterCoordinate:coord radius:radius angle:angle] autorelease];
  return overlay;
}

-(id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord 
                       radius:(CLLocationDistance)radius
                        angle:(double)theAngle{
  
  self=[super init];
  if(self){
    circle=[[MKCircle circleWithCenterCoordinate:coord radius:radius] retain];
    angle=theAngle;
  }
  
  return self;
}

-(void)dealloc{
  [circle release];
  circle=nil;
  [super dealloc];
}

@end
