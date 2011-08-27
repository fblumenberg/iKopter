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

#import <Foundation/Foundation.h>
#import "MKConnection.h"
#import "IKMkDatatypes.h"

extern NSString * const MKFoundDeviceNotification;
extern NSString * const MKDeviceChangedNotification;
extern NSString * const MKConnectedNotification;
extern NSString * const MKDisconnectedNotification;
extern NSString * const MKDisconnectErrorNotification;

extern NSString * const MKVersionNotification;
extern NSString * const MKDebugDataNotification;
extern NSString * const MKDebugLabelNotification;
extern NSString * const MKLcdMenuNotification;
extern NSString * const MKLcdNotification;

extern NSString * const MKReadSettingNotification;
extern NSString * const MKWriteSettingNotification;
extern NSString * const MKChangeSettingNotification;

extern NSString * const MKChannelValuesNotification;

extern NSString * const MKReadMixerNotification;
extern NSString * const MKWriteMixerNotification;

extern NSString * const MKOsdNotification;
extern NSString * const MKData3DNotification;

extern NSString * const MKReadPointNotification;
extern NSString * const MKWritePointNotification;


@class MKHost;
@class IKParamSet;
@class IKDeviceVersion;
@class IKPoint;


@interface MKConnectionController : NSObject<MKConnectionDelegate> {

  NSObject<MKConnection>* _inputController;
  MKHost* _hostOrDevice;
  
  NSInteger connectionState;
  NSInteger retryCount;
  BOOL didPostConnectNotification;

  IKMkAddress primaryDevice;
  IKMkAddress currentDevice;
  
  IKDeviceVersion * versions[3];
}

@property(readonly) IKMkAddress primaryDevice;
@property(assign,readonly) IKMkAddress currentDevice;
@property(retain) MKHost* hostOrDevice;
@property(retain) NSObject<MKConnection>* inputController;

+ (MKConnectionController *) sharedMKConnectionController;

- (void) start:(MKHost*)host;
- (void) stop;

- (BOOL) isRunning;

- (void) sendRequest:(NSData *)data;

- (BOOL) hasNaviCtrl;
- (BOOL) hasFlightCtrl;
- (BOOL) hasMK3MAG;
- (void) activateNaviCtrl;
- (void) activateFlightCtrl;
- (void) activateMK3MAG;
- (void) activateMKGPS;

- (void) requestSettingForIndex:(NSInteger)theIndex;
- (void) setActiveSetting:(NSUInteger)newActiveSetting;
- (void) saveSetting:(IKParamSet*)setting;

- (IKDeviceVersion*) versionForAddress:(IKMkAddress)theAddress;

- (void) requestData3DForInterval:(NSUInteger)interval;
- (void) requestDebugValueForInterval:(NSUInteger)interval;
- (void) requestOsdDataForInterval:(NSUInteger)interval;

- (void) requestPointForIndex:(NSInteger)interval;
- (void) writePoint:(IKPoint*)point;
- (void) sendPoint:(IKPoint*)point;

  
@end
