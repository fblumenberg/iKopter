// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010-2011, Frank Blumenberg
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


#import "IKPoint.h"

@implementation IKPoint

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize heading;              // orientation, 0 no action, 1...360 fix heading, neg. = Index to POI in WP List
@synthesize toleranceRadius;      // in meters, if the MK is within that range around the target, then the next target is triggered
@synthesize holdTime;             // in seconds, if the was once in the tolerance area around a WP, this time defines the delay before the next WP is triggered
@synthesize eventFlag;           // future implementation
@synthesize index;                // to indentify different waypoints, workaround for bad communications PC <-> NC
@synthesize type;                 // typeof Waypoint
@synthesize wpEventChannelValue; //
@synthesize altitudeRate;         // rate to change the setpoint

-(CLLocationCoordinate2D) coordinate{
  return [super coordinate];
}

-(void) setCoordinate:(CLLocationCoordinate2D)coordinate{
  [super setCoordinate:coordinate];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)pointWithData:(NSData *)data {
  return [[[IKPoint alloc] initWithData:data]autorelease];
}

- (id)initWithData:(NSData*)data {
  const char* b=[data bytes];
  b++;
  b++;
  IKMkPoint _point;
  memcpy(&_point,b,sizeof(_point));

  self = [super initWithMkPos:&(_point.Position)];
  if (self != nil) {
    
    self.heading = _point.Heading;             
    self.toleranceRadius = _point.ToleranceRadius;     
    self.holdTime = _point.HoldTime;            
    self.eventFlag = _point.Event_Flag;          
    self.index = _point.Index;               
    self.type = _point.Type;                
    self.wpEventChannelValue = _point.WP_EventChannelValue;
    self.altitudeRate = _point.AltitudeRate;  
  }
  return self;
}

- (NSData*) data{
  IKMkPoint _point;
  unsigned char payloadData[sizeof(_point)];
  
  _point.Heading = self.heading;             
  _point.ToleranceRadius = self.toleranceRadius;     
  _point.HoldTime = self.holdTime;            
  _point.Event_Flag = self.eventFlag;          
  _point.Index = self.index;               
  _point.Type = self.type;                
  _point.WP_EventChannelValue = self.wpEventChannelValue;
  _point.AltitudeRate = self.altitudeRate;            
  
  _point.Position.Altitude = self.altitude;
  _point.Position.Longitude = self.longitude;
  _point.Position.Latitude = self.latitude;
  _point.Position.Status = self.status;
  
  memcpy((unsigned char *)(payloadData),(unsigned char *)&_point,sizeof(_point));
  
  return [NSData dataWithBytes:payloadData length:sizeof(payloadData)];  
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate{
  self = [super init];
  if (self != nil) {
    self.heading = 0;             
    self.toleranceRadius = 5;     
    self.holdTime = 2;            
    self.eventFlag = 0;          
    self.index = 0;               
    self.type = POINT_TYPE_WP;                
    self.wpEventChannelValue = 0;
    self.altitudeRate = 20;  
    
    self.coordinate=theCoordinate;
  }
  return self;
}

- (id)initWithLocation:(CLLocation*)location{
  return [self initWithCoordinate:location.coordinate];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [super encodeWithCoder:aCoder];
  
  [aCoder encodeInteger:self.heading forKey:@"heading"];
  [aCoder encodeInteger:self.toleranceRadius forKey:@"toleranceRadius"];
  [aCoder encodeInteger:self.holdTime forKey:@"holdTime"];
  [aCoder encodeInteger:self.eventFlag forKey:@"eventFlag"];
  [aCoder encodeInteger:self.index forKey:@"index"];
  [aCoder encodeInteger:self.type forKey:@"type"];
  [aCoder encodeInteger:self.wpEventChannelValue forKey:@"wpEventChannelValue"];
  [aCoder encodeInteger:self.altitudeRate forKey:@"altitudeRate"];
  
}
- (id)initWithCoder:(NSCoder *)aDecoder{
  if ((self = [super initWithCoder:aDecoder])) {
    self.heading = [aDecoder decodeIntegerForKey:@"heading"];
    self.toleranceRadius = [aDecoder decodeIntegerForKey:@"toleranceRadius"];
    self.heading = [aDecoder decodeIntegerForKey:@"heading"];
    self.eventFlag = [aDecoder decodeIntegerForKey:@"eventFlag"];
    self.index = [aDecoder decodeIntegerForKey:@"index"];
    self.type = [aDecoder decodeIntegerForKey:@"type"];
    self.wpEventChannelValue = [aDecoder decodeIntegerForKey:@"wpEventChannelValue"];
    self.altitudeRate = [aDecoder decodeIntegerForKey:@"altitudeRate"];
  }
  return self;
}

//-(NSString*) description{
//  return [NSString stringWithFormat:@"%d:%d:%d:%d",self.latitude,self.longitude,self.altitude,self.status];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)title {
  return  [NSString stringWithFormat:NSLocalizedString(@"Waypoint %d", @"WP Annotation callout"),self.index];
}

@end
