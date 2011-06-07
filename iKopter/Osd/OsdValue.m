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

#import "iKopterAppDelegate.h"
#import "OsdValue.h"
#import "MKConnectionController.h"
#import "MKDataConstants.h"
#import "NCLogSession.h"
#import "NCLogRecord.h"

@interface OsdValue()
- (void) sendOsdRefreshRequest;
- (void) logNCData;
- (void) osdNotification:(NSNotification *)aNotification;

@property(retain) IKNaviData* data;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation OsdValue

@synthesize delegate=_delegate;
@synthesize data=_data;
@synthesize ncLogSession=_ncLogSession;
@synthesize managedObjectContext;

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
    
    self.data=[IKNaviData data];
    
    _logActive=NO;
    
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKNCLoggingActive];
    if (testValue) {
      _logActive = [[NSUserDefaults standardUserDefaults] boolForKey:kIKNCLoggingActive];
    }
    
    testValue = nil;
    testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKNCLoggingInterval];
    if (testValue) {
      _logInterval = [[NSUserDefaults standardUserDefaults] doubleForKey:kIKNCLoggingInterval]/1000.0;
    }
    
    if (_logActive) {
      iKopterAppDelegate* appDelegate =(iKopterAppDelegate*)[[UIApplication sharedApplication] delegate];
      self.managedObjectContext=appDelegate.managedObjectContext;
      
      self.ncLogSession = [NSEntityDescription insertNewObjectForEntityForName:@"NCLogSession" inManagedObjectContext:self.managedObjectContext];
      self.ncLogSession.timeStampStart=[NSDate date];
    }
    
  }
  return self;
}

- (void) dealloc {
  
  self.data=nil;
  [super dealloc];
}


- (void) startRequesting {

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  
  [nc addObserver:self
         selector:@selector(osdNotification:)
             name:MKOsdNotification
           object:nil];

  requestTimer=[NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:
                @selector(sendOsdRefreshRequest) userInfo:nil repeats:YES];
  
  requestCount=0;
  [self performSelector:@selector(sendOsdRefreshRequest) withObject:self afterDelay:0.1];
  
  if( _logActive ){
    logTimer=[NSTimer scheduledTimerWithTimeInterval: _logInterval target:self selector:
              @selector(logNCData) userInfo:nil repeats:YES];
  }
}

- (void) stopRequesting {
  
  [requestTimer invalidate];
  requestTimer=nil;

  [logTimer invalidate];
  logTimer=nil;
  
  if( _logActive ){
    self.ncLogSession.timeStampEnd=[NSDate date];
    
    NSError *error = nil;
    if(![self.managedObjectContext save:&error]){
      qlcritical(@"Could not save the NC-Log records %@",error);
    }
  }

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
}


- (void) sendOsdRefreshRequest {
  
  if(requestCount==3)
    [self.delegate noDataAvailable];
  
  [[MKConnectionController sharedMKConnectionController] requestOsdDataForInterval:40];
  requestCount++;
}

- (void) osdNotification:(NSNotification *)aNotification {

  requestCount=0;
  self.data = [[aNotification userInfo] objectForKey:kIKDataKeyOsd];
  
  [self.delegate newValue:self];

//  NSLog(@"osdCount=%d",requestCount);
//  if (requestCount++ >= 6 ) {
//    [self sendOsdRefreshRequest];
//    requestCount = 0;
//  }
}

- (void) logNCData {
  
  NCLogRecord* record=[NSEntityDescription insertNewObjectForEntityForName:@"NCLogRecord" inManagedObjectContext:self.managedObjectContext];
  record.timeStamp=[NSDate date];
  
  [record fillFromNCData:self.data];
  
  NSMutableSet *relationshipSet = [self.ncLogSession mutableSetValueForKey:@"records"];
  [relationshipSet addObject:record];
  
  qltrace(@"log");
}


@end
