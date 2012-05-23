//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "GHUnit.h"
#import "InnerBand.h"

#import "IKPoint.h"
#import "Route.h"
#import "Route+Test.h"

@interface Route_TestTest : GHTestCase

@end

@implementation Route_TestTest

- (void)setUp {
}

- (void)testRouteHasEqualValuesTo {

  Route *r1 = [GHTestCase addRouteWithName:@"TEST123" numberOfPoints:12 prefix:@"X"];
  Route *r2 = [GHTestCase addRouteWithName:@"TEST123" numberOfPoints:12 prefix:@"X"];
  
  r2.filename = r1.filename;
  
  [self route:r1 hasEqualValuesTo:r2];
}

@end
