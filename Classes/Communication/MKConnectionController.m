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

// ///////////////////////////////////////////////////////////////////////////////

@implementation MKConnectionController

// -------------------------------------------------------------------------------

//@synthesize hostOrDevice;
//@synthesize inputController;

@synthesize primaryDevice;
@synthesize currentDevice;

-(void) setCurrentDevice:(MKAddress)theAddress {
  
//  if(primaryDevice==MKAddressNC) {
    if(theAddress != currentDevice) {
      currentDevice=theAddress;
      
      if(currentDevice==MKAddressNC)
      {
        uint8_t bytes[5];
        bytes[0] = 0x1B;
        bytes[1] = 0x1B;
        bytes[2] = 0x55;
        bytes[3] = 0xAA;
        bytes[4] = 0x00;
        bytes[5] = '\r';
        
        NSData * data = [NSData dataWithBytes:&bytes length:6];
        
        [self sendRequest:data];
        
      }
      else {
        uint8_t byte=0;

        switch (currentDevice) {
          case MKAddressFC:
            byte=0;
            break;
          case MKAddressMK3MAg:
            byte=1;
            break;
        }

        NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                                     forAddress:MKAddressNC
                                 payloadForByte:byte];
        
        [self sendRequest:data];
      }
    }
 // }
}


SYNTHESIZE_SINGLETON_FOR_CLASS(MKConnectionController);

// -------------------------------------------------------------------------------

- (void) dealloc {
  [hostOrDevice release];
  [inputController release];
  [shortVersions[MKAddressFC] release];
  [shortVersions[MKAddressNC] release];
  [shortVersions[MKAddressMK3MAg] release];
  [longVersions[MKAddressMK3MAg] release];
  [longVersions[MKAddressNC] release];
  [longVersions[MKAddressMK3MAg] release];
  [super dealloc];
}

// -------------------------------------------------------------------------------

- (void) start:(MKHost*)host {
  
  if (![inputController isConnected]) {
    
    Class nsclass = NSClassFromString(host.connectionClass);
    if (!nsclass) {
      nsclass = [MKIpConnection class];
    }
    
    [inputController release];
    inputController = [[nsclass alloc] initWithDelegate:self];

    [hostOrDevice release];
    hostOrDevice = [NSString stringWithFormat:@"%@:%d",host.address,host.port];
    [hostOrDevice retain];
    
    didPostConnectNotification = NO;
    
    currentDevice=MKAddressAll;
    primaryDevice=MKAddressAll;
    
    NSError * err = nil;
    if (![inputController connectTo:hostOrDevice error:&err]) {
      NSLog(@"Error: %@", err);
    }
  }
}

- (void) stop {
  if ([inputController isConnected]) {
    DLog(@"disconnect");
    [inputController disconnect];
  }
  
//  self.inputController=nil;

}

- (BOOL) isRunning;
{
  return [inputController isConnected];
}

- (void) sendRequest:(NSData *)data;
{
  DLog(@"%@",data);
  NSString * msg = [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
  DLog(@"%@", msg);

  [inputController writeMkData:data];
}

- (NSString *) shortVersionForAddress:(MKAddress)theAddress;
{
  if (theAddress <= MKAddressAll || theAddress > MKAddressMK3MAg)
    return nil;
  return shortVersions[theAddress];
}

- (NSString *) longVersionForAddress:(MKAddress)theAddress;
{
  if (theAddress <= MKAddressAll || theAddress > MKAddressMK3MAg)
    return nil;
  return longVersions[theAddress];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL) hasNaviCtrl {
  return primaryDevice==MKAddressNC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateNaviCtrl {
  
  if(primaryDevice!=MKAddressAll && ![self hasNaviCtrl])
    return;
    
  uint8_t bytes[5];
  bytes[0] = 0x1B;
  bytes[1] = 0x1B;
  bytes[2] = 0x55;
  bytes[3] = 0xAA;
  bytes[4] = 0x00;
  bytes[5] = '\r';
  
  NSData * data = [NSData dataWithBytes:&bytes length:6];
  [self sendRequest:data];
  
  currentDevice=MKAddressNC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateFlightCtrl {

  if(![self hasNaviCtrl])
    return;

  uint8_t byte=0;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:MKAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  currentDevice=MKAddressFC;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateMK3MAG {

  if(![self hasNaviCtrl])
    return;

  uint8_t byte=1;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:MKAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  currentDevice=MKAddressMK3MAg;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) activateMKGPS {

  if(![self hasNaviCtrl])
    return;

  uint8_t byte=3;
  NSData * data = [NSData dataWithCommand:MKCommandRedirectRequest
                               forAddress:MKAddressNC
                           payloadForByte:byte];
  
  [self sendRequest:data];
  currentDevice=MKAddressMKGPS;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MKInputDelegate


- (void) requestPrimaryDeviceVersion {
  NSData * data = [NSData dataWithCommand:MKCommandVersionRequest
                               forAddress:MKAddressAll
                         payloadWithBytes:NULL
                                   length:0];
  
  [self sendRequest:data];
}

- (void) didConnectTo:(NSString *)hostOrDevice {
  
  [self activateNaviCtrl];
  [self performSelector:@selector(requestPrimaryDeviceVersion) withObject:self afterDelay:0.1];
}

- (void) willDisconnectWithError:(NSError *)err {
  NSDictionary * d = [NSDictionary dictionaryWithObjectsAndKeys:err, @"error", nil];

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

  [nc postNotificationName:MKDisconnectErrorNotification object:self userInfo:d];
}

- (void) didDisconnect {
  NSDictionary * d = nil;

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

  [nc postNotificationName:MKDisconnectedNotification object:self userInfo:d];

}

- (void) setVersionsFrom:(NSDictionary *)d forAddress:(MKAddress)address  {
  if (address != MKAddressAll) {
    
    [shortVersions[address] release];
    shortVersions[address] = [[d objectForKey:kMKDataKeyVersion] retain];
    
    [longVersions[address] release];
    longVersions[address] = [[d objectForKey:kMKDataKeyVersionShort] retain];
  }
}

- (void) didReadMkData:(NSData *)data {
  
  NSData * strData = [data subdataWithRange:NSMakeRange(0, [data length] - 1)];
  
  NSString * msg = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
  DLog(@">>%@<<", msg);
  
  if ([strData isCrcOk]) {
    //    DLog(@"Data length %d",[strData length]);
    
    NSData * payload = [strData payload];
    MKAddress address = [strData address];
    NSDictionary * d = nil;
    NSString * n = nil;
    
    switch ([strData command]) {
      case MKCommandLcdMenuResponse:
        n = MKLcdMenuNotification;
        d = [payload decodeLcdMenuResponseForAddress:address];
        break;
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
      case MKCommandVersionResponse:
      {
        
        IKDeviceVersion* dv=[IKDeviceVersion versionWithData:payload forAddress:(IKMkAddress)address];
        NSArray* err=[dv errorDescriptions];
//        [dv release];
        n = MKVersionNotification;
        d = [payload decodeVersionResponseForAddress:address];
        [self setVersionsFrom:d forAddress:address];
        if (!didPostConnectNotification) {
          
          currentDevice=address;
          primaryDevice=address;
          DLog(@"Connected to primaryDevice %d, currentDevice %d",primaryDevice,currentDevice);
          
          NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
          [nc postNotificationName:MKConnectedNotification object:self userInfo:nil];
        }
      }
        break;
      default:
        break;
    }
    
    if (d)
      DLog(@"(%d) %@", [d retainCount],d );
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:n object:self userInfo:d];
    
    //    if (d)
    //      DLog(@"(%d)", [d retainCount] );
    
  } else {
    NSString * msg = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
    DLog(@"%@", msg);
  }
}

@end


