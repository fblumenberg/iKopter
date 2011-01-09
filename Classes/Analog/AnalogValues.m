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
#import "TTGlobalCorePaths.h"
#import "TTCorePreprocessorMacros.h"

#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "IKMkDatatypes.h"
#import "MKDataConstants.h"
#import "IKDebugData.h"
#import "IKDebugLabel.h"

#define kAnalogLabelFile @"analoglables.plist"

@interface AnalogValues (Private)
- (void) analogLabelNotification:(NSNotification *)aNotification;
- (void) debugValueNotification:(NSNotification *)aNotification;
- (void) requestAnalogLabelForIndex:(NSUInteger)index;
- (void) requestDebugData;

- (void) loadLabels;
- (void) saveLabels;
- (void) initNotifications;

@end

@implementation AnalogValues

@synthesize delegate = _delegate;

- (id) init
{
  self = [super init];
  if (self != nil) {
    
    debugData = [[NSMutableArray alloc] initWithCapacity:kMaxDebugDataAnalog];
    for (int i = 0; i < kMaxDebugDataAnalog; i++) {
      [debugData addObject:[NSNumber numberWithInt:0]];
    }
    
    [self loadLabels];
    [self initNotifications];
  }
  
  return self;
}  

- (void) dealloc {
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  [analogLabels release];
  [debugData release];
  [super dealloc];
}

-(void) loadLabels {
  
  NSString *filePath = TTPathForDocumentsResource(kAnalogLabelFile);
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
    DLog(@"Load the analog labels from %@",filePath);
    
    analogLabels = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
  } 
  else {
    
    analogLabels = [[NSMutableArray alloc] initWithCapacity:4];
    for(int d=0;d<4;d++) {
      
      NSMutableArray* analogLabelsDevice = [NSMutableArray arrayWithCapacity:kMaxDebugDataAnalog];
      for (int i = 0; i < kMaxDebugDataAnalog; i++) {
        [analogLabelsDevice addObject:[NSString stringWithFormat:@"Analog%d", i]];
      }
      [analogLabels addObject:analogLabelsDevice];
    }
    
    [self saveLabels];
  }  
}

-(void) saveLabels {
  
  NSString *filePath = TTPathForDocumentsResource(kAnalogLabelFile);
  [analogLabels writeToFile:filePath atomically:NO];
}
                    
-(void) initNotifications {
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];

  [nc addObserver:self
         selector:@selector(analogLabelNotification:)
             name:MKDebugLabelNotification
           object:nil];
  
  [nc addObserver:self
         selector:@selector(debugValueNotification:)
             name:MKDebugDataNotification
           object:nil];
  
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) requestAnalogLabelForIndex:(NSUInteger)theIndex {
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  uint8_t index = theIndex;
  
  NSData * data = [NSData dataWithCommand:MKCommandDebugLabelRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:&index
                                   length:1];
  
  [cCtrl sendRequest:data];
}

- (void) analogLabelNotification:(NSNotification *)aNotification {

  IKDebugLabel* label=[[aNotification userInfo] objectForKey:kIKDataKeyDebugLabel];
  
  if ([label.label length] > 0) {
    NSMutableArray* a=[analogLabels objectAtIndex:label.address];
    [a replaceObjectAtIndex:label.index withObject:label.label];
  }
  
  DLog(@"([%d][%d] %@",label.address , label.index, label.label);
  
  if (label.index < (kMaxDebugDataAnalog-1)) {
    [self requestAnalogLabelForIndex:label.index+1];
  }
  else {
    [self saveLabels];
  }

  [self.delegate didReceiveLabelForIndexPath:[NSIndexPath indexPathForRow:label.index inSection:0]];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) requestDebugData {
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  uint8_t interval = 50;
  
  NSData * data = [NSData dataWithCommand:MKCommandDebugValueRequest
                               forAddress:kIKMkAddressAll
                         payloadWithBytes:&interval
                                   length:1];
  
  [cCtrl sendRequest:data];
}

- (void) debugValueNotification:(NSNotification *)aNotification {
  IKDebugData* newDebugData = [[aNotification userInfo] objectForKey:kIKDataKeyDebugData];
  
  for (int i = 0; i < kMaxDebugDataAnalog; i++) {
    [debugData replaceObjectAtIndex:i withObject:[newDebugData analogValueAtIndex:i]];
  }
  
  if (debugResponseCounter++ > 4 ) {
    [self requestDebugData];
    debugResponseCounter = 0;
  }

  [self.delegate didReceiveValues];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

-(void) reloadAll {
  
  [self performSelector:@selector(requestDebugData) withObject:self afterDelay:0.1];

  [self requestAnalogLabelForIndex:0];
}

-(NSUInteger) count {
  return [debugData count];
}

-(NSString*) labelAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger address=[MKConnectionController sharedMKConnectionController].currentDevice;
  NSMutableArray* a=[analogLabels objectAtIndex:address];

  return [a objectAtIndex:indexPath.row];
}

-(NSString*) valueAtIndexPath:(NSIndexPath *)indexPath {
  return [[debugData objectAtIndex:indexPath.row] description];
}

@end
