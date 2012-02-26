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
#import "TPMultiLayoutViewController.h"

@class IKMotorData;
@class CustomBadge;
@class InnerShadowView;
@class OsdValue;

@interface BaseOsdViewController : TPMultiLayoutViewController {

  NSArray *motorLabels;
}

@property(nonatomic, retain) IBOutlet CustomBadge *satelites;
@property(nonatomic, retain) IBOutlet CustomBadge *careFree;
@property(nonatomic, retain) IBOutlet CustomBadge *altitudeControl;
@property(nonatomic, retain) IBOutlet CustomBadge *gpsMode;
@property(nonatomic, retain) IBOutlet CustomBadge *failSafe;
@property(nonatomic, retain) IBOutlet CustomBadge *out1;
@property(nonatomic, retain) IBOutlet CustomBadge *out2;

@property(nonatomic, retain) UIColor *gpsOkColor;
@property(nonatomic, retain) UIColor *functionOffColor;
@property(nonatomic, retain) UIColor *functionOnColor;
@property(nonatomic, retain) UIColor *gpsPHColor;
@property(nonatomic, retain) UIColor *gpsCHColor;

@property(nonatomic, retain) IBOutlet InnerShadowView *batteryView;
@property(nonatomic, retain) IBOutlet UIImageView *batteryIcon;
@property(nonatomic, retain) UIImage *batteryOk;
@property(nonatomic, retain) UIImage *batteryLow;
@property(nonatomic, retain) IBOutlet UILabel *battery;
@property(nonatomic, retain) IBOutlet UILabel *current;
@property(nonatomic, retain) IBOutlet UILabel *usedCapacity;

@property(nonatomic, retain) IBOutlet UIImageView *gpsSatelite;
@property(nonatomic, retain) UIImage *gpsSateliteOk;
@property(nonatomic, retain) UIImage *gpsSateliteErr;

@property(nonatomic, retain) IBOutlet UILabel *heigth;
@property(nonatomic, retain) IBOutlet UILabel *variometer;
@property(nonatomic, retain) IBOutlet UILabel *heigthSetpoint;

@property(nonatomic, retain) IBOutlet UILabel *motorData1;
@property(nonatomic, retain) IBOutlet UILabel *motorData2;
@property(nonatomic, retain) IBOutlet UILabel *motorData3;
@property(nonatomic, retain) IBOutlet UILabel *motorData4;
@property(nonatomic, retain) IBOutlet UILabel *motorData5;
@property(nonatomic, retain) IBOutlet UILabel *motorData6;
@property(nonatomic, retain) IBOutlet UILabel *motorData7;
@property(nonatomic, retain) IBOutlet UILabel *motorData8;


@property(nonatomic, retain) IBOutlet UILabel *flightTime;

- (void)updateViewWithOrientation:(UIInterfaceOrientation)orientation;

- (void)updateMotorData:(OsdValue *)value;
- (void)updateStateView:(OsdValue *)value;
- (void)updateBatteryView:(OsdValue *)value;
- (void)updateHeightView:(OsdValue *)value;


@end
