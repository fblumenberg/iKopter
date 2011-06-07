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


#import "IKNaviData.h"

@implementation IKNaviData

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//@synthesize address;
- (IKMkNaviData*)data {
  return &_data;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)data {
  IKMkNaviData data;
  memset(&data,1,sizeof(data));
  return [[[IKNaviData alloc] initWithData:[NSData dataWithBytesNoCopy:&data length:sizeof(data) freeWhenDone:NO]]autorelease];
}

+ (id)dataWithData:(NSData *)data {
  return [[[IKNaviData alloc] initWithData:data]autorelease];
}

- (id)initWithData:(NSData*)data {
  self = [super init];
  if (self != nil) {
    memcpy(&_data,[data bytes],sizeof(_data));
//    NSLog(@"Roll %d",_data.AngleRoll);
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end


@implementation IKGPSPos

@synthesize latitude;
@synthesize longitude;
@synthesize altitude;
@synthesize status;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)positionWithMkPos:(IKMkGPSPos *)pos {
  return [[[IKGPSPos alloc] initWithMkPos:pos]autorelease];
}

- (id)initWithMkPos:(IKMkGPSPos*)pos {
  self = [super init];
  if (self != nil) {
    self.latitude=pos->Latitude;
    self.longitude=pos->Longitude;
    self.altitude=pos->Altitude;
    self.status=pos->Status;
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeInteger:self.latitude forKey:@"latitude"];
  [aCoder encodeInteger:self.longitude forKey:@"longitude"];
  [aCoder encodeInteger:self.altitude forKey:@"altitude"];
  [aCoder encodeInteger:self.status forKey:@"status"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
  if ((self = [super init])) {
    self.latitude=[aDecoder decodeIntegerForKey:@"latitude"];
    self.longitude=[aDecoder decodeIntegerForKey:@"longitude"];
    self.altitude=[aDecoder decodeIntegerForKey:@"altitude"];
    self.status=[aDecoder decodeIntegerForKey:@"status"];
  }
  return self;
}

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


@implementation IKGPSPosDev

@synthesize distance;
@synthesize bearing;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)positionWithMkPosDev:(IKMkGPSPosDev *)pos {
  return [[[IKGPSPosDev alloc] initWithMkPosDev:pos]autorelease];
}

- (id)initWithMkPosDev:(IKMkGPSPosDev *)pos {
  self = [super init];
  if (self != nil) {
    self.distance=pos->Distance;
    self.bearing=pos->Bearing;
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeInteger:self.distance forKey:@"distance"];
  [aCoder encodeInteger:self.bearing forKey:@"bearing"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
  if ((self = [super init])) {
    self.distance=[aDecoder decodeIntegerForKey:@"distance"];
    self.bearing=[aDecoder decodeIntegerForKey:@"bearing"];
  }
  return self;
}

@end

