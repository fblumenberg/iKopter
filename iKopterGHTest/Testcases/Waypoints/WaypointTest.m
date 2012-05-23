//
//  WaypointTest.m
//  iKopter
//
//  Created by Frank Blumenberg on 16.02.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSData+Base64.h"
#import "IKPoint.h"

@interface WaypointTest : GHTestCase
@end

@implementation WaypointTest

- (void)testWaypointNSData
{
  CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(49.860348,8.686227);
  IKPoint* p = [[IKPoint alloc] initWithCoordinate:coordinate];
  p.heading=101;
  p.toleranceRadius=102;
  p.holdTime=103;
  p.eventFlag=104;
  p.index=105;
  p.prefix=@"X";
  p.type=106;
  p.wpEventChannelValue=107;
  p.altitudeRate=108;
  p.speed=109;
  p.camAngle=111;
  p.cameraNickControl=YES;
  
  GHAssertEquals(p.coordinate, coordinate, @"Coordinate is not correct");
  
  NSData* data = [p data];
  
  NSMutableData* mkData=[NSMutableData dataWithBytes:"XX" length:2];
  
  [mkData appendData:data];
  
  IKPoint* p2 = [IKPoint pointWithData:mkData];
  
  GHAssertEquals(p.coordinate, p2.coordinate, @"unarchived is not equal");
  GHAssertEquals(p.heading, p2.heading, @"unarchived is not equal");
  GHAssertEquals(p.toleranceRadius, p2.toleranceRadius, @"unarchived is not equal");
  GHAssertEquals(p.holdTime, p2.holdTime, @"unarchived is not equal");
  GHAssertEquals(p.eventFlag, p2.eventFlag, @"unarchived is not equal");
  GHAssertEquals(p.index, p2.index, @"unarchived is not equal");
  GHAssertEqualStrings(p.prefix, p2.prefix, @"unarchived is not equal");
  GHAssertEquals(p.type, p2.type, @"unarchived is not equal");
  GHAssertEquals(p.wpEventChannelValue, p2.wpEventChannelValue, @"unarchived is not equal");
  GHAssertEquals(p.altitudeRate, p2.altitudeRate, @"unarchived is not equal");
  GHAssertEquals(p.speed, p2.speed, @"unarchived is not equal");
  GHAssertEquals(p.camAngle, p2.camAngle, @"unarchived is not equal");
  GHAssertEquals(p.cameraNickControl, p2.cameraNickControl, @"unarchived is not equal");
  GHAssertEqualStrings(p.name, p2.name, @"unarchived is not equal");
  
}

// All code under test is in the iOS Application
- (void)testWaypointNSCoding
{
  CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(49.860348,8.686227);
  IKPoint* p = [[IKPoint alloc] initWithCoordinate:coordinate];
  p.heading=101;
  p.toleranceRadius=102;
  p.holdTime=103;
  p.eventFlag=104;
  p.index=105;
  p.prefix=@"Y";
  p.type=106;
  p.wpEventChannelValue=107;
  p.altitudeRate=108;
  p.speed=109;
  p.camAngle=111;
  p.cameraNickControl=YES;
  
  GHAssertEquals(p.coordinate, coordinate, @"Coordinate is not correct");
  
  
  NSMutableData *data = [[NSMutableData alloc] init];
  
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  
  [archiver encodeObject:p forKey:@"data"];
  [archiver finishEncoding];
  

  NSLog(@"Data %@",[data base64EncodedString]);
  
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  
  IKPoint* p2 = [unarchiver decodeObjectForKey:@"data"];

  GHAssertEquals(p.coordinate, p2.coordinate, @"unarchived is not equal");
  GHAssertEquals(p.heading, p2.heading, @"unarchived is not equal");
  GHAssertEquals(p.toleranceRadius, p2.toleranceRadius, @"unarchived is not equal");
  GHAssertEquals(p.holdTime, p2.holdTime, @"unarchived is not equal");
  GHAssertEquals(p.eventFlag, p2.eventFlag, @"unarchived is not equal");
  GHAssertEquals(p.index, p2.index, @"unarchived is not equal");
  GHAssertEquals(p.type, p2.type, @"unarchived is not equal");
  GHAssertEquals(p.wpEventChannelValue, p2.wpEventChannelValue, @"unarchived is not equal");
  GHAssertEquals(p.altitudeRate, p2.altitudeRate, @"unarchived is not equal");
  GHAssertEquals(p.speed, p2.speed, @"unarchived is not equal");
  GHAssertEquals(p.camAngle, p2.camAngle, @"unarchived is not equal");
  GHAssertEquals(p.cameraNickControl, p2.cameraNickControl, @"unarchived is not equal");
  GHAssertEqualStrings(p.name, p2.name, @"unarchived is not equal");
  
}


// All code under test is in the iOS Application
- (void)testWaypointNSCodingFromData
{
  CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(49.860348,8.686227);
  IKPoint* p = [[IKPoint alloc] initWithCoordinate:coordinate];
  p.heading=101;
  p.toleranceRadius=102;
  p.holdTime=103;
  p.eventFlag=104;
  p.index=105;
  p.type=106;
  p.wpEventChannelValue=107;
  p.altitudeRate=108;
  p.speed=109;
  p.camAngle=111;
  p.cameraNickControl=YES;
  
  GHAssertEquals(p.coordinate, coordinate, @"Coordinate is not correct");
  
  
  NSMutableString* dataString=[NSMutableString string];
  
  [dataString appendString:@"YnBsaXN0MDDUAQIDBAUIMTJUJHRvcFgkb2JqZWN0c1gkdmVyc2lvblkkYXJjaGl2"];
  [dataString appendString:@"ZXLRBgdUZGF0YYABowkKKVUkbnVsbN8QDwsMDQ4PEBESExQVFhcYGRobHB0eHyAh"];
  [dataString appendString:@"IiMkJSYnKF8QD3RvbGVyYW5jZVJhZGl1c1lldmVudEZsYWdYYWx0aXR1ZGVUdHlw"];
  [dataString appendString:@"ZVlsb25naXR1ZGVYbGF0aXR1ZGVXaGVhZGluZ18QE3dwRXZlbnRDaGFubmVsVmFs"];
  [dataString appendString:@"dWVcYWx0aXR1ZGVSYXRlWGhvbGRUaW1lVWluZGV4WGNhbUFuZ2xlViRjbGFzc1Zz"];
  [dataString appendString:@"dGF0dXNVc3BlZWQQZhBpEAAQahIFLWm+Eh24FdgQZRBrEGwQZxBpEG+AAhABEG3S"];
  [dataString appendString:@"KissMFgkY2xhc3Nlc1okY2xhc3NuYW1loy0uL1dJS1BvaW50WElLR1BTUG9zWE5T"];
  [dataString appendString:@"T2JqZWN0V0lLUG9pbnQSAAGGoF8QD05TS2V5ZWRBcmNoaXZlcgAIABEAFgAfACgA"];
  [dataString appendString:@"MgA1ADoAPABAAEYAZwB5AIMAjACRAJsApACsAMIAzwDYAN4A5wDuAPUA+wD9AP8B"];
  [dataString appendString:@"AQEDAQgBDQEPAREBEwEVARcBGQEbAR0BHwEkAS0BOAE8AUQBTQFWAV4BYwAAAAAA"];
  [dataString appendString:@"AAIBAAAAAAAAADMAAAAAAAAAAAAAAAAAAAF1"];

  NSData *data = [NSData dataFromBase64String:dataString];
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  
  IKPoint* p2 = [unarchiver decodeObjectForKey:@"data"];
  
  GHAssertEquals(p.coordinate, p2.coordinate, @"unarchived is not equal");
  GHAssertEquals(p.heading, p2.heading, @"unarchived is not equal");
  GHAssertEquals(p.toleranceRadius, p2.toleranceRadius, @"unarchived is not equal");
  GHAssertEquals(p.holdTime, p2.holdTime, @"unarchived is not equal");
  GHAssertEquals(p.eventFlag, p2.eventFlag, @"unarchived is not equal");
  GHAssertEquals(p.index, p2.index, @"unarchived is not equal");
  GHAssertEquals(p.type, p2.type, @"unarchived is not equal");
  GHAssertEquals(p.wpEventChannelValue, p2.wpEventChannelValue, @"unarchived is not equal");
  GHAssertEquals(p.altitudeRate, p2.altitudeRate, @"unarchived is not equal");
  GHAssertEquals(p.speed, p2.speed, @"unarchived is not equal");
  GHAssertEquals(p.camAngle, p2.camAngle, @"unarchived is not equal");
  GHAssertEquals(p.cameraNickControl, p2.cameraNickControl, @"unarchived is not equal");
  
}


// All code under test is in the iOS Application
- (void)testIKGSPPosNSCoding
{
  CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(49.860348,8.686227);
  IKGPSPos* p = [[IKGPSPos alloc] initWithCoordinate:coordinate];
  
  p.altitude=101;
  p.status=102;
  
  GHAssertEquals(p.coordinate, coordinate, @"Coordinate is not correct");
  
  NSMutableData *data = [[NSMutableData alloc] init];
  
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
  
  [archiver encodeObject:p forKey:@"data"];
  [archiver finishEncoding];
  
  NSLog(@"Data %@",[data base64EncodedString]);
  
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  
  IKGPSPos* p2 = [unarchiver decodeObjectForKey:@"data"];
  
  GHAssertEquals(p.coordinate, p2.coordinate, @"unarchived is not equal");
  GHAssertEquals(p.altitude, p2.altitude, @"unarchived is not equal");
  GHAssertEquals(p.status, p2.status, @"unarchived is not equal");
}

// All code under test is in the iOS Application
- (void)testIKGSPPosNSCodingFromData
{
  CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(49.860348,8.686227);
  IKGPSPos* p = [[IKGPSPos alloc] initWithCoordinate:coordinate];
  
  p.altitude=101;
  p.status=102;
  
  GHAssertEquals(p.coordinate, coordinate, @"Coordinate is not correct");
  
  NSMutableString* dataString=[NSMutableString string];
  
  [dataString appendString:@"YnBsaXN0MDDUAQIDBAUIHB1UJHRvcFgkb2JqZWN0c1gkdmVyc2lvblkkYXJjaGl2"];
  [dataString appendString:@"ZXLRBgdUZGF0YYABowkKFVUkbnVsbNULDA0ODxAREhMUWGFsdGl0dWRlWWxvbmdp"];
  [dataString appendString:@"dHVkZVhsYXRpdHVkZVYkY2xhc3NWc3RhdHVzEGUSBS1pvhIduBXYgAIQZtIWFxgb"];
  [dataString appendString:@"WCRjbGFzc2VzWiRjbGFzc25hbWWiGRpYSUtHUFNQb3NYTlNPYmplY3RYSUtHUFNQ"];
  [dataString appendString:@"b3MSAAGGoF8QD05TS2V5ZWRBcmNoaXZlcggRFh8oMjU6PEBGUVpkbXR7fYKHiYuQ"];
  [dataString appendString:@"maSnsLnCxwAAAAAAAAEBAAAAAAAAAB4AAAAAAAAAAAAAAAAAAADZ"];

  NSData *data = [NSData dataFromBase64String:dataString];
  NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
  
  IKGPSPos* p2 = [unarchiver decodeObjectForKey:@"data"];
  
  GHAssertEquals(p.coordinate, p2.coordinate, @"unarchived is not equal");
  GHAssertEquals(p.altitude, p2.altitude, @"unarchived is not equal");
  GHAssertEquals(p.status, p2.status, @"unarchived is not equal");
}

@end
