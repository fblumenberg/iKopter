#import <UIKit/UIKit.h>

#import "GHUnit.h"
#import "InnerBand.h"

#import "IKMkDataTypes.h"
#import "IKNaviData.h"

#import "MKDataConstants.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "NSData+MKPayloadEncode.h"

#import "NSString+Parsing.h"

#define kDEGREE_FACTOR 10000000.0
#define kALTITUDE_FACTOR 1000.0

enum CsvIndex {
  CSV_altimeter = 0, CSV_angleNick, CSV_angleRoll, CSV_compassHeading, CSV_current, CSV_currentPosition,
  CSV_errorCode, CSV_fcStatusFlags, CSV_fcStatusFlags2, CSV_flyingTime, CSV_gas, CSV_groundSpeed,
  CSV_heading, CSV_homePosition, CSV_homePositionDeviation, CSV_ncFlags, CSV_operatingRadius,
  CSV_rcQuality, CSV_satsInUse, CSV_setpointAltitude, CSV_targetHoldTime, CSV_targetPosition,
  CSV_targetPositionDeviation, CSV_timeStamp, CSV_topSpeed, CSV_uBat, CSV_usedCapacity,
  CSV_variometer, CSV_version, CSV_waypointIndex, CSV_waypointNumber
};


@interface MKCommandNaviDataTest : GHTestCase{
  NSArray* csvData;
  IKMkNaviData naviData;
}

- (void)updateNaviDataFromRow:(NSInteger)row;

@end

@implementation MKCommandNaviDataTest

- (void)setUpClass {
  
  NSString* rows = 
  @"26,0,0,348,115,498215900:86610483:158797:1,0,195,0,8,124,320,0,498215288:86610628:151519:1,68:172,129,101,199,6,26,0,0:0:0:0,0:0,2011-08-18 10:12:08 +0000,98,121,37,8,5,0,0" 
  @"19,0,0,339,115,498215926:86610411:158536:1,0,195,0,9,127,313,0,498215288:86610628:151519:1,73:169,129,101,195,6,19,0,0:0:0:0,0:0,2011-08-18 10:12:09 +0000,63,120,40,-4,5,0,0"
  @"7,0,0,334,130,498215962:86610323:158583:1,0,195,0,10,129,288,0,498215288:86610628:151519:1,79:165,129,101,192,6,7,0,0:0:0:0,0:0,2011-08-18 10:12:10 +0000,31,120,43,-6,5,0,0";
  
  csvData = [rows csvRows];
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}   

- (void)testDecodingIKGPSPos{
  
  IKMkGPSPos mkPos;
  
  CLLocationDegrees latitude=49.860348;
	CLLocationDegrees longitude=8.686227;
  
  NSInteger altitude=15;

  mkPos.Latitude = latitude*kDEGREE_FACTOR;
  mkPos.Longitude = longitude*kDEGREE_FACTOR;
  mkPos.Altitude = altitude*kALTITUDE_FACTOR;
  mkPos.Status = NEWDATA;

  IKGPSPos* pos = [IKGPSPos positionWithMkPos:&mkPos];
  
  GHAssertNotNil(pos,nil);
  
  GHAssertEquals(pos.latitude, (NSInteger)mkPos.Latitude,nil);
  GHAssertEquals(pos.longitude, (NSInteger)mkPos.Longitude,nil);
  GHAssertEquals(pos.altitude, (NSInteger)mkPos.Altitude,nil);
  GHAssertEquals(pos.status, (NSInteger)mkPos.Status,nil);
  
  CLLocationCoordinate2D location = pos.coordinate;

  GHAssertEquals(latitude, location.latitude,nil);
  GHAssertEquals(longitude, location.longitude,nil);
  
  location = CLLocationCoordinate2DMake(48.123456, 7.123456);

  pos.coordinate = location;
  GHAssertEquals(pos.latitude, (NSInteger)(location.latitude*kDEGREE_FACTOR),nil);
  GHAssertEquals(pos.longitude, (NSInteger)(location.longitude*kDEGREE_FACTOR),nil);
}

- (void)testIKGPSPosDev{

  IKMkGPSPosDev mkDev;
  
  mkDev.Distance = 1234567;
  mkDev.Bearing = 987;
  
  IKGPSPosDev* dev = [IKGPSPosDev positionWithMkPosDev:&mkDev];
  
  GHAssertEquals(dev.distance, (NSUInteger)mkDev.Distance,nil);
  GHAssertEquals(dev.bearing, (NSInteger)mkDev.Bearing,nil);
}

- (void)testDecodingIKNaviData{

  [self updateNaviDataFromRow:0];
  
  NSData *payload = [NSData dataWithBytes:(void *) &naviData length:sizeof(naviData)];

  NSData *data = [payload dataWithCommand:MKCommandOsdResponse forAddress:kIKMkAddressNC];
  
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);

  NSData* payload2 = [data payload];
  
  IKNaviData* n = [IKNaviData dataWithData:payload2];
  GHAssertNotNil(n,nil);
  
  GHAssertEquals(memcmp(n.data, &naviData, sizeof(naviData)), 0,nil);
}

- (void)testDecodingIKNaviDataDictionary {
  [self updateNaviDataFromRow:0];
  
  NSData *payload = [NSData dataWithBytes:(void *) &naviData length:sizeof(naviData)];
  
  NSData *data = [payload dataWithCommand:MKCommandOsdResponse forAddress:kIKMkAddressNC];
  
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSDictionary* di = [payload decodeOsdResponse];
  GHAssertGreaterThan([di count],0U,nil);
  
  IKNaviData* n=[di objectForKey:kIKDataKeyOsd];
  
  GHAssertNotNil(n,nil);
  
  GHAssertEquals(memcmp(n.data, &naviData, sizeof(naviData)), 0,nil);
}

#pragma mark - prepare data

void fillIKMkGPSPosDevFromString(NSString *data, IKMkGPSPosDev *pos) {
  
  NSArray *components = [data componentsSeparatedByString:@":"];
  
  pos->Distance = [[components objectAtIndex:0] intValue];
  pos->Bearing = [[components objectAtIndex:1] intValue];
}

void fillIKMkGPSPosFromString(NSString *data, IKMkGPSPos *pos) {
  
  NSArray *components = [data componentsSeparatedByString:@":"];
  
  pos->Latitude = [[components objectAtIndex:0] intValue];
  pos->Longitude = [[components objectAtIndex:1] intValue];
  
  pos->Altitude = [[components objectAtIndex:2] intValue];
  pos->Status = [[components objectAtIndex:3] intValue];
}

- (void)updateNaviDataFromRow:(NSInteger)row {
  NSArray *columns = [csvData objectAtIndex:(NSUInteger) row];
  
  naviData.Version = NAVIDATA_VERSION;
  
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_currentPosition], &(naviData.CurrentPosition));
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_targetPosition], &(naviData.TargetPosition));
  fillIKMkGPSPosFromString([columns objectAtIndex:CSV_homePosition], &(naviData.HomePosition));
  
  fillIKMkGPSPosDevFromString([columns objectAtIndex:CSV_homePositionDeviation], &(naviData.HomePositionDeviation));
  fillIKMkGPSPosDevFromString([columns objectAtIndex:CSV_targetPositionDeviation], &(naviData.TargetPositionDeviation));
  
  naviData.WaypointIndex = (u_int8_t)[[columns objectAtIndex:CSV_waypointIndex] intValue];        // index of current waypoints running from 0 to WaypointNumber-1
  naviData.WaypointNumber = (u_int8_t)[[columns objectAtIndex:CSV_waypointNumber] intValue];       // number of stored waypoints
  naviData.SatsInUse = (u_int8_t)[[columns objectAtIndex:CSV_satsInUse] intValue];          // number of satellites used for position solution
  naviData.Altimeter = (u_int8_t)[[columns objectAtIndex:CSV_altimeter] intValue];          // hight according to air pressure
  naviData.Variometer = (int16_t) [[columns objectAtIndex:CSV_variometer] intValue];         // climb(+) and sink(-) rate
  naviData.FlyingTime = (uint16_t) [[columns objectAtIndex:CSV_flyingTime] intValue];         // in seconds
  naviData.UBat = (uint8_t) [[columns objectAtIndex:CSV_uBat] intValue];           // Battery Voltage in 0.1 Volts
  naviData.GroundSpeed = (uint16_t) [[columns objectAtIndex:CSV_groundSpeed] intValue];        // speed over ground in cm/s (2D)
  naviData.Heading = (int16_t) [[columns objectAtIndex:CSV_heading] intValue];          // current flight direction in � as angle to north
  naviData.CompassHeading = (int16_t) [[columns objectAtIndex:CSV_compassHeading] intValue];       // current compass value in �
  naviData.AngleNick = (int8_t) [[columns objectAtIndex:CSV_angleNick] intValue];          // current Nick angle in 1�
  naviData.AngleRoll = (int8_t) [[columns objectAtIndex:CSV_angleRoll] intValue];          // current Rick angle in 1�
  naviData.RC_Quality = (uint8_t) [[columns objectAtIndex:CSV_rcQuality] intValue];         // RC_Quality
  naviData.FCStatusFlags = (uint8_t) [[columns objectAtIndex:CSV_fcStatusFlags] intValue];        // Flags from FC
  naviData.NCFlags = (uint8_t) [[columns objectAtIndex:CSV_ncFlags] intValue];          // Flags from NC
  naviData.Errorcode = (uint8_t) [[columns objectAtIndex:CSV_errorCode] intValue];          // 0 --> okay
  naviData.OperatingRadius = (uint8_t) [[columns objectAtIndex:CSV_operatingRadius] intValue];      // current operation radius around the Home Position in m
  naviData.TopSpeed = (int16_t) [[columns objectAtIndex:CSV_topSpeed] intValue];         // velocity in vertical direction in cm/s
  naviData.TargetHoldTime = (uint8_t) [[columns objectAtIndex:CSV_targetHoldTime] intValue];       // time in s to stay at the given target, counts down to 0 if target has been reached
  naviData.FCStatusFlags2 = (uint8_t) [[columns objectAtIndex:CSV_fcStatusFlags2] intValue];        // StatusFlags2 (since version 5 added)
  naviData.SetpointAltitude = (int16_t) [[columns objectAtIndex:CSV_setpointAltitude] intValue];     // setpoint for altitude
  naviData.Gas = (uint8_t) [[columns objectAtIndex:CSV_gas] intValue];            // for future use
  naviData.Current = (uint16_t) [[columns objectAtIndex:CSV_current] intValue];          // actual current in 0.1A steps
  naviData.UsedCapacity = (uint16_t) [[columns objectAtIndex:CSV_usedCapacity] intValue];       // used capacity in mAh
}

@end
