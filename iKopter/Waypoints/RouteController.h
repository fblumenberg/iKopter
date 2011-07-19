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

#import <Foundation/Foundation.h>

@protocol RouteControllerDelegate;

@class Route;

typedef enum {
  RouteControllerIsIdle,
  RouteControllerIsUploading,
  RouteControllerIsDownloading
} RouteControllerState;

@interface RouteController : NSObject {

  RouteControllerState state;
  
  NSInteger currIndex;
}

@property(readonly) RouteControllerState state;
@property(assign) id<RouteControllerDelegate> delegate;
@property(retain) Route* route;

-(id) initWithDelegate:(id<RouteControllerDelegate>)delegate;

-(void) uploadRouteToNaviCtrl:(Route*)aRoute;
-(void) downloadRouteFromNaviCtrl;

@end

@protocol RouteControllerDelegate <NSObject>

@optional
-(void)routeControllerStartDownload:(RouteController*)controller forIndex:(NSInteger) index;
-(void)routeControllerFinishedDownload:(RouteController*)controller forIndex:(NSInteger) index of:(NSInteger) count;
-(void)routeControllerFinishedDownload:(RouteController*)controller;
-(void)routeControllerFailedDownload:(RouteController*)controller WithError:(NSError *)error;

-(void)routeControllerStartUpload:(RouteController*)controller forIndex:(NSInteger) index;
-(void)routeControllerFinishedUpload:(RouteController*)controller forIndex:(NSInteger) index of:(NSInteger) count;
-(void)routeControllerFinishedUpload:(RouteController*)controller;
-(void)routeControllerFailedUpload:(RouteController*)controller WithError:(NSError *)error;



@end