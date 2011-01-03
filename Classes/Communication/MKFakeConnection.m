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


#import "MKFakeConnection.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "NSData+MKPayloadEncode.h"

#import "MKDataConstants.h"

static NSString * const MKDummyConnectionException = @"MKDummyConnectionException";

@interface MKFakeConnection (Private)
 
- (void) doConnect;
- (void) doDisconnect;
- (void) doResponseMkData:(NSData*)data;

@end

@implementation MKFakeConnection

#pragma mark Properties

@synthesize delegate;

#pragma mark Initialization

- (id) init {
  return [self initWithDelegate:nil];
}

- (id) initWithDelegate:(id)theDelegate;
{
  if (self = [super init]) {
    self.delegate = theDelegate;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AllSettings" 
                                                     ofType:@"plist"];
    
    settings = [[NSMutableArray arrayWithContentsOfFile:path] retain];
    
    activeSetting = 3;
  }
  return self;
}

- (void) dealloc {
  [settings release];
  [super dealloc];
}

#pragma mark -
#pragma mark MKInput

- (BOOL) connectTo:(NSString *)hostOrDevice error:(NSError **)err;
{
  if (delegate == nil) {
    [NSException raise:MKDummyConnectionException
                format:@"Attempting to connect without a delegate. Set a delegate first."];
  }

  NSArray * hostItems = [hostOrDevice componentsSeparatedByString:@":"];
  if ( [hostItems count] != 2 ) {
    [NSException raise:MKDummyConnectionException
                format:@"Attempting to connect without a port. Set a port first."];

  }

  int port = [[hostItems objectAtIndex:1] intValue];
  NSString * host = [hostItems objectAtIndex:0];

  DLog(@"Try to connect to %@ on port %d", host, port);

  [self performSelector:@selector(doConnect) withObject:nil afterDelay:0.5];
  return YES;
}

- (BOOL) isConnected;
{
  return isConnected;
}

- (void) disconnect;
{
  [self performSelector:@selector(doDisconnect) withObject:nil afterDelay:0.1];
}

- (void) writeMkData:(NSData *)data;
{
  [self performSelector:@selector(doResponseMkData:) withObject:[data retain] afterDelay:0.1];
}

#pragma mark -


- (NSData*) versionResponse;
{
  VersionInfo v;
  v.SWMajor = 0;
  v.SWMinor = 78;
  v.ProtoMajor = 3; 
  v.ProtoMinor = 1;
  v.SWPatch = 3;
  NSData * payload = [NSData dataWithBytes:(void*)&v length:sizeof(v)];
  return payload;
}

- (NSData*) debugResponse;
{
  DebugOut d;
  NSData * payload = [NSData dataWithBytes:(void*)&d length:sizeof(d)];
  return payload;
}

- (NSData*) channelResponse;
{
  int16_t data[26];
  
  for (int i=0; i<26; i++) {
    data[i]=random()%250;
  }
  
  NSData * payload = [NSData dataWithBytes:(void*)&data length:sizeof(data)];
  return payload;
}



- (NSData*) menuResponse:(NSData*)payload {

  const char * bytes = [payload bytes];
  
  uint8_t key=(uint8_t)bytes[0];
//  uint8_t interval=(uint8_t)bytes[1];
  
  if (key==0xFD) {
    menuPage++;
  } else if (key==0xFE) {
    menuPage--;
  }
  
  menuPage %= 16;
  menuCounter = 1;
  
  NSString* screen=[NSString stringWithFormat:@"Page %02d (%d)------->>12345678901234567890abcdefghijklmnopqrst++++++++++++++++++>>",
                    menuPage,menuCounter];

  NSData * newPayload = [screen dataUsingEncoding:NSASCIIStringEncoding];

  [self performSelector:@selector(resendMenuResponse) withObject:nil afterDelay:0.5];
 
  return newPayload;
}

- (void) resendMenuResponse {

  NSString* screen=[NSString stringWithFormat:@"Page %02d (%d)-------<<12345678901234567890abcdefghijklmnopqrst++++++++++++++++++<<",
                    menuPage,menuCounter];
  
  NSData * newPayload = [screen dataUsingEncoding:NSASCIIStringEncoding];
  
  NSData * rspData = [newPayload dataWithCommand:MKCommandLcdResponse forAddress:MKAddressFC];
  
  if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
    [delegate didReadMkData:rspData];
  } 
  
  if ( (++menuCounter)<2 ) {
    [self performSelector:@selector(resendMenuResponse) withObject:nil afterDelay:0.5];
  }
} 



- (NSData*) changeSettingsResponse:(NSData*)payload {
  
  const char * bytes = [payload bytes];
  
  uint8_t index=(uint8_t)bytes[0];
  
  activeSetting = index;
  
  NSData * newPayload = [NSData dataWithBytes:(void*)&index length:sizeof(index)];
  return newPayload;
  
}

- (NSData*) writeSettingResponse:(NSData*)payload {

  NSDictionary* d = [payload decodeReadSettingResponse];
  
  NSNumber* theIndex = [d objectForKey:kMKDataKeyIndex]; 
  uint8_t index = [theIndex unsignedCharValue];
  
  [settings replaceObjectAtIndex:index-1 withObject:d];
  
  NSData * newPayload = [NSData dataWithBytes:(void*)&index length:sizeof(index)];
  return newPayload;
}

- (NSData*) readSettingResponse:(NSData*)payload {
  
  const char * bytes = [payload bytes];
  
  uint8_t index=(uint8_t)bytes[0];
  
  if (index==0xFF) {
    index=activeSetting;
  }
  
  index--;
  
  NSDictionary* d = [settings objectAtIndex:index];
  
  DLog(@"%@",d);
    
  NSData * newPayload = [NSData payloadForWriteSettingRequest:d];
  
  return newPayload;
}

#pragma mark -

- (void) doConnect {

  isConnected=YES;
  if ( [delegate respondsToSelector:@selector(didConnectTo:)] ) {
    [delegate didConnectTo:@"Dummy"];
  }

  NSData * data = [NSData dataWithCommand:MKCommandVersionRequest
                               forAddress:MKAddressAll
                         payloadWithBytes:NULL
                                   length:0];

  [self writeMkData:data];
}


- (void) doDisconnect {
  isConnected=NO;
  if ( [delegate respondsToSelector:@selector(didDisconnect)] ) {
    [delegate didDisconnect];
  }
}

- (void) doResponseMkData:(NSData*)data {

  if ([data isCrcOk]) {

    NSData * payload = [data payload];
//    MKAddress address = [data address];

    NSData * rspPayload;
    MKCommandId rspCommand;  
    
    DLog(@"Need responde for command %c",[data command]);

    switch ([data command]) {
/*
      case MKCommandLcdMenuResponse:
        n = MKLcdMenuNotification;
        d = [payload decodeLcdMenuResponse];
        break;
      case MKCommandLcdResponse:
        n = MKLcdNotification;
        d = [payload decodeLcdResponse];
        break;
      case MKCommandDebugLabelResponse:
        n = MKDebugLabelNotification;
        d = [payload decodeAnalogLabelResponse];
        break;
*/
      case MKCommandLcdRequest:
        rspPayload = [self menuResponse:payload];
        rspCommand = MKCommandLcdResponse;
        break;
      case MKCommandDebugValueRequest:
        rspPayload = [self debugResponse];
        rspCommand = MKCommandDebugValueResponse;
        break;
      case MKCommandChannelsValueRequest:
        rspPayload = [self channelResponse];
        rspCommand = MKCommandChannelsValueResponse;
        break;
      case MKCommandVersionRequest:
        rspPayload = [self versionResponse];
        rspCommand = MKCommandVersionResponse;
        break;
      case MKCommandChangeSettingsRequest:
        rspPayload = [self changeSettingsResponse:payload];
        rspCommand = MKCommandChangeSettingsResponse;
        break;
      case MKCommandReadSettingsRequest:
        rspPayload = [self readSettingResponse:payload];
        rspCommand = MKCommandReadSettingsResponse;
        break;
      case MKCommandWriteSettingsRequest:
        rspPayload = [self writeSettingResponse:payload];
        rspCommand = MKCommandWriteSettingsResponse;
        break;
      case MKCommandEngineTestRequest:
        DLog(@"Engine Test %@",payload);
        [data release];
        return;
      default:
        ALog(@"Unknown command %c",[data command]);
        [data release];
        return;
    }

    NSData * rspData = [rspPayload dataWithCommand:rspCommand forAddress:MKAddressFC];
    
    if ( [delegate respondsToSelector:@selector(didReadMkData:)] ) {
      [delegate didReadMkData:rspData];
    } 
  
  }  

  [data release];
}

@end
