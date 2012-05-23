//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+Base64.h"
#import "Routes.h"
#import "Route+Test.h"

@interface RoutesTest : GHTestCase
@end

@implementation RoutesTest

- (void)testSaveLoad{
  Routes* routes1 = [[Routes alloc] init];
  [routes1 deleteAllRoutes];
  
  [routes1 addRoute];
  [routes1 addRoute];

  GHAssertEquals(routes1.count, 2U, nil);
  
  
  Routes* routes2 = [[Routes alloc] init];
  GHAssertEquals(routes2.count, routes1.count, nil);
}


- (void)testAddOrReplace{

  Routes* routes1 = [[Routes alloc] init];
  [routes1 deleteAllRoutes];

  GHAssertEquals(routes1.count, 0U, nil);
  
  Route* r1=[GHTestCase addRouteWithName:@"Route1" numberOfPoints:12 prefix:@"D"];
  r1.filename = @"F1";
  
  Route* r;
  r = [routes1 routeAtIndexPath:[routes1 addOrReplaceRoute:r1]];
  
  GHAssertEquals(routes1.count, 1U, nil);
  GHAssertEquals(r, r1, nil);
  GHAssertEqualStrings(r.name, r1.name, nil);

  Route* r2=[GHTestCase addRouteWithName:@"Route1a" numberOfPoints:12 prefix:@"D"];
  r2.filename = @"F1";
  
  r = [routes1 routeAtIndexPath:[routes1 addOrReplaceRoute:r2]];
  
  GHAssertEquals(routes1.count, 1U, nil);
  GHAssertEqualStrings(r.name, r2.name, nil);
  GHAssertEquals(r, r2, nil);

  Route* r3=[GHTestCase addRouteWithName:@"Route2" numberOfPoints:12 prefix:@"D"];
  r3.filename = @"F2";
  
  r = [routes1 routeAtIndexPath:[routes1 addOrReplaceRoute:r3]];
  
  GHAssertEquals(routes1.count, 2U, nil);
  GHAssertEqualStrings(r.name, r3.name, nil);
  GHAssertEquals(r, r3, nil);

}

@end
