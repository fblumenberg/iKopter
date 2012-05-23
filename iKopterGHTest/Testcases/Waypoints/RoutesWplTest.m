//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+Base64.h"
#import "Routes.h"

@interface RoutesWplTest : GHTestCase
@end

@implementation RoutesWplTest

- (void)testSaveLoad{
  Routes* routes1 = [[Routes alloc] init];
  
  [routes1 deleteAllRoutes];
  
  [routes1 addRoute];
  [routes1 addRoute];

  GHAssertEquals(routes1.count, 2U, nil);
}

@end
