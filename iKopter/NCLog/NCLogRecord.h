// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////

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
