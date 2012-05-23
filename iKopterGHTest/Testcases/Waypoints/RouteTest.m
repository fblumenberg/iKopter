//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+Base64.h"
#import "Route.h"

@interface RouteTest : GHTestCase
@end

@implementation RouteTest

- (void)testNSCoding
{
  Route* r = [[Route alloc] init];
  
  r.name = @"Route";
  r.filename=@"FILENAME";
  r.revision=@"REVISION";

  [r addPointAtDefault];
  
  NSMutableData *data = [[NSMutableData alloc] init];
  
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  
  [archiver encodeObject:r forKey:@"data"];
  [archiver finishEncoding];
  
  
  NSLog(@"Data %@",[data base64EncodedString]);
  
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  
  Route* r2 = [unarchiver decodeObjectForKey:@"data"];

  GHAssertEqualStrings(r2.name, r.name, @"unarchived is not equal");
  GHAssertEqualStrings(r2.filename, r.filename, @"unarchived is not equal");
  GHAssertEqualStrings(r2.revision, r.revision, @"unarchived is not equal");
  GHAssertEquals(r2.points.count, r.points.count,nil);

}

@end
