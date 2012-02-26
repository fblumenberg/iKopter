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

#import "AnalogValues.h"

#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "IKMkDatatypes.h"
#import "MKDataConstants.h"
#import "IKDebugData.h"
#import "IKDeviceVersion.h"

#define kAnalogLabelFile @"analoglabels"

@interface AnalogValues (Private)

- (void)debugValueNotification:(NSNotification *)aNotification;
- (void)deviceChangedNotification:(NSNotification *)aNotification;
- (void)requestDebugData;
- (void)loadLabels;
- (void)initNotifications;

@end

@implementation AnalogValues

@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self != nil) {

    debugData = [[NSMutableArray alloc] initWithCapacity:kMaxDebugDataAnalog];
    for (int i = 0; i < kMaxDebugDataAnalog; i++) {
      [debugData addObject:[NSNumber numberWithInt:0]];
    }

    [self loadLabels];
    [self initNotifications];
    [self reloadLabels];
  }

  return self;
}

- (void)dealloc {

  [self stopRequesting];

  [analogLabels release];
  [debugData release];
  [super dealloc];
}

- (void)loadLabels {

  NSString *filePath = [[NSBundle mainBundle] pathForResource:kAnalogLabelFile ofType:@"plist"];

  analogLabels = [[NSArray alloc] initWithContentsOfFile:filePath];
}

- (void)initNotifications {

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

  [nc addObserver:self
         selector:@selector(debugValueNotification:)
             name:MKDebugDataNotification
           object:nil];

  [nc addObserver:self
         selector:@selector(deviceChangedNotification:)
             name:MKDeviceChangedNotification
           object:nil];


}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)startRequesting {

  [self initNotifications];

  requestTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:
          @selector(requestDebugData)           userInfo:nil repeats:YES];

  [self performSelector:@selector(requestDebugData) withObject:self afterDelay:0.1];
}

- (void)stopRequesting {

  [requestTimer invalidate];
  requestTimer = nil;

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}


- (void)deviceChangedNotification:(NSNotification *)aNotification {
  [self reloadLabels];
  [self.delegate didReceiveValues];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)requestDebugData {

  MKConnectionController *cCtrl = [MKConnectionController sharedMKConnectionController];
  uint8_t interval = 50;

  NSData *data = [NSData dataWithCommand:MKCommandDebugValueRequest
                              forAddress:kIKMkAddressAll
                        payloadWithBytes:&interval
                                  length:1];

  [cCtrl sendRequest:data];
}

- (void)debugValueNotification:(NSNotification *)aNotification {
  IKDebugData *newDebugData = [[aNotification userInfo] objectForKey:kIKDataKeyDebugData];

  for (int i = 0; i < kMaxDebugDataAnalog; i++) {
    [debugData replaceObjectAtIndex:i withObject:[newDebugData analogValueAtIndex:i]];
  }

  [self.delegate didReceiveValues];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)reloadLabels {

  MKConnectionController *cCtrl = [MKConnectionController sharedMKConnectionController];

  IKDeviceVersion *v = [cCtrl versionForAddress:[cCtrl currentDevice]];

  NSDictionary *devArrays = [analogLabels objectAtIndex:[cCtrl currentDevice]];

  currAnalogLabels = [devArrays objectForKey:v.versionStringShort];
  if (!currAnalogLabels) {
    currAnalogLabels = [devArrays objectForKey:v.versionMainStringShort];
  }
  if (!currAnalogLabels)
    currAnalogLabels = [devArrays objectForKey:@"UNK"];
}

- (NSUInteger)count {
  return [debugData count];
}

- (NSString *)labelAtIndexPath:(NSIndexPath *)indexPath {
  return [currAnalogLabels objectAtIndex:indexPath.row];
}

- (NSString *)valueAtIndexPath:(NSIndexPath *)indexPath {
  return [[debugData objectAtIndex:indexPath.row] description];
}

@end
