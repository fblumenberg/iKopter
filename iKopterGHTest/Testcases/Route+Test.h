//
//  MKTRoute+MKTRoute_Test.h
//  MK Waypoints
//
//  Created by Frank Blumenberg on 16.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Route.h"

@interface GHTestCase (Route_Test)

+ (Route *)addRouteWithName:(NSString *)name numberOfPoints:(NSInteger)count prefix:(NSString *)prefix;
- (void) route:(Route*) r1 hasEqualValuesTo:(Route*)r2;

@end
