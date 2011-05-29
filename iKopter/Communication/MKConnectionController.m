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

#import "SynthesizeSingleton.h"
#import "MKConnectionController.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "MKDataConstants.h"
#import "MKHost.h"
#import "MKIpConnection.h"

#import "IKDeviceVersion.h"
#import "IKParamSet.h"

// ///////////////////////////////////////////////////////////////////////////////
NSString * const MKFoundDeviceNotification = @"MKFoundDeviceNotification";
NSString * const MKDeviceChangedNotification = @"MKDeviceChangedNotification";
NSString * const MKConnectedNotification = @"MKConnectedNotification";
NSString * const MKDisconnectedNotification = @"MKDisconnectedNotification";
NSString * const MKDisconnectErrorNotification = @"MKDisconnectErrorNotification";

NSString * const MKVersionNotification = @"MKVersionNotification";
NSString * const MKDebugDataNotification = @"MKDebugDataNotification";
NSString * const MKDebugLabelNotification = @"MKDebugLabelNotification";
NSString * const MKLcdMenuNotification = @"MKLcdMenuNotification";
NSString * const MKLcdNotification = @"MKLcdNotification";
NSString * const MKReadSettingNotification = @"MKReadSettingNotification";
NSString * const MKWriteSettingNotification = @"MKWriteSettingNotification";
NSString * const MKChangeSettingNotification = @"MKChangeSettingNotification";

NSString * const MKChannelValuesNotification = @"MKChannelValuesNotification";

NSString * const MKReadMixerNotification = @"MKReadMixerNotification";
NSString * const MKWriteMixerNotification = @"MKWriteMixerNotification";

NSString * const MKOsdNotification = @"MKOsdNotification";
NSString * const MKData3DNotification = @"MKData3DNotification";


// ///////////////////////////////////////////////////////////////////////////////

#define kConnectionStateIdle 0
#define kConnectionStateWaitNC 1
#define kConnectionStateWaitFC 2
#define kConnectionStateWaitNC_2 3
#define kConnectionStateWaitMK3MAG 4
#define kConnectionDeviceChecked 5

// ///////////////////////////////////////////////////////////////////////////////
@interface MKConnectionController (private)
- (void)handleMkResponse:(MKCommandId) command 
             withPayload:(NSData*)payload 
              forAddress:(IKMkAddress)address;

- (void)handleMkResponseForDeviceCheck:(MKCommandId) command 
                           withPayload:(NSData*)payload 
                            forAddress:(IKMkAddress)address;

- (void) clearVersions;
- (void) setVersion:(IKDeviceVersion*)v;
- (void) requestDeviceVersion;
- (void) nextConnectAction;

@end

// ///////////////////////////////////////////////////////////////////////////////

@implementation MKConnectionController

// -------------------------------------------------------------------------------

@synthesize hostOrDevice=_hostOrDevice;
@synthesize inputController=_inputController;

@synthesize primaryDevice;
@synthesize currentDevice;



SYNTHESIZE_SINGLETON_FOR_CLASS(MKConnectionController);

// -------------------------------------------------------------------------------

- (void) dealloc {
  
  self.hostOrDevice=nil;
  self.inputController=nil;
  [self clearVersions];
  [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) start:(MKHost*)host {
  
  if (![self.inputController isConnected]) {
    
    Class nsclass = NSClassFromString(host.connectionClass);
    if (!nsclass) {
      nsclass = [MKIpConnection class];
    }
    
    self.inputController = [[nsclass alloc] initWithDelegate:self];
    
    self.hostOrDevice = host;  

    didPostConnectNotification = NO;
    
    currentDevice=kIKMkAddressAll;
    primaryDevice=kIKMkAddressAll;
    connectionState=kConnectionStateIdle;
    
    NSError * err = nil;
    if (![self.inputController connectTo:self.hostOrDevice error:&err]) {
      NSLog(@"Error: %@", err);
      [self performSelector:@selector(stop) withObject:self afterDelay:0.1];
    }
  }
}

- (void) stop {
  if ([self.inputController isConnected]) {
    qltrace(@"disconnect");
    [self.inputController disconnect];
  }
}

- (BOOL) isRunning;
{
  return [self.inputController isConnected];
}

- (void) sendRequest:(NSData *)data;
{
  qltrace(@"%@",data);
  qltrace(@"%@", [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease]);
  
  [self.inputController writeMkData:data];
}

- (IKDeviceVersion *) versionForAddress:(IKMkAddress)theAddress;
{
  if (theAddress <= kIKMkAddressAll || theAddress > kIKMkAddressMK3MAg)
    return nil;
  return versions[theAddress];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) hasNaviCtrl {
  return versions[kIKMkAddressNC]!=nil;
}

- (BOOL) hasFlightCtrl {
  return versions[kIKMkAddressFC]!=nil;
}

- (BOOL) hasMK3MAG {
  return versions[kIKMkAddressMK3MAg]!=nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateNaviCtrl {
  
  //  if(primaryDevice!=kIKMkAddressAll && ![self hasNaviCtrl])
  //    return;
  
  qltrace("Activate the NaviControl");
  uint8_t bytes[6];
  bytes[0] = 0x1B;
  bytes[1] = 0x1B;
  bytes[2] = 0x55;
  bytes[3] = 0xAA;
  bytes[4] = 0x00;
  bytes[5] = '\r';
  
  NSData * data = [NSData dataWithBytes:&bytes length:6];
  [self sendRequest:data];
  
  //currentDevice=kIKMkAddressNC;
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:0.5];
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:1.0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateFlightCtrl {
  
  //  if(![self hasNaviCtrl])
  //    return;
  
  qltrace("Activate the FlightCtrl");
  
  uint8_t byte=0;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:kIKMkAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  //currentDevice=kIKMkAddressFC;
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:0.5];
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:1.0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateMK3MAG {
  
  //  if(![self hasNaviCtrl])
  //    return;
  
  qltrace("Activate the MK3MAG");
  
  uint8_t byte=1;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:kIKMkAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  //currentDevice=kIKMkAddressMK3MAg;
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:0.5];
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:0.7];
  [self performSelector:@selector(requestDeviceVersion) withObject:self afterDelay:1.0];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateMKGPS {
  
  if(![self hasNaviCtrl])
    return;
  
  uint8_t byte=3;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:kIKMkAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  currentDevice=kIKMkAddressMKGPS;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestSettingForIndex:(NSInteger)theIndex {
  uint8_t index = theIndex;
  
  NSData * data = [NSData dataWithCommand:MKCommandReadSettingsRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:&index
                                   length:1];
  
  [self sendRequest:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setActiveSetting:(NSUInteger)newActiveSetting
{
  uint8_t index = newActiveSetting;
  NSData * data = [NSData dataWithCommand:MKCommandChangeSettingsRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:&index
                                   length:1];
  
  [self sendRequest:data];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) saveSetting:(IKParamSet*)setting {
  
  NSData * payload = [setting data];
  NSData * data = [payload dataWithCommand:MKCommandWriteSettingsRequest
                                forAddress:kIKMkAddressFC];
  [self sendRequest:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestData3DForInterval:(NSUInteger)interval {
  uint8_t iv = interval;
  NSData * data = [NSData dataWithCommand:MKCommandData3DRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:&iv
                                   length:1];
  
  [self sendRequest:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestDebugValueForInterval:(NSUInteger)interval {
  uint8_t iv = interval;
  NSData * data = [NSData dataWithCommand:MKCommandDebugValueRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:&iv
                                   length:1];
  
  [self sendRequest:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) requestOsdDataForInterval:(NSUInteger)interval {
  uint8_t iv = interval;
  NSData * data = [NSData dataWithCommand:MKCommandOsdRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:&iv
                                   length:1];
  
  [self sendRequest:data];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MKInputDelegate


- (void) didConnectTo:(NSString *)hostOrDevice {
  [self nextConnectAction];
}

- (void) willDisconnectWithError:(NSError *)err {
  NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:err, @"error", nil];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  
  [nc postNotificationName:MKDisconnectErrorNotification object:self userInfo:d];
}

- (void) didDisconnect {
  [self clearVersions];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc postNotificationName:MKDisconnectedNotification object:self userInfo:nil];
  
}

- (void) didReadMkData:(NSData *)data {
  
  NSData * strData = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
  qltrace(@">>%@<<", [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease]);
  
  if ([strData isCrcOk]) {
    //    qltrace(@"Data length %d",[strData length]);
    
    NSData * payload = [strData payload];
    IKMkAddress address = [strData address];
//    if (address!=currentDevice) {
//      currentDevice=address;
//      qltrace(@"Device changed to %d, send notification",currentDevice);
//      [[NSNotificationCenter defaultCenter] postNotificationName:MKDeviceChangedNotification 
//                                                          object:self 
//                                                        userInfo:nil];
//    }
    
    if (connectionState==kConnectionDeviceChecked)
      [self handleMkResponse:[data command] withPayload:payload forAddress:address];
    else
      [self handleMkResponseForDeviceCheck:[data command] withPayload:payload forAddress:address];
    
  } else {
    qltrace(@"%@", [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease]);
  }
}

@end

//////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
@implementation MKConnectionController (private)

- (void) clearVersions {
  
  [versions[kIKMkAddressFC] release];
  [versions[kIKMkAddressNC] release];
  [versions[kIKMkAddressMK3MAg] release];
  
  versions[kIKMkAddressFC]=nil;
  versions[kIKMkAddressNC]=nil;
  versions[kIKMkAddressMK3MAg]=nil;
}

- (void) setVersion:(IKDeviceVersion*)v {
  
  if (v.address > kIKMkAddressAll || v.address <= kIKMkAddressMK3MAg){
    [versions[v.address] release];  
    versions[v.address]=[v retain];
  }
}

- (void) requestDeviceVersion {
  NSData * data = [NSData dataWithCommand:MKCommandVersionRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:NULL
                                   length:0];
  
  [self sendRequest:data];
}


-(void) checkForDeviceChange:(IKMkAddress)address {
  
  if (address!=currentDevice) {
      currentDevice=address;
        qltrace(@"Device changed to %d, send notification",currentDevice);
       [[NSNotificationCenter defaultCenter] postNotificationName:MKDeviceChangedNotification 
                                                           object:self 
                                                         userInfo:nil];
  }
}
                             

- (void) nextConnectAction {
  qltrace(@"Next connection action, current state is %d",connectionState);
  switch (connectionState) {
    case kConnectionStateIdle:
      retryCount=0;
      connectionState=kConnectionStateWaitNC;
      [self activateNaviCtrl];
      [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:6.0];
      break;
    case kConnectionStateWaitNC:
      connectionState=kConnectionStateWaitFC;
      [self activateFlightCtrl];
      [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
      break;
    case kConnectionStateWaitFC:
      connectionState=kConnectionStateWaitNC_2;
      [self activateNaviCtrl];
      [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
      break;
    case kConnectionStateWaitNC_2:
      connectionState=kConnectionStateWaitMK3MAG;
      [self activateMK3MAG];
      [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
      break;
    case kConnectionStateWaitMK3MAG:
      connectionState=kConnectionDeviceChecked;
      NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
      [nc postNotificationName:MKConnectedNotification object:self userInfo:nil];
      break;
    default:
      break;
  }
  qltrace(@"Next connection action done, current state is %d",connectionState);
}

- (void) connectionTimeout {
  qltrace(@"connection timeout, retry count %d",retryCount);
  if (++retryCount>3 ){
    
    if(connectionState==kConnectionStateWaitNC) {
      [self stop];
    }
    else{
      connectionState=kConnectionDeviceChecked;
      NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
      [nc postNotificationName:MKConnectedNotification object:self userInfo:nil];
    }
  }
  else {
    switch (connectionState) {
      case kConnectionStateWaitNC:
        connectionState=kConnectionStateWaitNC;
        [self activateNaviCtrl];
        [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:6.0];
        break;
      case kConnectionStateWaitFC:
        connectionState=kConnectionStateWaitFC;
        [self activateFlightCtrl];
        [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
        break;
      case kConnectionStateWaitNC_2:
        connectionState=kConnectionStateWaitNC_2;
        [self activateNaviCtrl];
        [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
        break;
      case kConnectionStateWaitMK3MAG:
        connectionState=kConnectionStateWaitMK3MAG;
        [self activateMK3MAG];
        [self performSelector:@selector(connectionTimeout) withObject:self afterDelay:2.0];
        break;
    }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)handleMkResponse:(MKCommandId) command withPayload:(NSData*)payload forAddress:(IKMkAddress)address {
  NSDictionary * d = nil;
  NSString * n = nil;
  
  switch (command) {
//    case MKCommandLcdMenuResponse:
//      n = MKLcdMenuNotification;
//      d = [payload decodeLcdMenuResponseForAddress:address];
//      break;
    case MKCommandLcdResponse:
      n = MKLcdNotification;
      d = [payload decodeLcdResponseForAddress:address];
      break;
    case MKCommandDebugLabelResponse:
      n = MKDebugLabelNotification;
      d = [payload decodeAnalogLabelResponseForAddress:address];
      break;
    case MKCommandDebugValueResponse:
      n = MKDebugDataNotification;
      d = [payload decodeDebugDataResponseForAddress:address];
      break;
    case MKCommandChannelsValueResponse:
      n = MKChannelValuesNotification;
      d = [payload decodeChannelsDataResponse];
      break;
    case MKCommandReadSettingsResponse:
      n = MKReadSettingNotification;
      d = [payload decodeReadSettingResponse];
      break;
    case MKCommandWriteSettingsResponse:
      n = MKWriteSettingNotification;
      d = [payload decodeWriteSettingResponse];
      break;
    case MKCommandMixerReadResponse:
      n = MKReadMixerNotification;
      d = [payload decodeMixerReadResponse];
      break;
    case MKCommandMixerWriteResponse:
      n = MKWriteMixerNotification;
      d = [payload decodeMixerWriteResponse];
      break;
    case MKCommandChangeSettingsResponse:
      n = MKChangeSettingNotification;
      d = [payload decodeChangeSettingResponse];
      break;
    case MKCommandOsdResponse:
      n = MKOsdNotification;
      d = [payload decodeOsdResponse];
      break;
    case MKCommandData3DResponse:
      n = MKData3DNotification;
      d = [payload decodeData3DResponse];
      break;
    case MKCommandVersionResponse:
      n = MKVersionNotification;
      d = [payload decodeVersionResponseForAddress:address];
      [self checkForDeviceChange:address];
      break;
    default:
      break;
  }
  
  if (d)
    qltrace(@"(%d) %@", [d retainCount],d );
  
  [[NSNotificationCenter defaultCenter] postNotificationName:n object:self userInfo:d];
}

- (void)handleMkResponseForDeviceCheck:(MKCommandId) command 
                           withPayload:(NSData*)payload 
                            forAddress:(IKMkAddress)address {
  
  switch (command) {
      
    case MKCommandVersionResponse:
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
      [self setVersion:[IKDeviceVersion versionWithData:payload forAddress:(IKMkAddress)address]];
      qltrace(@"Got a device version %@",[self versionForAddress:address]);
      
      NSDictionary* d=[NSDictionary dictionaryWithObject:[self versionForAddress:address] forKey:kIKDataKeyVersion];
      [[NSNotificationCenter defaultCenter] postNotificationName:MKFoundDeviceNotification 
                                                          object:self 
                                                        userInfo:d];
      
      [self checkForDeviceChange:address];
      [self nextConnectAction];
      break;
    default:
      qltrace(@"Ignore the command '%c' from address %d",command,address);
      break;
  }
}

@end

