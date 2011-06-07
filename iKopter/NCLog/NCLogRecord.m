//
//  NCLogRecord.m
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NCLogRecord.h"
#import "NCLogSession.h"
#import "IKNaviData.h"

@implementation NCLogRecord
@dynamic timeStamp;
@dynamic rcQuality;
@dynamic targetPositionDeviation;
@dynamic homePosition;
@dynamic targetHoldTime;
@dynamic setpointAltitude;
@dynamic groundSpeed;
@dynamic fcStatusFlags2;
@dynamic currentPosition;
@dynamic flyingTime;
@dynamic version;
@dynamic fcStatusFlags;
@dynamic angleNick;
@dynamic targetPosition;
@dynamic heading;
@dynamic angleRoll;
@dynamic variometer;
@dynamic waypointNumber;
@dynamic homePositionDeviation;
@dynamic satsInUse;
@dynamic errorCode;
@dynamic topSpeed;
@dynamic current;
@dynamic operatingRadius;
@dynamic uBat;
@dynamic gas;
@dynamic altimeter;
@dynamic compassHeading;
@dynamic usedCapacity;
@dynamic ncFlags;
@dynamic waypointIndex;
@dynamic session;

-(void) fillFromNCData:(IKNaviData*)ncData{
  self.version = [NSNumber numberWithInt:ncData.data->Version];            // version of the data structure
  self.currentPosition = [IKGPSPos positionWithMkPos:&(ncData.data->CurrentPosition)];    // see ubx.h for details
  self.targetPosition = [IKGPSPos positionWithMkPos:&(ncData.data->TargetPosition)];
  self.targetPositionDeviation = [IKGPSPosDev positionWithMkPosDev:&(ncData.data->TargetPositionDeviation)];
  self.homePosition = [IKGPSPos positionWithMkPos:&(ncData.data->HomePosition)];
  self.homePositionDeviation = [IKGPSPosDev positionWithMkPosDev:&(ncData.data->HomePositionDeviation)];
  self.waypointIndex = [NSNumber numberWithInt:ncData.data->WaypointIndex];        // index of current waypoints running from 0 to WaypointNumber-1
  self.waypointNumber = [NSNumber numberWithInt:ncData.data->WaypointNumber];       // number of stored waypoints
  self.satsInUse = [NSNumber numberWithInt:ncData.data->SatsInUse];          // number of satellites used for position solution
  self.altimeter = [NSNumber numberWithInt:ncData.data->Altimeter];          // hight according to air pressure
  self.variometer = [NSNumber numberWithInt:ncData.data->Variometer];         // climb(+) and sink(-) rate
  self.flyingTime = [NSNumber numberWithInt:ncData.data->FlyingTime];         // in seconds
  self.uBat = [NSNumber numberWithInt:ncData.data->UBat];           // Battery Voltage in 0.1 Volts
  self.groundSpeed = [NSNumber numberWithInt:ncData.data->Heading];          // current flight direction in � as angle to north
  self.compassHeading = [NSNumber numberWithInt:ncData.data->CompassHeading];       // current compass value in �
  self.angleNick = [NSNumber numberWithInt:ncData.data->AngleNick];          // current Nick angle in 1�
  self.angleRoll = [NSNumber numberWithInt:ncData.data->AngleRoll];          // current Rick angle in 1�
  self.rcQuality = [NSNumber numberWithInt:ncData.data->RC_Quality];         // RC_Quality
  self.fcStatusFlags = [NSNumber numberWithInt:ncData.data->FCStatusFlags];        // Flags from FC
  self.ncFlags = [NSNumber numberWithInt:ncData.data->NCFlags];          // Flags from NC
  self.errorCode = [NSNumber numberWithInt:ncData.data->Errorcode];          // 0 --> okay
  self.operatingRadius = [NSNumber numberWithInt:ncData.data->OperatingRadius];      // current operation radius around the Home Position in m
  self.topSpeed = [NSNumber numberWithInt:ncData.data->TopSpeed];         // velocity in vertical direction in cm/s
  self.targetHoldTime = [NSNumber numberWithInt:ncData.data->TargetHoldTime];       // time in s to stay at the given target, counts down to 0 if target has been reached
  self.fcStatusFlags2 = [NSNumber numberWithInt:ncData.data->FCStatusFlags2];				// StatusFlags2 (since version 5 added)
  self.setpointAltitude = [NSNumber numberWithInt:ncData.data->SetpointAltitude];     // setpoint for altitude
  self.gas = [NSNumber numberWithInt:ncData.data->Gas];            // for future use
  self.current = [NSNumber numberWithInt:ncData.data->Current];          // actual current in 0.1A steps
  self.usedCapacity = [NSNumber numberWithInt:ncData.data->UsedCapacity];       // used capacity in mAh
}

@end
