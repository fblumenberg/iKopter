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
#import <MapKit/MapKit.h>

extern NSString *const MKRouteChangedNotification;

@class IKPoint;
@class Routes;

@interface Route : NSObject <NSCoding> {

}

@property(retain) NSString *name;
@property(retain) NSMutableArray *points;
@property(assign) Routes *routes;
@property(retain) NSString*  filename;
@property(retain) NSString*  revision;

+ (void)sendChangedNotification:(id)sender;

+ (CLLocationCoordinate2D)defaultCoordinate;

- (NSUInteger)count;

- (IKPoint *)pointAtIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)addPointAtDefault;
- (NSIndexPath *)addPointAtCenter;
- (NSIndexPath *)addPointAtCoordinate:(CLLocationCoordinate2D)coordinate;

- (void) removeAllPoints;
- (void) addPoints:(NSArray*)newPoints;

- (void)movePointAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
- (void)deletePointAtIndexPath:(NSIndexPath *)indexPath;

@end
