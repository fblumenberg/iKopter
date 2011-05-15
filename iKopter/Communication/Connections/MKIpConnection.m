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


#import "MKIpConnection.h"
#import "AsyncSocket.h"

static NSString * const MKIpConnectionException = @"MKIpConnectionException";

@implementation MKIpConnection

#pragma mark Properties

@synthesize delegate;

#pragma mark Initialization

- (id) init {
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id<MKConnectionDelegate>)theDelegate;
{
  if (self == [super init]) {
    
    asyncSocket = [[AsyncSocket alloc] init];
    [asyncSocket setDelegate:self];   
                   
    self.delegate = theDelegate;
  }
  return self;
}

- (void) dealloc {
  qltrace("dealloc");
  [asyncSocket release];
  [super dealloc];
}

#pragma mark -
#pragma mark MKInput

- (BOOL) connectTo:(MKHost*)hostOrDevice error:(NSError **)err;
{
  if (delegate == nil) {
    [NSException raise:MKIpConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }

  NSArray * hostItems = [hostOrDevice.address componentsSeparatedByString:@":"];
  if ( [hostItems count] != 2 ) {
    qlcritical(@"Attempting to connect without a port. Set a port first.");
    return NO;
  }

  int port = [[hostItems objectAtIndex:1] intValue];
  NSString * host = [hostItems objectAtIndex:0];

  qltrace(@"Try to connect to %@ on port %d", host, port);
  return [asyncSocket connectToHost:host onPort:port withTimeout:30 error:err];
}

- (BOOL) isConnected;
{
  return [asyncSocket isConnected];
}

- (void) disconnect;
{
  qltrace(@"Try to disconnect from %@ on port %d", [asyncSocket connectedHost], [asyncSocket connectedPort]);
  [asyncSocket disconnect];
}

- (void) writeMkData:(NSData *)data;
{
//  NSMutableData * newData = [data mutableCopy];
//
//  [newData appendBytes:"\n" length:1];

  [asyncSocket writeData:data withTimeout:-1 tag:0];
  
//  [newData release];
}

#pragma mark -
#pragma mark AsyncSocketDelegate

- (BOOL) onSocketWillConnect:(AsyncSocket *)sock {
  qltrace(@"About to connect to %@", [sock connectedHost]);
  return TRUE;
}

- (void) onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{
  qltrace(@"Did connect to %@ on port %d", host, port);

  if ( [delegate respondsToSelector:@selector(didConnectTo:)] ) {
    [delegate didConnectTo:host];
  }


  qltrace(@"Start reading the first data frame");
  [sock readDataToData:[AsyncSocket CRData] withTimeout:-1 tag:0];
}

- (void) onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag;
{
  if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
    [delegate didReadMkData:data];
  }
//  qltrace(@"Did read data %@",data);
//
//  qltrace(@"Start reading the next data frame");
  [sock readDataToData:[AsyncSocket CRData] withTimeout:-1 tag:0];
}

- (void) onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag;
{
  qltrace(@"Finished writing the next data frame");
}

- (void) onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err;
{
  qlerror(@"Disconnet with an error %@", err);
  if ( [delegate respondsToSelector:@selector(willDisconnectWithError:)] ) {
    [delegate willDisconnectWithError:err];
  }
}

- (void) onSocketDidDisconnect:(AsyncSocket *)sock;
{
  qltrace(@"Disconnect from %@ on port %d", [asyncSocket connectedHost], [asyncSocket connectedPort]);

  if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
    [delegate didDisconnect];
  }
}

@end
