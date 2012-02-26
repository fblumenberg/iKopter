/////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
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
/////////////////////////////////////////////////////////////////////////////////

#import "RouteController.h"
#import "Route.h"

#import "MKConnectionController.h"
#import "MKDataConstants.h"
#import "IKPoint.h"


@interface RouteController ()

- (void)uploadClearPoint;
- (void)uploadPoint:(NSUInteger)index;

- (void)downloadPoint:(NSUInteger)index;


@end

@implementation RouteController

@synthesize delegate;
@synthesize route;
@synthesize state;

- (id)initWithDelegate:(id <RouteControllerDelegate>)aDelegate {
  self = [super init];
  if (self) {
    self.delegate = aDelegate;

    currIndex = 0;
    state = RouteControllerIsIdle;

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(writePointNotification:)
               name:MKWritePointNotification
             object:nil];
    [nc addObserver:self
           selector:@selector(readPointNotification:)
               name:MKReadPointNotification
             object:nil];
  }
  return self;
}

- (void)dealloc {
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];

  self.route = nil;
  [super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Upload 

- (void)uploadRouteToNaviCtrl:(Route *)aRoute {
  self.route = aRoute;

  currIndex = 0;
  state = RouteControllerIsUploading;
  [self uploadClearPoint];

}

- (void)uploadClearPoint {

  IKPoint *p = [[[IKPoint alloc] init] autorelease];

  p.status = INVALID;
  p.index = 0;

  qlinfo(@"Upload clear list point %@", p);
  [[MKConnectionController sharedMKConnectionController] writePoint:p];
}

- (void)uploadPoint:(NSUInteger)index {

  IKPoint *p = (IKPoint *) [self.route.points objectAtIndex:index];
  qlinfo(@"Upload point (%d) %@", index, p);
  [[MKConnectionController sharedMKConnectionController] writePoint:p];

  if ([self.delegate respondsToSelector:@selector(routeControllerStartUpload:forIndex:)])
    [self.delegate routeControllerStartUpload:self forIndex:index];
}

- (void)writePointNotification:(NSNotification *)aNotification {

  NSDictionary *d = [aNotification userInfo];
  NSInteger index = [[d objectForKey:kMKDataKeyIndex] integerValue] - 1;
  qlinfo(@"Upload point (%d) finished", index);

  if ([self.delegate respondsToSelector:@selector(routeControllerFinishedUpload:forIndex:of:)])
    [self.delegate routeControllerFinishedUpload:self forIndex:index of:[self.route.points count]];

  if (state == RouteControllerIsUploading && currIndex < [self.route.points count]) {
    [self uploadPoint:currIndex++];
  }
  else {
    if ([self.delegate respondsToSelector:@selector(routeControllerFinishedUpload:)])
      [self.delegate routeControllerFinishedUpload:self];

    if (state == RouteControllerIsUploading) {
      state = RouteControllerIsIdle;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Download 

- (void)downloadPoint:(NSUInteger)index {

  qlinfo(@"Download point (%d)", index);
  [[MKConnectionController sharedMKConnectionController] requestPointForIndex:index + 1];

  if ([self.delegate respondsToSelector:@selector(routeControllerStartDownload:forIndex:)])
    [self.delegate routeControllerStartDownload:self forIndex:index];
}

- (void)downloadRouteFromNaviCtrl {
  self.route = [[[Route alloc] init] autorelease];

  currIndex = 0;
  state = RouteControllerIsDownloading;

  [self downloadPoint:currIndex++];
}

- (void)readPointNotification:(NSNotification *)aNotification {

  NSDictionary *d = [aNotification userInfo];
  NSInteger count = [[d objectForKey:kMKDataKeyMaxItem] integerValue];

  BOOL downloadFinished = NO;

  if ([d objectForKey:kMKDataKeyIndex]) {
    NSInteger index = [[d objectForKey:kMKDataKeyIndex] integerValue] - 1;
    qlinfo(@"Download point (NC index %d) finished", index);

    if ([self.delegate respondsToSelector:@selector(routeControllerFinishedUpload:forIndex:of:)])
      [self.delegate routeControllerFinishedUpload:self forIndex:index of:[self.route.points count]];

    IKPoint *p = [d objectForKey:kIKDataKeyPoint];
    [self.route.points addObject:p];

    qltrace(@"Route is now %@", self.route.points);

    if (state == RouteControllerIsDownloading && currIndex < count) {
      [self downloadPoint:currIndex++];
    }
    else {
      downloadFinished = YES;
    }
  }
  else {
    qlerror(@"No point for the NC index %d. Count is %d", currIndex, count);
    downloadFinished = YES;
  }

  if (downloadFinished) {
    if ([self.delegate respondsToSelector:@selector(routeControllerFinishedDownload:)])
      [self.delegate routeControllerFinishedDownload:self];

    if (state == RouteControllerIsDownloading) {
      state = RouteControllerIsIdle;
    }
  }
}

@end
