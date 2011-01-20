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

#import "Data3DValue.h"
#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "MKDataConstants.h"

@interface Data3DValue()
- (void) sendRefreshRequest;
- (void) dataNotification:(NSNotification *)aNotification;

@property(retain) IKData3D* data;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation Data3DValue

@synthesize delegate=_delegate;
@synthesize data=_data;

///////////////////////////////////////////////////////////////////////////////////////////////////

- (id) init
{
  self = [super init];
  if (self != nil) {
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(dataNotification:)
               name:MKData3DNotification
             object:nil];
    
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


- (void) sendRefreshRequest {
  [[MKConnectionController sharedMKConnectionController] requestData3DForInterval:50];
}

- (void) dataNotification:(NSNotification *)aNotification {
  
  self.data = [[aNotification userInfo] objectForKey:kIKDataKeyData3D];

  [self.delegate newValue:self.data];
  
  NSLog(@"osdCount=%d",lcdCount);
  if (lcdCount++ >= 7 ) {
    [self sendRefreshRequest];
    lcdCount = 0;
  }
}

@end
