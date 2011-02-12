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

#import "OsdValue.h"
#import "MKConnectionController.h"
#import "MKDataConstants.h"

@interface OsdValue()
- (void) sendOsdRefreshRequest;
- (void) osdNotification:(NSNotification *)aNotification;

@property(retain) IKNaviData* data;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation OsdValue

@synthesize delegate=_delegate;
@synthesize data=_data;

-(BOOL) areEnginesOn {
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_MOTOR_RUN) == FC_STATUS_MOTOR_RUN);
}
-(BOOL) isFlying{
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_FLY) == FC_STATUS_FLY);
}
-(BOOL) isCalibrating{
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_CALIBRATE) == FC_STATUS_CALIBRATE);
}
-(BOOL) isStarting{
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_START) == FC_STATUS_START);
}

-(BOOL) isEmergencyLanding;{
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_EMERGENCY_LANDING) == FC_STATUS_EMERGENCY_LANDING);
}

-(BOOL) isLowBat;{
  if (!_data.data) 
    return NO;
  return ((_data.data->FCStatusFlags&FC_STATUS_LOWBAT) == FC_STATUS_LOWBAT);
}

-(BOOL) isFreeModeEnabled;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_FREE) == NC_FLAG_FREE);
}

-(BOOL) isPositionHoldEnabled;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_PH) == NC_FLAG_PH);
}

-(BOOL) isComingHomeEnabled;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_CH) == NC_FLAG_CH);
}

-(BOOL) isRangeLimitReached;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_RANGE_LIMIT) == NC_FLAG_RANGE_LIMIT);
}

-(BOOL) isTargetReached;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_TARGET_REACHED) == NC_FLAG_TARGET_REACHED);
}

-(BOOL) isManualControlEnabled;{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_MANUAL_CONTROL) == NC_FLAG_MANUAL_CONTROL);
}
-(BOOL) isGpsOk{
  if (!_data.data) 
    return NO;
  return ((_data.data->NCFlags&NC_FLAG_GPS_OK) == NC_FLAG_GPS_OK);
}



///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init
{
  self = [super init];
  if (self != nil) {
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(osdNotification:)
               name:MKOsdNotification
             object:nil];
    
    self.data=[IKNaviData data];
    [self performSelector:@selector(sendOsdRefreshRequest) withObject:self afterDelay:0.1];
    
  }
  return self;
}

- (void) dealloc
{
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];

  [_data release];
  [super dealloc];
}


- (void) sendOsdRefreshRequest {
  [[MKConnectionController sharedMKConnectionController] requestOsdDataForInterval:40];
}

- (void) osdNotification:(NSNotification *)aNotification {
  
  self.data = [[aNotification userInfo] objectForKey:kIKDataKeyOsd];
  
  [self.delegate newValue:self];

  NSLog(@"osdCount=%d",requestCount);
  if (requestCount++ >= 6 ) {
    [self sendOsdRefreshRequest];
    requestCount = 0;
  }
}

@end
