//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import <SenTestingKit/SenTestingKit.h>

#import "InnerBand.h"
#import "INIParser.h"

@interface INIParserTest : SenTestCase{
  NSString *tmpFile;  
}

@end

@implementation INIParserTest

- (void)setUp {

  NSString *tmpDirectory = NSTemporaryDirectory();
  tmpFile = [tmpDirectory stringByAppendingPathComponent:@"temp.txt"];
}

- (void)tearDown {
  NSFileManager* fm = [NSFileManager defaultManager];
     
  if([fm fileExistsAtPath:tmpFile])
    [fm removeItemAtPath:tmpFile error:nil];
}

- (void)testReadFile {
  
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *bundlePath = [bundle bundlePath];
  NSLog(@"Bundle: %@", bundle);
  
  NSString *someFile = [bundlePath stringByAppendingPathComponent:@"Test.wpl"];
  NSLog(@"File in Bundle: %@", someFile);
  
  NSError* error;
  INIParser *p = [[INIParser alloc] initWithContentsOfFile:someFile encoding:NSASCIIStringEncoding error:&error];
  
  STAssertNil(error, nil);

  INISection* s = [p getSection:@"General"];
  STAssertNotNil(s, nil);

  s = [p getSection:@"Point1"];
  STAssertNotNil(s, nil);
  
  STAssertEquals([p getInt:@"FileVersion" section:@"General"], (int)3, nil);
  STAssertEquals([p getInt:@"NumberOfWaypoints" section:@"General"], (int)4, nil);

  STAssertEquals([p getDouble:@"Latitude" section:@"Point1"], 49.8606708, nil);
  STAssertEquals([p getDouble:@"Longitude" section:@"Point1"], 8.6872954, nil);
  STAssertEquals([p getInt:@"Radius" section:@"Point1"], (int)123, nil);
  STAssertEquals([p getInt:@"Altitude" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"ClimbRate" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"DelayTime" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"WP_Event_Channel_Value" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"Heading" section:@"Point1"], (int)361, nil);
  STAssertEquals([p getInt:@"CAM-Nick" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"Speed" section:@"Point1"], (int)1, nil);
  STAssertEquals([p getInt:@"Type" section:@"Point1"], (int)1, nil);
  STAssertEquals([p get:@"Prefix" section:@"Point1"], @"P", nil);

  STAssertTrue([p exists:@"Latitude" section:@"Point1"], nil);
  STAssertTrue([p exists:@"Longitude" section:@"Point1"], nil);
  STAssertTrue([p exists:@"Radius" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"Altitude" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"ClimbRate" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"DelayTime" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"WP_Event_Channel_Value" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"Heading" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"CAM-Nick" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"Speed" section:@"Point1"],  nil);
  STAssertTrue([p exists:@"Type" section:@"Point1"],  nil);
} 

- (void)testParser {

  NSMutableString *dataString = [NSMutableString string];

  [dataString appendString:@"[Section]\n"];
  [dataString appendString:@"\n"];
  [dataString appendString:@"; dummy\n"];
  [dataString appendString:@"key1=value1\n"];
  [dataString appendString:@"key2 =value2\n"];
  [dataString appendString:@"key3 = value3\n"];

  INIParser *p = [[INIParser alloc] initWithString:dataString];
  STAssertTrue([p exists:@"key1" section:@"Section"], nil);
  STAssertTrue([p exists:@"key2" section:@"Section"], nil);
  STAssertTrue([p exists:@"key3" section:@"Section"], nil);
  STAssertFalse([p exists:@"ke4" section:@"Section"], nil);
  
  INISection* s = [p getSection:@"Section"];
  STAssertNotNil(s, nil);
  
  STAssertEquals([s retrieve:@"key1"], @"value1", nil);
  STAssertEquals([s retrieve:@"key2"], @"value2", nil);
  STAssertEquals([s retrieve:@"key3"], @"value3", nil);
  STAssertNil([s retrieve:@"key4"], nil);
}

- (void)testParserValues {

  NSMutableString *dataString = [NSMutableString string];
  
  [dataString appendString:@"[Section]\n"];
  [dataString appendString:@"\n"];
  [dataString appendString:@"; dummy\n"];
  [dataString appendString:@"key1=value1\n"];
  [dataString appendString:@"key2 =value2\n"];
  [dataString appendString:@"key3 = value3\n"];
  [dataString appendString:@"[SectionInt]\n"];
  [dataString appendString:@"\n"];
  [dataString appendString:@"; dummy\n"];
  [dataString appendString:@"int1=1001\n"];
  [dataString appendString:@"int2 =1002\n"];
  [dataString appendString:@"int3= 1003\n"];
  [dataString appendString:@"[SectionBool]\n"];
  [dataString appendString:@"\n"];
  [dataString appendString:@"; dummy\n"];
  [dataString appendString:@"b1=y\n"];
  [dataString appendString:@"b2=Y\n"];
  [dataString appendString:@"b3=t\n"];
  [dataString appendString:@"b4=T\n"];
  [dataString appendString:@"b5=n\n"];
  [dataString appendString:@"b6=N\n"];
  [dataString appendString:@"[SectionSpace]\n"];
  [dataString appendString:@"name1=Route test\n"];
  [dataString appendString:@"name2=Route test äöü\n"];

  INIParser *p = [[INIParser alloc] initWithString:dataString];
  
  STAssertNotNil([p getSection:@"Section"], nil);
  STAssertNotNil([p getSection:@"SectionInt"], nil);
  STAssertNotNil([p getSection:@"SectionBool"], nil);
  STAssertNotNil([p getSection:@"SectionSpace"], nil);

  STAssertTrue([p getBool:@"b1" section:@"SectionBool"], nil);
  STAssertTrue([p getBool:@"b2" section:@"SectionBool"], nil);
  STAssertTrue([p getBool:@"b3" section:@"SectionBool"], nil);
  STAssertTrue([p getBool:@"b4" section:@"SectionBool"], nil);
  STAssertFalse([p getBool:@"b5" section:@"SectionBool"], nil);
  STAssertFalse([p getBool:@"b6" section:@"SectionBool"], nil);

  STAssertEquals([p get:@"key1" section:@"Section"], @"value1", nil);
  STAssertEquals([p get:@"key2" section:@"Section"], @"value2", nil);
  STAssertEquals([p get:@"key3" section:@"Section"], @"value3", nil);

  STAssertEquals([p getInt:@"int1" section:@"SectionInt"], (int)1001, nil);
  STAssertEquals([p getInt:@"int2" section:@"SectionInt"], (int)1002, nil);
  STAssertEquals([p getInt:@"int3" section:@"SectionInt"], (int)1003, nil);

  STAssertEquals([p get:@"name1" section:@"SectionSpace"], @"Route test", nil);
  STAssertEquals([p get:@"name2" section:@"SectionSpace"], @"Route test äöü", nil);
}

- (void)testToString {
  
  NSMutableString *dataString = [NSMutableString string];
  
  [dataString appendString:@"[Section]\n"];
  [dataString appendString:@"\n"];
  [dataString appendString:@"; dummy\n"];
  [dataString appendString:@"key1=value1\n"];
  [dataString appendString:@"key2 =value2\n"];
  [dataString appendString:@"key3 = value3\n"];
  [dataString appendString:@"[SectionSpace]\n"];
  [dataString appendString:@"name1=Route test\n"];
  [dataString appendString:@"name2=Route test äöü\n"];

  INIParser *p = [[INIParser alloc] initWithString:dataString];
  
  NSString* dataString2 = [p asString];
  STAssertNotNil(dataString2, nil);
  STAssertTrue(dataString.length>0U,nil);
  
  INIParser *p2 = [[INIParser alloc] initWithString:dataString2];
  STAssertTrue([p2 exists:@"key1" section:@"Section"], nil);
  STAssertTrue([p2 exists:@"key2" section:@"Section"], nil);
  STAssertTrue([p2 exists:@"key3" section:@"Section"], nil);
  STAssertFalse([p2 exists:@"ke4" section:@"Section"], nil);
  
  INISection* s = [p2 getSection:@"Section"];
  STAssertNotNil(s, nil);
  
  STAssertEquals([s retrieve:@"key1"], @"value1", nil);
  STAssertEquals([s retrieve:@"key2"], @"value2", nil);
  STAssertEquals([s retrieve:@"key3"], @"value3", nil);
  STAssertNil([s retrieve:@"key4"], nil);

  STAssertEquals([p2 get:@"name1" section:@"SectionSpace"], @"Route test", nil);
  STAssertEquals([p2 get:@"name2" section:@"SectionSpace"], @"Route test äöü", nil);

}

@end
