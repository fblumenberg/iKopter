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


#import "IKDebugData.h"

@implementation IKDebugData

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize address;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)dataWithData:(NSData *)data forAddress:(IKMkAddress) theAddress {
  return [[[IKDebugData alloc] initWithData:data forAddress: theAddress] autorelease];
}

- (id)initWithData:(NSData*)data forAddress:(IKMkAddress) theAddress {
  self = [super init];
  if (self != nil) {
    address = theAddress;
    memcpy(&_data,[data bytes],sizeof(_data));
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSNumber*) analogValueAtIndex:(NSUInteger)index {
  if( index > kMaxDebugDataAnalog ) {
    NSLog(@"index %u out of bounds (%u) of %@", index, self);
    [NSException raise:NSRangeException format:@"analogValueAtIndex: Index out of bounds"];
  }
  return [NSNumber numberWithShort:_data.Analog[index]];
}

- (BOOL) digitalValueAtIndex:(NSUInteger)index {
  if( index > kMaxDebugDataDigital ) {
    NSLog(@"index %u out of bounds (%u) of %@", index, self);
    [NSException raise:NSRangeException format:@"digitalValueAtIndex: Index out of bounds"];
  }
  return _data.Digital[index];
}

@end
