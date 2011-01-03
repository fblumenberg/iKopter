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

#import "MKQmkIpConnection.h"


@implementation MKQmkIpConnection

- (void) writeMkData:(NSData *)data;
{
  NSMutableData * newData = [data mutableCopy];
 
  DLog(@"writeMkData, add \\n for QMK");

  [newData appendBytes:"\n" length:1];
  [super writeMkData:newData];
  [newData release];
}

#pragma mark -
#pragma mark AsyncSocketDelegate

- (void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{  
  [super onSocket:sock didConnectToHost:host port:port];
  NSString* bundelName=[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
  
  DLog(@"Sent QMK message");
  NSString* welcomeMsg = [NSString stringWithFormat:@"$:99:101:%@:0\r",bundelName];
  [self writeMkData:[welcomeMsg dataUsingEncoding:NSASCIIStringEncoding]];
  
  NSString* dataMsg = @"$:99:106:VDALBH:0\r";
  [self writeMkData:[dataMsg dataUsingEncoding:NSASCIIStringEncoding]];
  
}

- (void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
  NSData * mkData = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
  [super onSocket:sock didReadData:mkData withTag:tag];
}


@end
