//
//  MKTRoute+MKTRoute_WPL.h
//  MK Waypoints
//
//  Created by Frank Blumenberg on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Route.h"

@interface Route (Route_WPL)

- (BOOL)loadRouteFromWplFile:(NSString*)path;
- (BOOL)writeRouteToWplFile:(NSString*)path;

@end
