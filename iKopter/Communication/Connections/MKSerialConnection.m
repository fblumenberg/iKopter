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


#import "MKSerialConnection.h"
#import "AMSerialPort.h"
#import "AMSerialPortAdditions.h"

static NSString * const MKSerialConnectionException = @"MKSerialConnectionException";

@interface MKSerialConnection()

-(void)didDisconnect;
-(void)didConnect;

@end

@implementation MKSerialConnection

#pragma mark Properties

@synthesize delegate;
@synthesize port;
@synthesize mkData;


#pragma mark Initialization

- (id) init {
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id<MKConnectionDelegate>)theDelegate;
{
  if (self == [super init]) {
    self.delegate = theDelegate;
  }
  return self;
}

- (void) dealloc {
  qltrace("dealloc");
  self.mkData=nil;
  self.port=nil;
  [super dealloc];
}

#pragma mark -
#pragma mark MKInput


-(void)didDisconnect {
  if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
    [delegate didDisconnect];
  }
}

-(void)didConnect {
  if ( [delegate respondsToSelector:@selector(didConnectTo:)] ) {
    [delegate didConnectTo:[self.port bsdPath]];
  }
}


//
//void RunBlockAfterDelay(NSTimeInterval delay, void (^block)(void))
//{
//  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC*delay),
//                 dispatch_get_main_queue(), block);
//}
//

- (void) openPort{
  
  qltrace(@"Try to connect to %@", [self.port bsdPath]);
  
  if ([[self.port bsdPath]length]==0) {
    if ( [delegate respondsToSelector:@selector(willDisconnectWithError:)] ) {
      [delegate willDisconnectWithError:[NSError errorWithDomain:AMSerialErrorDomain code:-2 userInfo:nil]];
    }
    return;
  }
  
  if([self.port open]){
    
    [self.port setSpeed:57600];
    [self.port setDataBits:8];
    [self.port setStopBits:kAMSerialStopBitsOne];
    [self.port setEchoEnabled:NO];
    if( ![self.port commitChanges] ){
      if ( [delegate respondsToSelector:@selector(willDisconnectWithError:)] ) {
        [delegate willDisconnectWithError:[NSError errorWithDomain:AMSerialErrorDomain code:-1 userInfo:nil]];
      }
      return;
    }
    
    self.mkData=[NSMutableData dataWithCapacity:512];
    
    qltrace(@"Did connect to %@", [self.port bsdPath]);
    [self performSelector:@selector(didConnect) withObject:self afterDelay:0.1];
    [self.port performSelector:@selector(readDataInBackground) withObject:self afterDelay:0.1];
  }
  else {
    qlerror(@"Could not open %@", [self.port bsdPath]);
    
    [self performSelector:@selector(didDisconnect) withObject:self afterDelay:0.5];
  }
}

- (BOOL) connectTo:(MKHost *)hostOrDevice error:(NSError **)err;
{
  if (delegate == nil) {
    [NSException raise:MKSerialConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }
  
  if([self.port isOpen])
    [self.port close];
  
  self.port=[[[AMSerialPort alloc] init:hostOrDevice.address withName:hostOrDevice.address type:(NSString*)CFSTR(kIOSerialBSDRS232Type)] autorelease];
  [self.port setDelegate:self];
  
  [self performSelector:@selector(openPort) withObject:self afterDelay:0.0];
  
  return YES;
}

- (BOOL) isConnected;
{
  return [self.port isOpen];
}

- (void) disconnect;
{
  qltrace(@"Try to disconnect from %@", [self.port bsdPath]);
  if([self.port isOpen]){
    [self.port close];
    self.port=nil;
    if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
      [delegate didDisconnect];
    }
  }
}

- (void) writeMkData:(NSData *)data;
{
  if([self.port isOpen]){
//    [self.port writeDataInBackground:data];
    [self.port writeData:data error:NULL];
  }
}

#pragma mark -
#pragma mark AMSerialDelegate

- (void)serialPortReadData:(NSDictionary *)dataDictionary
{
	// this method is called if data arrives 
	// @"data" is the actual data, @"serialPort" is the sending port
	AMSerialPort *sendPort = [dataDictionary objectForKey:@"serialPort"];
  
	NSData *data = [dataDictionary objectForKey:@"data"];
	if ([data length] > 0) {
    
    /*
     * The new data, which may only be partial, gets appended to the previously
     * collected buffer in self.mkData.
     * Then a line delimiter is searched, and any complete lines are passed
     * to the delegate, and removed from the local buffer in self.mkData.
     */
    
    [self.mkData appendData:data];
    
    Boolean again;
    do {
      again = false;

      const char* haystackBytes = [self.mkData bytes];
      static char needle='\r';
      
      for (int i=0; i < [self.mkData length]; i++) {
        if( haystackBytes[i]==needle ) { // check for line delimiter
          
          // extract the line
          NSRange r={0,i+1};
          NSData* cmdData=[self.mkData subdataWithRange:r];
          
          // remove the line from the receive buffer
          [self.mkData replaceBytesInRange:r withBytes:NULL length:0];
          
          if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
            [delegate didReadMkData:cmdData];
          }
          again = true; // see if there are more lines to process
          break;
        }
      }
    } while (again);
    
		[sendPort readDataInBackground];
	} 
  else { 
    
    // port closed
    NSLog(@"port closed\r");
    
    self.port=nil;
    if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
      [delegate didDisconnect];
    }
	}
}

- (void)serialPortWriteProgress:(NSDictionary *)dataDictionary {
  
}

@end
