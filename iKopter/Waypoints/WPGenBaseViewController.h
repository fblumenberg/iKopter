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
#import "WPGenBaseDataSource.h"

IK_DECLARE_KEY(WPaltitude);
IK_DECLARE_KEY(WPtoleranceRadius);
IK_DECLARE_KEY(WPholdTime);
IK_DECLARE_KEY(WPcamAngle);
IK_DECLARE_KEY(WPheading);
IK_DECLARE_KEY(WPaltitudeRate);
IK_DECLARE_KEY(WPspeed);
IK_DECLARE_KEY(WPwpEventChannelValue);
IK_DECLARE_KEY(WPclearWpList);

@class IKPoint;
@protocol WPGenBaseViewControllerDelegate;

@interface WPGenBaseViewController : UIViewController

- (id)initWithShapeView:(UIView *)shapeView forMapView:(MKMapView*)mapView;

@property(nonatomic, readonly) NSMutableDictionary *wpData;
@property(nonatomic, assign) id<WPGenBaseViewControllerDelegate> delegate;
@property(nonatomic, retain) MKMapView* mapView;

@property(retain, nonatomic) IBOutlet UIView *shapeView;
@property(retain) WPGenBaseDataSource* dataSource;

- (NSArray*) generatePointsList;

- (IBAction)closeView:(id)sender;

- (IBAction)generatePoints:(id)sender;
- (IBAction)showConfig:(id)sender;
- (IKPoint*) pointOfType:(NSInteger)type forCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@protocol WPGenBaseViewControllerDelegate

- (void) controllerWillClose:(WPGenBaseViewController*)controller; 
- (void) controller:(WPGenBaseViewController*)controller generatedPoints:(NSArray*)points clearList:(BOOL)clear;

@end
