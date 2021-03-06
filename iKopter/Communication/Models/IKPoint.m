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
@synthesize speed;
@synthesize camAngle;
@synthesize name;
@synthesize prefix;

-(NSInteger) altitude{
  return [super altitude];
}

-(void) setAltitude:(NSInteger)alt{
  [super setAltitude:alt];
}

-(CLLocationCoordinate2D) coordinate{
  return [super coordinate];
}

-(void) setCoordinate:(CLLocationCoordinate2D)coordinate{
  [super setCoordinate:coordinate];
  [super setStatus:NEWDATA]; 
}

-(CLLocationDegrees) posLatitude{
  return self.coordinate.latitude;
};
-(void) setPosLatitude:(CLLocationDegrees)latitude{
  [super setCoordinate:CLLocationCoordinate2DMake(latitude, self.coordinate.longitude)];
  [super setStatus:NEWDATA]; 
};

-(CLLocationDegrees) posLongitude{
  return self.coordinate.longitude;
};

-(void) setPosLongitude:(CLLocationDegrees)longitude{
  [super setCoordinate:CLLocationCoordinate2DMake(self.coordinate.latitude, longitude)];
  [super setStatus:NEWDATA]; 
};

//-(NSInteger) camAngle{
//  if(self.cameraNickControl)
//    return -1;
//  
//  return camAngle;
//}
//
//-(void) setCamAngle:(NSInteger)angle{
//  if( angle < 0 ){
//    camAngle=0;
//    self.cameraNickControl=YES;
//  }
//  else {
//    camAngle = angle;
//    self.cameraNickControl=YES;
//  }
//}

-(BOOL) cameraNickControl{
  return (self.eventFlag&WP_EVFLAG_CAMERA_NICK_CONTROL)==WP_EVFLAG_CAMERA_NICK_CONTROL;
}

-(void) setCameraNickControl:(BOOL) value {
  if(value)
    self.eventFlag |= WP_EVFLAG_CAMERA_NICK_CONTROL;
  else
    self.eventFlag &= ~WP_EVFLAG_CAMERA_NICK_CONTROL;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
  [self updateName];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)pointWithData:(NSData *)data {
  return [[[IKPoint alloc] initWithData:data]autorelease];
}

- (id)init
{
  self = [super init];
  if (self) {
    [self addObserver:self forKeyPath:@"index" options:0 context:0];
    [self addObserver:self forKeyPath:@"prefix" options:0 context:0];
  }
  return self;
}

- (id)initWithData:(NSData*)data {
  const char* b=[data bytes];
  b++;
  b++;
  IKMkPoint _point;
  memcpy(&_point,b,sizeof(_point));

  self = [super initWithMkPos:&(_point.Position)];
  if (self != nil) {
    
    [self addObserver:self forKeyPath:@"index" options:0 context:0];
    [self addObserver:self forKeyPath:@"prefix" options:0 context:0];
    
    self.heading = _point.Heading;             
    self.toleranceRadius = _point.ToleranceRadius;     
    self.holdTime = _point.HoldTime;            
    self.eventFlag = _point.Event_Flag;          
    self.index = _point.Index;   
    self.type = _point.Type;                
    self.wpEventChannelValue = _point.WP_EventChannelValue;
    self.altitudeRate = _point.AltitudeRate;  
    self.speed = _point.Speed;  
    self.camAngle = _point.CamAngle;  
    
    self.name = [NSString stringWithCString:(const char *)_point.Name encoding:NSASCIIStringEncoding];
    self.prefix = [self.name substringToIndex:1];

    if(self.type==POINT_TYPE_POI)
      self.altitude/=100;
    else
      self.altitude/=10;
    
  }
  return self;
}

- (NSData*) data{
  IKMkPoint _point;
  memset(&_point, 0, sizeof(IKMkPoint));
  
  unsigned char payloadData[sizeof(_point)];
  
  _point.Heading = self.heading;             
  _point.ToleranceRadius = self.toleranceRadius;     
  _point.HoldTime = self.holdTime;            
  _point.Event_Flag = self.eventFlag;          
  _point.Index = self.index;               
  _point.Type = self.type;                
  _point.WP_EventChannelValue = self.wpEventChannelValue;
  _point.AltitudeRate = self.altitudeRate;    
  _point.Speed = self.speed;    
  _point.CamAngle = self.camAngle;   
  
  memset(_point.Name, 0, 4);
  
  [self.name getBytes:(void*)_point.Name 
       maxLength:4 
      usedLength:NULL 
        encoding:NSASCIIStringEncoding 
         options:0 
           range:NSMakeRange(0,[self.name length]) 
  remainingRange:NULL];
  
  memset(_point.reserve, 0, 2);
  
  _point.Position.Altitude = self.type==POINT_TYPE_POI?self.altitude*100:self.altitude*10;
  _point.Position.Longitude = self.longitude;
  _point.Position.Latitude = self.latitude;
  _point.Position.Status = self.status;
  
  memcpy((unsigned char *)(payloadData),(unsigned char *)&_point,sizeof(_point));
  
  return [NSData dataWithBytes:payloadData length:sizeof(payloadData)];  
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate{
  self = [super init];
  if (self != nil) {
    
    [self addObserver:self forKeyPath:@"index" options:0 context:0];
    [self addObserver:self forKeyPath:@"prefix" options:0 context:0];

    self.heading = 0;            
    self.altitude = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultAltitude"] integerValue];
    self.toleranceRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultToleranceRadius"] integerValue];
    self.holdTime = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultHoldTime"] integerValue];
    self.eventFlag = 0;     
    self.prefix = [[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultPrefix"];
    self.index = 0;               
    self.type = POINT_TYPE_WP;                
    self.wpEventChannelValue = 0;
    self.altitudeRate = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultAltitudeRate"] integerValue];
    self.speed = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultSpeed"] integerValue];
    self.camAngle = [[[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultCamAngle"] integerValue];;
    self.eventFlag = 0;          
    self.prefix = [[NSUserDefaults standardUserDefaults] stringForKey:@"WpDefaultPrefix"];
    self.index = 0;               
    
    self.coordinate=theCoordinate;

    [super setStatus:NEWDATA]; 
  }
  return self;
}

- (id)initWithLocation:(CLLocation*)location{
  return [self initWithCoordinate:location.coordinate];
}

- (void)dealloc
{
  [self removeObserver:self forKeyPath:@"index"];
  [self removeObserver:self forKeyPath:@"prefix"];
  
  self.name = nil;
  self.prefix = nil;
  [super dealloc];
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
  [aCoder encodeInteger:self.speed forKey:@"speed"];
  [aCoder encodeInteger:self.camAngle forKey:@"camAngle"];
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.prefix forKey:@"prefix"];
  
}
- (id)initWithCoder:(NSCoder *)aDecoder{
  if ((self = [super initWithCoder:aDecoder])) {
    
    [self addObserver:self forKeyPath:@"index" options:0 context:0];
    [self addObserver:self forKeyPath:@"prefix" options:0 context:0];

    self.heading = [aDecoder decodeIntegerForKey:@"heading"];
    self.toleranceRadius = [aDecoder decodeIntegerForKey:@"toleranceRadius"];
    self.holdTime = [aDecoder decodeIntegerForKey:@"holdTime"];
    self.heading = [aDecoder decodeIntegerForKey:@"heading"];
    self.eventFlag = [aDecoder decodeIntegerForKey:@"eventFlag"];
    self.prefix = [aDecoder decodeObjectForKey:@"prefix"];
    self.index = [aDecoder decodeIntegerForKey:@"index"];
    self.type = [aDecoder decodeIntegerForKey:@"type"];
    self.wpEventChannelValue = [aDecoder decodeIntegerForKey:@"wpEventChannelValue"];
    self.altitudeRate = [aDecoder decodeIntegerForKey:@"altitudeRate"];
    self.speed = [aDecoder decodeIntegerForKey:@"speed"];
    self.camAngle = [aDecoder decodeIntegerForKey:@"camAngle"];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    
    [self updateName];
  }
  return self;
}

-(NSString*) description{
  return [NSString stringWithFormat:@"%@-%d:%d:%d:(%d):%d",self.name,self.latitude,self.longitude,self.altitude,self.index,self.heading];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)updateName{
  self.name = [NSString stringWithFormat:@"%@%d",self.prefix,self.index];
}

- (NSString *)title {
  if (self.type==POINT_TYPE_WP) {
    return [NSString stringWithFormat:NSLocalizedString(@"Waypoint - Index %d", @"WP Annotation callout"),self.index];
  } else if(self.type==POINT_TYPE_POI){
    return [NSString stringWithFormat:NSLocalizedString(@"POI - Index %d", @"POI Annotation callout"),self.index];
  }
  return  [NSString stringWithFormat:NSLocalizedString(@"Invalid - Index %d", @"INvalid WP Annotation callout"),self.index];
}

-(NSString*) formatHeading{
  if(heading>0)
    return [NSString stringWithFormat:@"%d°",heading];
  
  if(heading<0)
    return [NSString stringWithFormat:@"P%d°",-heading];
  
  return @"--";
}

@end
