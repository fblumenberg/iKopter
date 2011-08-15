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
#import "OsdValue.h"
#import "CustomBadge.h"
#import "IKCompass.h"
#import "IKAttitudeIndicator.h"
@class InnerShadowView;

@interface ValueOsdViewController : UIViewController<OsdValueDelegate> {

  UILabel* noData;
  UILabel* heigth;
  UILabel* heigthSetpoint;
  UILabel* battery;
  UILabel* current;
  UILabel* usedCapacity;
  UILabel* attitude;

  UILabel* speed;
  UILabel* waypoint;

  UILabel* targetPosDev;
  UILabel* homePosDev;
  UILabel *targetPosDevDistance;
  UILabel *homePosDevDistance;
  UILabel *targetTime;
  
  IKCompass* compass;
  UILabel *attitudeRoll;
  UILabel *attitudeYaw;
  UILabel *attitudeNick;
 
  UIImageView* gpsSatelite;
  
  CustomBadge* satelites;
  CustomBadge* careFree;
  CustomBadge* altitudeControl;
  
  UILabel* flightTime;

  UIColor* gpsOkColor;
  UIColor* functionOffColor;
  UIColor* functionOnColor;
  UIColor* gpsPHColor;
  UIColor* gpsCHColor;

  UIImage* gpsSateliteOk;
  UIImage* gpsSateliteErr;
  
  InnerShadowView *batteryView;
  CustomBadge *gpsMode;
  IKAttitudeIndicator *attitudeIndicator;

  UILabel *topSpeed;
  UILabel *waypointPOI;
  UILabel *waypointCount;
  UILabel *waypointIndex;
}
@property (nonatomic, retain) IBOutlet InnerShadowView *batteryView;

@property(retain) UIImage* gpsSateliteOk;
@property(retain) UIImage* gpsSateliteErr;

@property(retain) UIImage* targetReached;
@property(retain) UIImage* targetReachedPending;

@property(retain) UIImage* batteryOk;
@property(retain) UIImage* batteryLow;

@property (nonatomic, retain) IBOutlet UILabel *waypointPOI;
@property (nonatomic, retain) IBOutlet UILabel *waypointCount;
@property (nonatomic, retain) IBOutlet UILabel *waypointIndex;

@property(retain) IBOutlet UILabel* infoView;

@property(retain) IBOutlet UILabel* noData;
@property(retain) IBOutlet UILabel* heigth;
@property(retain) IBOutlet UILabel* variometer;
@property(retain) IBOutlet UILabel* heigthSetpoint;
@property(retain) IBOutlet UILabel* battery;
@property(retain) IBOutlet UILabel* current;
@property(retain) IBOutlet UILabel* usedCapacity;
@property(retain) IBOutlet UIImageView* gpsSatelite;
@property(retain) IBOutlet UIImageView* targetIcon;
@property(retain) IBOutlet UIImageView* batteryIcon;
@property (nonatomic, retain) IBOutlet CustomBadge *gpsMode;
@property (nonatomic, retain) IBOutlet IKAttitudeIndicator *attitudeIndicator;
@property (nonatomic, retain) IBOutlet UILabel *topSpeed;

@property(retain) IBOutlet CustomBadge* satelites;
@property(retain) IBOutlet CustomBadge* careFree;
@property(retain) IBOutlet CustomBadge* altitudeControl;
@property(retain) IBOutlet UILabel* gpsTarget;
@property(retain) IBOutlet UILabel* flightTime;
@property(retain) IBOutlet IKCompass* compass;
@property (nonatomic, retain) IBOutlet UILabel *attitudeRoll;
@property (nonatomic, retain) IBOutlet UILabel *attitudeYaw;
@property (nonatomic, retain) IBOutlet UILabel *attitudeNick;
@property(retain) IBOutlet UILabel* attitude;
@property(retain) IBOutlet UILabel* speed;
@property(retain) IBOutlet UILabel* waypoint;
@property(retain) IBOutlet UILabel* targetPosDev;
@property(retain) IBOutlet UILabel* homePosDev;
@property (nonatomic, retain) IBOutlet UILabel *targetPosDevDistance;
@property (nonatomic, retain) IBOutlet UILabel *homePosDevDistance;
@property (nonatomic, retain) IBOutlet UILabel *targetTime;

@end
