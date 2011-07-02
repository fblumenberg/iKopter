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
#import "Route.h"
#import "FDCurlViewControl.h"
#import "SurrogateViewParent.h"

@class MKMapView;
@class CLLocation;

@interface RouteMapViewController : UIViewController<MKMapViewDelegate,SurrogateViewParent> {
    
}

@property (retain) Route* route;
@property (retain) IBOutlet MKMapView *mapView;
@property (retain) FDCurlViewControl* curlBarItem;
@property (retain) IBOutlet UISegmentedControl *segmentedControl;

- (id)initWithRoute:(Route*) theRoute;
- (IBAction) changeMapViewType;
- (void)addPoint;
- (void)addPointWithLocation:(CLLocation*)location;


@end
