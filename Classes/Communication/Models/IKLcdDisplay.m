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


#import "IKLcdDisplay.h"


@implementation IKLcdDisplay

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize address;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)menuWithData:(NSData *)data forAddress:(IKMkAddress) theAddress {
  return [[[IKLcdDisplay alloc] initWithData:data forAddress: theAddress] autorelease];
}

- (id)initWithData:(NSData*)data forAddress:(IKMkAddress)theAddress {
  
  self = [super init];
  if (self != nil) {
    
    address = theAddress;
    const char * bytes = [data bytes];
    
    NSData * strData = [NSData dataWithBytesNoCopy:(char *)(bytes) length:[data length] freeWhenDone:NO];
    NSString * label = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
    
    displayText[0] = [[label substringWithRange:NSMakeRange( 0, 20)]retain];
    displayText[1] = [[label substringWithRange:NSMakeRange(20, 20)]retain];
    displayText[2] = [[label substringWithRange:NSMakeRange(40, 20)]retain];
    displayText[3] = [[label substringWithRange:NSMakeRange(60, 20)]retain];
  }
  
  return self;
}

- (void)dealloc{

  for(int i=0;i<4;i++)
    [displayText[i] release];
  
  [super dealloc];
}

- (NSString*)screenTextJoinedByString:(NSString *)separator {
  return [[NSArray arrayWithObjects:displayText count:4] componentsJoinedByString:separator];
}

@end
