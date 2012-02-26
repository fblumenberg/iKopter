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

#import "BaseOsdViewController.h"

@class IKAttitudeIndicator;
@class IKCompass;
@class OsdValue;

@interface ValueBaseOsdViewController : BaseOsdViewController {

}

@property(nonatomic, retain) IBOutlet UILabel *targetPosDev;
@property(nonatomic, retain) IBOutlet UILabel *targetPosDevBearing;
@property(nonatomic, retain) IBOutlet UILabel *targetPosDevDistance;
@property(nonatomic, retain) IBOutlet UILabel *homePosDev;
@property(nonatomic, retain) IBOutlet UILabel *homePosDevBearing;
@property(nonatomic, retain) IBOutlet UILabel *homePosDevDistance;

@property(nonatomic, retain) IBOutlet UILabel *targetTime;
@property(nonatomic, retain) IBOutlet UIImageView *targetIcon;

@property(nonatomic, retain) UIImage *targetReached;
@property(nonatomic, retain) UIImage *targetReachedPending;


@property(nonatomic, retain) IBOutlet UILabel *waypoint;
@property(nonatomic, retain) IBOutlet UILabel *waypointPOI;
@property(nonatomic, retain) IBOutlet UILabel *waypointCount;
@property(nonatomic, retain) IBOutlet UILabel *waypointIndex;

@property(nonatomic, retain) IBOutlet UILabel *attitudeRoll;
@property(nonatomic, retain) IBOutlet UILabel *attitudeYaw;
@property(nonatomic, retain) IBOutlet UILabel *attitudeNick;
@property(nonatomic, retain) IBOutlet UILabel *attitude;

@property(nonatomic, retain) IBOutlet UILabel *speed;
@property(nonatomic, retain) IBOutlet UILabel *topSpeed;

@property(nonatomic, retain) IBOutlet IKAttitudeIndicator *attitudeIndicator;
@property(nonatomic, retain) IBOutlet IKCompass *compass;

- (void)updateAttitueViews:(OsdValue *)value;
- (void)updateWaypointViews:(OsdValue *)value;
- (void)updateTargetHomeViews:(OsdValue *)value;
- (void)updateSpeedViews:(OsdValue *)value;

@end
