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

#import "INIParser.h"
#import "Route.h"
#import "IKPoint.h"
#import "Route+WPL.h"
#import "Route+Test.h"

@interface RouteWplTest : GHTestCase{
  NSString *tmpFile;  
}

@end

@implementation RouteWplTest

- (void)setUp {
  
  CoreDataStore *store = [CoreDataStore mainStore];
  [store clearAllData];

  NSString *tmpDirectory = NSTemporaryDirectory();
  tmpFile = [tmpDirectory stringByAppendingPathComponent:@"temp.txt"];
}

- (void)tearDown {
  NSFileManager* fm = [NSFileManager defaultManager];
  
  if([fm fileExistsAtPath:tmpFile])
    [fm removeItemAtPath:tmpFile error:nil];

  CoreDataStore *store = [CoreDataStore mainStore];
  [store clearAllData];
}

- (void)testReadFile {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  NSLog(@"Bundle: %@", bundle);
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"Test.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  Route* route = [[Route alloc]init];
  
  BOOL result = [route loadRouteFromWplFile:someFile];
  GHAssertTrue(result,nil);
  
  GHAssertEquals(route.points.count, 4U, nil);
  
  NSArray *results = [route.points map:(ib_enum_id_t) ^(id obj) {
    IKPoint* p = obj;
    return BOX_INT(p.toleranceRadius);
  }];
  
  NSArray *required = [NSArray arrayWithObjects:BOX_INT(123), BOX_INT(456), BOX_INT(789), BOX_INT(432), nil];
  GHAssertEqualObjects(results, required, nil);
}

- (void)testReadInvalidFile {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  NSLog(@"Bundle: %@", bundle);
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"TestInvalid.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  Route* route = [[Route alloc]init];
  
  BOOL result = [route loadRouteFromWplFile:someFile];
  GHAssertFalse(result,nil);
}

- (void)testReadFileNotExist {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"TestInvalid-not.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  Route* route = [[Route alloc]init];
  
  BOOL result = [route loadRouteFromWplFile:someFile];
  GHAssertFalse(result,nil);
}

- (void)testWriteFile {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  NSLog(@"Bundle: %@", bundle);
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"Test.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  Route* route = [[Route alloc]init];
  
  BOOL result = [route loadRouteFromWplFile:someFile];
  GHAssertTrue(result,nil);
  
  result = [route writeRouteToWplFile:tmpFile];
  GHAssertTrue(result,nil);

  Route* route2 = [[Route alloc]init];
  
  result = [route2 loadRouteFromWplFile:tmpFile];
  GHAssertTrue(result,nil);
  
  [self route:route2 hasEqualValuesTo:route];
}


- (void)testWriteFileUmlaute {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  NSLog(@"Bundle: %@", bundle);
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"Test.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  Route* route = [[Route alloc]init];
  
  BOOL result = [route loadRouteFromWplFile:someFile];
  GHAssertTrue(result,nil);
  
  route.name = @"TESTÄÖÜ";
  
  result = [route writeRouteToWplFile:tmpFile];
  GHAssertTrue(result,nil);
  
  Route* route2 = [[Route alloc]init];
  
  result = [route2 loadRouteFromWplFile:tmpFile];
  GHAssertTrue(result,nil);
  
  [self route:route2 hasEqualValuesTo:route];
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
