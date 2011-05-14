/*
 * Copyright (C) 2009 by Matthias Ringwald
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of the copyright holders nor the names of
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY MATTHIAS RINGWALD AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL MATTHIAS
 * RINGWALD OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 */

#pragma once

#import <Foundation/Foundation.h>
#import <stdint.h>
#import "MKBTStackManager.h"

#define PREFS_REMOTE_NAME  @"RemoteName"
#define PREFS_LINK_KEY     @"LinkKey"
#define BTstackManagerID   @"ch.ringwald.btstack"

@class BTDevice;

/*
 * Information on devices is stored in a system-wide plist
 * it is maintained by BTStackManagerDiscovery
 * this includes the link keys
 */

// TODO enumerate BTstackError type
typedef int BTstackError;

typedef enum {
	kDeactivated = 1,
	kW4SysBTState,
	kW4SysBTDisabled,
	kW4Activated,
	kActivated,
	kW4Deactivated,
	kSleeping,
#if 0
	kW4DisoveryStopped,
	kW4AuthenticationEnableCommand
#endif
} ManagerState;

typedef enum {
	kInactive = 1,
	kW4InquiryMode,
	kInquiry,
	kRemoteName,
	// stopping
	kW4InquiryModeBeforeStop,
	kW4InquiryStop,
	kW4RemoteNameBeforeStop,
} DiscoveryState;

@protocol BTStackManagerListener;

@interface BTStackManagerDiscovery : NSObject<MKBTStackManagerDelegate> {
@private
	NSMutableDictionary *deviceInfo;
	NSMutableArray *discoveredDevices;
	NSMutableSet *listeners;
	BOOL connectedToDaemon;
	ManagerState state;
	DiscoveryState discoveryState;
	int discoveryDeviceIndex;
}

// listeners
-(void) addListener:(id<BTStackManagerListener>)listener;
-(void) removeListener:(id<BTStackManagerListener>)listener;

// Activation
-(BTstackError) activate;
-(BTstackError) deactivate;
-(BOOL) isActivating;
-(BOOL) isActive;

// Discovery
-(BTstackError) startDiscovery;
-(BTstackError) stopDiscovery;
-(int) numberOfDevicesFound;
-(BTDevice*) deviceAtIndex:(int)index;
-(BOOL) isDiscoveryActive;

// Link Key Management
-(void) dropLinkKeyForAddress:(bd_addr_t*) address;

@property (nonatomic, retain) NSMutableDictionary *deviceInfo;
@property (nonatomic, retain) NSMutableArray *discoveredDevices;
@property (nonatomic, retain) NSMutableSet *listeners;
@end


@protocol BTStackManagerListener
@optional

// Activation events
-(void) activatedBTstackManager:(BTStackManagerDiscovery*) manager;
-(void) btstackManager:(BTStackManagerDiscovery*)manager activationFailed:(BTstackError)error;
-(void) deactivatedBTstackManager:(BTStackManagerDiscovery*) manager;

// Power management events
-(void) sleepModeEnterBTstackManager:(BTStackManagerDiscovery*) manager;
-(void) sleepModeExtitBTstackManager:(BTStackManagerDiscovery*) manager;

// Discovery events: general
-(void) btstackManager:(BTStackManagerDiscovery*)manager deviceInfo:(BTDevice*)device;
-(void) btstackManager:(BTStackManagerDiscovery*)manager discoveryQueryRemoteName:(int)deviceIndex;
-(void) discoveryStoppedBTstackManager:(BTStackManagerDiscovery*) manager;
-(void) discoveryInquiryBTstackManager:(BTStackManagerDiscovery*) manager;

@end
