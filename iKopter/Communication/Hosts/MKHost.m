// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010, Frank Blumenberg
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

#import "MKHost.h"

#define    kNameKey             @"name"
#define    kAddressKey          @"address"
#define    kPinKey              @"pin"
#define    kConnectionClassKey  @"connectionClass"

@implementation MKHost

@synthesize name=_name;
@synthesize address=_address;
@synthesize pin=_pin;
@synthesize connectionClass=_connectionClass;

- (id) init
{
  self = [super init];
  if (self != nil) {
    self.name = NSLocalizedString(@"New host",@"Default host name");
    self.address =@"";
    self.pin =@"";
  }
  return self;
}

- (void) dealloc
{
  self.name=nil;
  self.address=nil;
  self.connectionClass=nil;
  self.pin=nil;
  
  [super dealloc];
}

-(NSString*) description {
  return [NSString stringWithFormat:@"%@-%@",self.name,self.address];
}

-(UIImage*) cellImage{
  if([self.connectionClass isEqualToString:@"MKIpConnection"])
    return [UIImage imageNamed:@"icon-wifi.png"];
  if([self.connectionClass isEqualToString:@"MKSerialConnection"])
    return [UIImage imageNamed:@"icon-usb.png"];
  if([self.connectionClass isEqualToString:@"MKBluetoothConnection"])
    return [UIImage imageNamed:@"icon-bluetooth.png"];
  
  
  return [UIImage imageNamed:@"icon-phone.png"];
}


#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_name forKey:kNameKey];
  [encoder encodeObject:_address forKey:kAddressKey];
  [encoder encodeObject:_pin forKey:kPinKey];
  [encoder encodeObject:_connectionClass forKey:kConnectionClassKey];
}
- (id)initWithCoder:(NSCoder *)decoder {
  if ((self = [super init])) {
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.address = [decoder decodeObjectForKey:kAddressKey];
    self.pin = [decoder decodeObjectForKey:kPinKey];
    self.connectionClass = [decoder decodeObjectForKey:kConnectionClassKey];
  }
  return self;
}
#pragma mark -
#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
  MKHost *copy = [[[self class] allocWithZone: zone] init];
  copy.name = [[self.name copyWithZone:zone] autorelease];
  copy.address = [[self.address copyWithZone:zone] autorelease];
  copy.pin = [[self.pin copyWithZone:zone] autorelease];
  copy.connectionClass = [[self.connectionClass copyWithZone:zone] autorelease];
  
  return copy;
}


@end
