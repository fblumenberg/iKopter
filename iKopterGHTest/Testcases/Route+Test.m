//
//  MKTRoute+MKTRoute_Test.m
//  MK Waypoints
//
//  Created by Frank Blumenberg on 16.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "Route+Test.h"
#import "IKPoint.h"

#import "InnerBand.h"

@implementation GHTestCase (Route_Test)


+ (Route *)addRouteWithName:(NSString *)name numberOfPoints:(NSInteger)count prefix:(NSString *)prefix {
  
  
  Route* r = [[Route alloc] init];
  
  r.name = name;
  r.filename=@"FILENAME";
  r.revision=@"REVISION";
  
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(50.123456, 9.123456);
  
  for (int i = 1; i <= count; i++) {
    IKPoint* p =[r pointAtIndexPath:[r addPointAtCoordinate:coordinate]];
    p.prefix = prefix;
    p.index = i;
    p.speed = i;
  }
  
  return r;
}

- (void) route:(Route*) r1 hasEqualValuesTo:(Route*)r2{
  
  GHAssertEqualStrings(r1.name, r2.name,nil);
  GHAssertEqualStrings(r1.revision, r2.revision,nil);
  GHAssertEquals(r1.points.count, r2.points.count, nil);
  
  for(NSInteger i=0;i<r1.points.count;i++){
    IKPoint* p1=[r1.points objectAtIndex:i];
    IKPoint* p2=[r2.points objectAtIndex:i];
    
    GHAssertEqualStrings(p1.name, p2.name,nil);
    GHAssertEqualStrings(p1.prefix, p2.prefix,nil);
    
    GHAssertEquals(p1.heading, p2.heading, nil);
    GHAssertEquals(p1.holdTime, p2.holdTime, nil);
    GHAssertEquals(p1.index, p2.index, nil);
    GHAssertEquals(p1.type, p2.type, nil);
    GHAssertEquals(p1.wpEventChannelValue, p2.wpEventChannelValue, nil);
    GHAssertEquals(p1.altitudeRate, p2.altitudeRate, nil);
    GHAssertEquals(p1.speed, p2.speed, nil);
    GHAssertEquals(p1.camAngle, p2.camAngle, nil);
    GHAssertEquals(p1.altitude, p2.altitude, nil);
    
    GHAssertEquals(p1.posLatitude, p2.posLatitude, nil);
    GHAssertEquals(p1.posLongitude, p2.posLongitude, nil);
  }
  
}
@end
