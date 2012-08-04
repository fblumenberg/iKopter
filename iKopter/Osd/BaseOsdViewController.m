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
#import "UIColor+ColorWithHex.h"
#import "UIImage+Tint.h"
#import "OsdValue.h"
#import "InnerShadowView.h"
#import "CustomBadge.h"


@implementation BaseOsdViewController

@synthesize satelites;
@synthesize careFree;
@synthesize altitudeControl;
@synthesize gpsMode;
@synthesize failSafe;
@synthesize out1;
@synthesize out2;

@synthesize flightTime;

@synthesize gpsOkColor;
@synthesize functionOffColor;
@synthesize functionOnColor;
@synthesize gpsPHColor;
@synthesize gpsCHColor;

@synthesize batteryView;
@synthesize gpsSatelite;
@synthesize batteryOk;
@synthesize batteryLow;

@synthesize batteryIcon;
@synthesize gpsSateliteOk;
@synthesize gpsSateliteErr;

@synthesize heigth;
@synthesize variometer;
@synthesize heigthSetpoint;
@synthesize battery;
@synthesize current;
@synthesize usedCapacity;

@synthesize motorData1;
@synthesize motorData2;
@synthesize motorData3;
@synthesize motorData4;
@synthesize motorData5;
@synthesize motorData6;
@synthesize motorData7;
@synthesize motorData8;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.gpsOkColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0];
    self.functionOffColor = [UIColor colorWithHexString:@"#E6E6E6" andAlpha:1.0];
    self.functionOnColor = [UIColor blueColor];

    self.gpsPHColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
    self.gpsCHColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];

    self.gpsSateliteOk = [UIImage imageNamed:@"satelite.png"];
    self.gpsSateliteErr = [self.gpsSateliteOk imageTintedWithColor:[UIColor redColor]];


    self.batteryOk = [UIImage imageNamed:@"battery.png"];
    self.batteryLow = [self.batteryOk imageTintedWithColor:[UIColor whiteColor]];

  }
  return self;
}


- (void)dealloc {

  [motorLabels release];

  self.satelites = nil;
  self.careFree = nil;
  self.altitudeControl = nil;
  self.gpsMode = nil;
  self.failSafe = nil;
  self.out1 = nil;
  self.out2 = nil;

  self.flightTime = nil;

  self.gpsOkColor = nil;
  self.functionOffColor = nil;
  self.functionOnColor = nil;
  self.gpsPHColor = nil;
  self.gpsCHColor = nil;

  self.batteryView = nil;
  self.gpsSatelite = nil;
  self.batteryOk = nil;
  self.batteryLow = nil;

  self.batteryIcon = nil;
  self.gpsSateliteOk = nil;
  self.gpsSateliteErr = nil;

  self.heigth = nil;
  self.variometer = nil;
  self.heigthSetpoint = nil;
  self.battery = nil;
  self.current = nil;
  self.usedCapacity = nil;

  self.motorData1 = nil;
  self.motorData2 = nil;
  self.motorData3 = nil;
  self.motorData4 = nil;
  self.motorData5 = nil;
  self.motorData6 = nil;
  self.motorData7 = nil;
  self.motorData8 = nil;

  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)updateViewWithOrientation:(UIInterfaceOrientation)orientation {

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    self.altitudeControl.badgeScaleFactor = 1.5;
    self.careFree.badgeScaleFactor = 1.5;
    self.gpsMode.badgeScaleFactor = 1.5;
    self.satelites.badgeScaleFactor = 1.5;
    self.failSafe.badgeScaleFactor = 1.5;
    self.out1.badgeScaleFactor = 1.5;
    self.out2.badgeScaleFactor = 1.5;
  }
  else {
    self.altitudeControl.badgeScaleFactor = 1.0;
    self.careFree.badgeScaleFactor = 1.0;
    self.gpsMode.badgeScaleFactor = 1.0;
    self.satelites.badgeScaleFactor = 1.0;
    self.failSafe.badgeScaleFactor = 1.0;
    self.out1.badgeScaleFactor = 1.0;
    self.out2.badgeScaleFactor = 1.0;
  }

  self.altitudeControl.badgeInsetColor = self.functionOffColor;
//  [self.altitudeControl autoBadgeSizeWithString:@"ALT"];

  self.careFree.badgeInsetColor = self.functionOffColor;
//  [self.careFree autoBadgeSizeWithString:@"ALT"];

  self.gpsMode.badgeInsetColor = self.functionOffColor;
//  [self.gpsMode autoBadgeSizeWithString:@"FREE"];

  self.failSafe.badgeInsetColor = self.functionOffColor;
//  [self.failSafe autoBadgeSizeWithString:@"FAILSAFE"];

//  CGRect frame=self.failSafe.frame;
//  CGRect frameAlt=self.altitudeControl.frame;
//  CGFloat rectWidth = CGRectGetMaxX(frameAlt)-CGRectGetMinX(frame);
//  self.failSafe.frame = CGRectMake(frame.origin.x, frame.origin.y, rectWidth, frame.size.height);

  self.out1.badgeInsetColor = self.functionOffColor;
//  [self.out1 autoBadgeSizeWithString:@"ALT"];

  self.out1.badgeInsetColor = self.functionOffColor;
//  [self.out2 autoBadgeSizeWithString:@"ALT"];
}

- (void)updateStateView:(OsdValue *)value {
  IKMkNaviData *data = value.data.data;

  self.gpsSatelite.image = value.isGpsOk ? self.gpsSateliteOk : self.gpsSateliteErr;
  self.satelites.badgeInsetColor = value.isGpsOk ? self.gpsOkColor : [UIColor redColor];
  [self.satelites autoBadgeSizeWithString:[NSString stringWithFormat:@"%d", data->SatsInUse]];

  self.altitudeControl.badgeInsetColor = value.isAltControlOn ? self.functionOnColor : self.functionOffColor;
  self.altitudeControl.badgeText = @"Alt";
  [self.altitudeControl setNeedsDisplay];

  self.careFree.badgeInsetColor = value.isCareFreeOn ? self.functionOnColor : self.functionOffColor;
  self.careFree.badgeText = @"CF";
  [self.careFree setNeedsDisplay];

  self.failSafe.badgeInsetColor = value.isFailsafeOn ? [UIColor redColor] : self.functionOffColor;
  self.failSafe.badgeText = @"FAILSAFE";
  [self.failSafe setNeedsDisplay];

  self.out1.badgeInsetColor = value.isOut1On ? self.functionOnColor : self.functionOffColor;
  self.out1.badgeText = @"Out1";
  [self.out1 setNeedsDisplay];

  self.out2.badgeInsetColor = value.isOut2On ? self.functionOnColor : self.functionOffColor;
  self.out2.badgeText = @"Out2";
  [self.out2 setNeedsDisplay];


  if (value.isFreeModeEnabled) {
    self.gpsMode.badgeInsetColor = self.functionOffColor;
    self.gpsMode.badgeText = @"FREE";
  }
  else if (value.isPositionHoldEnabled) {
    self.gpsMode.badgeInsetColor = self.gpsPHColor;
    self.gpsMode.badgeText = @"PH";
  }
  else if (value.isComingHomeEnabled) {
    self.gpsMode.badgeInsetColor = self.gpsCHColor;
    self.gpsMode.badgeText = @"CH";
  }
  else {
    self.gpsMode.badgeInsetColor = [UIColor redColor];
    self.gpsMode.badgeText = @"??";
  }

  self.flightTime.text = [NSString stringWithFormat:@"%02d:%02d", data->FlyingTime / 60, data->FlyingTime % 60];

  [self.gpsMode setNeedsDisplay];
}

- (void)updateBatteryView:(OsdValue *)value {

  IKMkNaviData *data = value.data.data;

  self.battery.text = [NSString stringWithFormat:@"%0.1f V ", data->UBat / 10.0];
  self.battery.textColor = value.isLowBat ? [UIColor whiteColor] : [UIColor blackColor];

  self.batteryView.innerBackgroundColor = value.isLowBat ? [UIColor redColor] : [UIColor whiteColor];

  self.current.text = [NSString stringWithFormat:@"%0.1f A", data->Current / 10.0];
  self.current.textColor = battery.textColor;

  self.usedCapacity.text = [NSString stringWithFormat:@"%d mAh", data->UsedCapacity];
  self.usedCapacity.textColor = self.battery.textColor;

  self.batteryIcon.image = value.isLowBat ? self.batteryLow : self.batteryOk;
}

- (void)updateHeightView:(OsdValue *)value {
  IKMkNaviData *data = value.data.data;

  if (data->Variometer == 0)
    self.variometer.text = @"—";
  else
    self.variometer.text = data->Variometer < 0 ? @"▾" : @"▴";


  self.heigth.text = [NSString stringWithFormat:@"%0.1f m", data->Altimeter / 20.0];
  self.heigthSetpoint.text = [NSString stringWithFormat:@"%0.1f m", data->SetpointAltitude / 20.0];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  motorLabels = [[NSArray alloc] initWithObjects:self.motorData1, self.motorData2, self.motorData3, self.motorData4,
                                                 self.motorData5, self.motorData6, self.motorData7, self.motorData8, nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)updateMotorData:(OsdValue *)value {
  NSUInteger i = 0;
  for (UILabel *l in motorLabels) {
    l.text = [value motorDataForIndex:i];
    i++;
  }
}

@end
