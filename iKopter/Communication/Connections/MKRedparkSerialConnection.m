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


#import "RscMgr.h"
#import "MKRedparkSerialConnection.h"

static NSString *const MKSerialConnectionException = @"MKSerialConnectionException";

@interface MKRedparkSerialConnection ()

- (void)didDisconnect;
- (void)didConnect;

+ (RscMgr *)sharedRscMgr;

@end

@implementation MKRedparkSerialConnection

#pragma mark Properties

@synthesize delegate;
@synthesize rscMgr;
@synthesize mkData;
@synthesize protocol;


#pragma mark Initialization

+ (RscMgr *)sharedRscMgr {
  static dispatch_once_t once;
  static RscMgr *sharedRscMgr__ = nil;

  dispatch_once(&once, ^{
    sharedRscMgr__ = [[RscMgr alloc] init];
  });

  return sharedRscMgr__;
}


- (id)init {
  return [self initWithDelegate:nil];
}

- (id)initWithDelegate:(id <MKConnectionDelegate>)theDelegate; {
  self = [super init];
  if (self) {
    self.delegate = theDelegate;
    self.rscMgr = [MKRedparkSerialConnection sharedRscMgr];
    [self.rscMgr setDelegate:self];
  }
  return self;
}

- (void)dealloc {
  qltrace("dealloc");
  self.mkData = nil;
  self.rscMgr = nil;
  self.protocol = nil;
  [super dealloc];
}

#pragma mark -
#pragma mark MKInput


- (void)didDisconnect {
  if ([delegate respondsToSelector:@selector(didDisconnect)]) {
    [delegate didDisconnect];
  }
}

- (void)didConnect {
  if ([delegate respondsToSelector:@selector(didConnectTo:)]) {
    [delegate didConnectTo:self.protocol];
  }
}


//
//void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void))
//{
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
//                 dispatch_get_main_queue(), block);
//}
//

- (void)openPort {

  qltrace(@"Try to connect to %@", self.protocol);


  [self.rscMgr setBaud:57600];
  [self.rscMgr setDataSize:SERIAL_DATABITS_8];
  [self.rscMgr setStopBits:STOPBITS_1];
  [self.rscMgr setParity:SERIAL_PARITY_NONE];

  [self.rscMgr open];

  self.mkData = [NSMutableData dataWithCapacity:512];

  qltrace(@"Did connect to %@", self.protocol);
  [self performSelector:@selector(didConnect) withObject:self afterDelay:0.1];
}

- (BOOL)connectTo:(MKHost *)hostOrDevice error:(NSError **)err; {
  if (delegate == nil) {
    [NSException raise:MKSerialConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }

  opened = YES;

  [self performSelector:@selector(openPort) withObject:self afterDelay:0.0];

  return YES;
}

- (BOOL)isConnected; {
  return opened;
}

- (void)disconnect; {
  if ([self isConnected]) {
    qlinfo(@"Try to disconnect from %@", [self protocol]);

    opened = NO;
  }

  [self didDisconnect];
}

- (void)writeMkData:(NSData *)data; {
  if ([self isConnected]) {
    [self.rscMgr write:(UInt8 *) [data bytes] Length:[data length]];
  }
}

#pragma mark - RscMgrDelegate 

// Redpark Serial Cable has been connected and/or application moved to foreground.
// protocol is the string which matched from the protocol list passed to initWithProtocol:
- (void)cableConnected:(NSString *)aProtocol {
  self.protocol = aProtocol;
//  cableIsConnected=YES;
}

// Redpark Serial Cable was disconnected and/or application moved to background
- (void)cableDisconnected {
  self.protocol = nil;
//  cableIsConnected=NO;
}

// serial port status has changed
// user can call getModemStatus or getPortStatus to get current state
- (void)portStatusChanged {

}

// bytes are available to be read (user calls read:)
- (void)readBytesAvailable:(UInt32)length {

  int bytesRead = [rscMgr read:(rxBuff) Length:length];

  NSData *data = [NSData dataWithBytes:rxBuff length:bytesRead];
  if ([data length] > 0) {

    /*
    * The new data, which may only be partial, gets appended to the previously
    * collected buffer in self.mkData.
    * Then a line delimiter is searched, and any complete lines are passed
    * to the delegate, and removed from the local buffer in self.mkData.
    * We repeat this search for lines until no more are found.
    */

    [self.mkData appendData:data];

    Boolean again;
    do {
      again = false;

      const char *haystackBytes = [self.mkData bytes];
      static char needle = '\r';

      for (int i = 0; i < [self.mkData length]; i++) {
        if (haystackBytes[i] == needle) { // check for line delimiter

          // extract the line
          NSRange r = {0, i + 1};
          NSData *cmdData = [self.mkData subdataWithRange:r];

          // remove the line from the receive buffer
          [self.mkData replaceBytesInRange:r withBytes:NULL length:0];

          if ([delegate respondsToSelector:@selector(didReadMkData:)]) {
            [delegate didReadMkData:cmdData];
          }
          again = true; // see if there are more lines to process
          break;
        }
      }
    } while (again);

  }

}

@end
