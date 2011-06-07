//
//  NCLogRecord.h
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCLogSession;
@class IKGpsPos;
@class IKGpsPosDev;
@class IKNaviData;

@interface NCLogRecord : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSNumber * rcQuality;
@property (nonatomic, retain) IKGpsPosDev* targetPositionDeviation;
@property (nonatomic, retain) IKGpsPos* homePosition;
@property (nonatomic, retain) NSNumber * targetHoldTime;
@property (nonatomic, retain) NSNumber * setpointAltitude;
@property (nonatomic, retain) NSNumber * groundSpeed;
@property (nonatomic, retain) NSNumber * fcStatusFlags2;
@property (nonatomic, retain) IKGpsPos* currentPosition;
@property (nonatomic, retain) NSNumber * flyingTime;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * fcStatusFlags;
@property (nonatomic, retain) NSNumber * angleNick;
@property (nonatomic, retain) IKGpsPos* targetPosition;
@property (nonatomic, retain) NSNumber * heading;
@property (nonatomic, retain) NSNumber * angleRoll;
@property (nonatomic, retain) NSNumber * variometer;
@property (nonatomic, retain) NSNumber * waypointNumber;
@property (nonatomic, retain) IKGpsPosDev* homePositionDeviation;
@property (nonatomic, retain) NSNumber * satsInUse;
@property (nonatomic, retain) NSNumber * errorCode;
@property (nonatomic, retain) NSNumber * topSpeed;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSNumber * operatingRadius;
@property (nonatomic, retain) NSNumber * uBat;
@property (nonatomic, retain) NSNumber * gas;
@property (nonatomic, retain) NSNumber * altimeter;
@property (nonatomic, retain) NSNumber * compassHeading;
@property (nonatomic, retain) NSNumber * usedCapacity;
@property (nonatomic, retain) NSNumber * ncFlags;
@property (nonatomic, retain) NSNumber * waypointIndex;
@property (nonatomic, retain) NCLogSession * session;

-(void) fillFromNCData:(IKNaviData*)ncData;
@end
