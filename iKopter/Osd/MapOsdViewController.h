// ///////////////////////////////////////////////////////////////////////////////
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
// ///////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Route.h"
#import "RouteController.h"
#import "BaseOsdViewController.h"
#import "OsdValue.h"

@class CustomBadge;

@interface MapOsdViewController : BaseOsdViewController<OsdValueDelegate,MKMapViewDelegate,RouteControllerDelegate> {
    
  BOOL needRegionAdjustment;
  
  UIColor* gpsOkColor;
  UIColor* functionOffColor;
  UIColor* functionOnColor;
  UIColor* gpsPHColor;
  UIColor* gpsCHColor;
}

@property(retain) RouteController* routeController;
@property(retain) IBOutlet MKMapView* mapView;
@property(retain) IBOutlet UISwitch* mapTypeSwitch;

@property(nonatomic, retain) IBOutlet CustomBadge* satelites;
@property(nonatomic, retain) IBOutlet CustomBadge* careFree;
@property(nonatomic, retain) IBOutlet CustomBadge* altitudeControl;
@property (nonatomic, retain) IBOutlet CustomBadge *gpsMode;

@end
