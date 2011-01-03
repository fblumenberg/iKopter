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

#import "EngineValues.h"
#import "TTCorePreprocessorMacros.h"

#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "MKDatatypes.h"
#import "MKDataConstants.h"

@interface EngineValues ()

- (IBAction) writeValues;

@end

@implementation EngineValues

- (id) init
{
  self = [super init];
  if (self != nil) {
    [self setValueForAllEngines:0];
    [self writeValues];
  }
  return self;
}

- (void) dealloc
{
  [self setValueForAllEngines:0];
  [self writeValues];
  DLog(@"dealloc");
  [super dealloc];
}

-(void)start {
  [self stop];
  
  updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                 target:self 
                                               selector:@selector(writeValues) 
                                               userInfo:nil 
                                                repeats:YES];
  
}

-(void)stop {
  TT_INVALIDATE_TIMER(updateTimer);
}

-(void)setValueForEngine:(NSInteger)theEngine value:(uint8_t)newValue {
  if (theEngine<0 || theEngine>=16 )
    return;
  
  DLog("New value for engine %d = %d",theEngine,newValue);
  values[theEngine]=newValue;
}

-(void)setValueForAllEngines:(uint8_t)newValue {
  DLog("New value for all %d",newValue);
  memset(values,newValue,sizeof(values));
}

-(uint8_t) valueAtIndexPath:(NSIndexPath *)indexPath {
  return [self valueForEngine:indexPath.row];
}

-(uint8_t) valueForEngine:(NSInteger)theEngine {
  
  if (theEngine<0 || theEngine>=16 )
    return 0;
  
  return values[theEngine];
}

- (IBAction) writeValues {
  
  MKConnectionController* cCtrl=[MKConnectionController sharedMKConnectionController];
  
  DLog("values e[0] = %d",values[0]);
  
  NSData * data = [NSData dataWithCommand:MKCommandEngineTestRequest
                               forAddress:MKAddressAll
                         payloadWithBytes:values
                                   length:16];
  
  [cCtrl sendRequest:data];
}

@end
