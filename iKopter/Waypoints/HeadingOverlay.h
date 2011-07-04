//
//  HeadingOverlayView.h
//  iKopter
//
//  Created by Frank Blumenberg on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HeadingOverlay : MKShape<MKOverlay> {

  MKCircle* circle;
  double angle;
}

@property(readonly) MKCircle* circle;
@property(readonly) double angle;

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;


+(HeadingOverlay *)headingWithCenterCoordinate:(CLLocationCoordinate2D)coord 
                                        radius:(CLLocationDistance)radius
                                         angle:(double)angle;

-(id)initWithCenterCoordinate:(CLLocationCoordinate2D)coord 
                       radius:(CLLocationDistance)radius
                        angle:(double)angle;


@end
