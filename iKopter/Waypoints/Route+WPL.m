//
//  MKTRoute+MKTRoute_WPL.m
//  MK Waypoints
//
//  Created by Frank Blumenberg on 13.04.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Route+WPL.h"
#import "IKPoint.h"
#import "INIParser.h"

#import "InnerBand.h"

@implementation Route (Route_WPL)

- (BOOL)addPointAtIndex:(int)index fromWpl:(INIParser*)p{
  
  
  BOOL result =YES;
  NSString* sectionName = [NSString stringWithFormat:@"Point%d",index];

  
  result = result && [p exists:@"Latitude" section:sectionName];
  result = result && [p exists:@"Longitude" section:sectionName];
  result = result && [p exists:@"Radius" section:sectionName];
  result = result && [p exists:@"Altitude" section:sectionName];
  result = result && [p exists:@"ClimbRate" section:sectionName];
  result = result && [p exists:@"DelayTime" section:sectionName];
  result = result && [p exists:@"WP_Event_Channel_Value" section:sectionName];
  result = result && [p exists:@"Heading" section:sectionName];
  result = result && [p exists:@"Speed" section:sectionName];
  result = result && [p exists:@"CAM-Nick" section:sectionName];
  result = result && [p exists:@"Type" section:sectionName];
  result = result && [p exists:@"Prefix" section:sectionName];

  if(result){
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([p getDouble:@"Latitude" section:sectionName], [p getDouble:@"Longitude" section:sectionName]);
    
    NSIndexPath* indexPath = [self addPointAtCoordinate:coordinate];
    IKPoint* pt = [self pointAtIndexPath:indexPath];

    pt.heading=[p getInt:@"Heading" section:sectionName];
    pt.toleranceRadius=[p getInt:@"Radius" section:sectionName];
    pt.holdTime=[p getInt:@"DelayTime" section:sectionName];
    pt.type=[p getInt:@"Type" section:sectionName];
    pt.wpEventChannelValue=[p getInt:@"WP_Event_Channel_Value" section:sectionName];
    pt.altitudeRate=[p getInt:@"ClimbRate" section:sectionName];
    pt.altitude=[p getInt:@"Altitude" section:sectionName];
    pt.speed=[p getInt:@"Speed" section:sectionName];
    pt.camAngle=[p getInt:@"CAM-Nick" section:sectionName];
    pt.prefix = [p get:@"Prefix" section:sectionName];
  }

  return result;
}

- (BOOL)loadRouteFromWplFile:(NSString*)path {
  
  INIParser* p = [[INIParser alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
  if(!p)
    return NO;
  
  BOOL result=YES;
  
  result = result && [p exists:@"FileVersion" section:@"General"];
  result = result && [p exists:@"NumberOfWaypoints" section:@"General"];
  result = result && [p getInt:@"FileVersion" section:@"General"]==3;
  
  if(result){
    int numberOfPoints=[p getInt:@"NumberOfWaypoints" section:@"General"];
    
    self.filename = path.lastPathComponent;
    self.name = [p get:@"Name" section:@"General"];
    if(self.name == nil )
      self.name = [self.filename stringByDeletingPathExtension];
    
    [self.points removeAllObjects];
    
    for(int i=1;result &&  i<=numberOfPoints;i++){
      result = [self addPointAtIndex:i fromWpl:p];
    }
    
    if(self.points.count!=numberOfPoints){
      result = NO;
    }
  }
  
  return result;
}


- (BOOL)writeRouteToWplFile:(NSString*)path {
  
  INIParser* p = [INIParser new];
  
  [p setNumber:BOX_INT(3) forName:@"FileVersion" section:@"General"];
  [p setNumber:BOX_INT(self.points.count) forName:@"NumberOfWaypoints" section:@"General"];
  [p set:self.name forName:@"Name" section:@"General"];
  
  [self.points enumerateObjectsUsingBlock:^(IKPoint* pt, NSUInteger i, BOOL* stop){

    NSString* sectionName = [NSString stringWithFormat:@"Point%d",i+1];
    
    [p setNumber:BOX_DOUBLE(pt.posLatitude) forName:@"Latitude" section:sectionName];
    [p setNumber:BOX_DOUBLE(pt.posLongitude) forName:@"Longitude" section:sectionName];
    [p setNumber:BOX_INT(pt.toleranceRadius) forName:@"Radius" section:sectionName];
    [p setNumber:BOX_INT(pt.altitude) forName:@"Altitude" section:sectionName];
    [p setNumber:BOX_INT(pt.altitudeRate) forName:@"ClimbRate" section:sectionName];
    [p setNumber:BOX_INT(pt.holdTime) forName:@"DelayTime" section:sectionName];
    [p setNumber:BOX_INT(pt.wpEventChannelValue) forName:@"WP_Event_Channel_Value" section:sectionName];
    [p setNumber:BOX_INT(pt.heading) forName:@"Heading" section:sectionName];
    [p setNumber:BOX_INT(pt.speed) forName:@"Speed" section:sectionName];
    [p setNumber:BOX_INT(pt.camAngle) forName:@"CAM-Nick" section:sectionName];
    [p setNumber:BOX_INT(pt.type) forName:@"Type" section:sectionName];
    [p set:pt.prefix forName:@"Prefix" section:sectionName];
    
  }];

  NSError* error=nil;
  BOOL retVal = [p writeToFile:path atomically:NO encoding:NSUTF8StringEncoding error:&error];
  return retVal;
}


@end
