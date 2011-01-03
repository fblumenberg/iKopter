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
#define    kPortKey             @"port"
#define    kConnectionClassKey  @"connectionClass"

@implementation MKHost

@synthesize name=_name;
@synthesize address=_address;
@synthesize port=_port;
@synthesize connectionClass=_connectionClass;

- (id) init
{
  self = [super init];
  if (self != nil) {
    self.name = NSLocalizedString(@"New host",@"Default host name");
  }
  return self;
}

- (void) dealloc
{
  self.name=nil;
  self.address=nil;
  self.connectionClass=nil;
  
  [super dealloc];
}

-(NSString*) description {
  return [NSString stringWithFormat:@"%@-%@:%d",self.name,self.address,self.port];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)encoder {
  [encoder encodeObject:_name forKey:kNameKey];
  [encoder encodeObject:_address forKey:kAddressKey];
  [encoder encodeInteger:_port forKey:kPortKey];
  [encoder encodeObject:_connectionClass forKey:kConnectionClassKey];
}
- (id)initWithCoder:(NSCoder *)decoder {
  if (self = [super init]) {
    self.name = [decoder decodeObjectForKey:kNameKey];
    self.address = [decoder decodeObjectForKey:kAddressKey];
    self.port = [decoder decodeIntegerForKey:kPortKey];
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
  copy.port = self.port;
  copy.connectionClass = [[self.connectionClass copyWithZone:zone] autorelease];
  
  return copy;
}


@end
