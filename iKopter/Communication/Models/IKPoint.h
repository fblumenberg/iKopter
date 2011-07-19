// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010-2011, Frank Blumenberg
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
#import "IKMkDataTypes.h"
#import "IKNaviData.h"

@class CLLocation;

@interface IKPoint :  IKGPSPos<MKAnnotation,NSCoding> {

}
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@property(assign) NSInteger heading;          // orientation, 0 no action, 1...360 fix heading, neg. = Index to POI in WP List
@property(assign) NSInteger toleranceRadius;	// in meters, if the MK is within that range around the target, then the next target is triggered
@property(assign) NSInteger holdTime;         // in seconds, if the was once in the tolerance area around a WP, this time defines the delay before the next WP is triggered
@property(assign) NSInteger eventFlag;       // future implementation / no 1 is Camera Nick control
@property(assign) NSInteger index;            // to indentify different waypoints, workaround for bad communications PC <-> NC
@property(assign) NSInteger type;             // typeof Waypoint
@property(assign) NSInteger wpEventChannelValue;  //
@property(assign) NSInteger altitudeRate;     // rate to change the setpoint
@property(assign) BOOL cameraNickControl;

@property(assign) CLLocationDegrees posLatitude;
@property(assign) CLLocationDegrees posLongitude;

+ (id)pointWithData:(NSData *)data;
- (id)initWithData:(NSData*)data;
- (id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate;

- (NSData*) data;

@end
