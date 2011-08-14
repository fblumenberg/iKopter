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


#import "ValueOsdViewController.h"
#import "UIImage+Tint.h"
#import "UIColor+ColorWithHex.h"
#import "InnerShadowView.h"

/////////////////////////////////////////////////////////////////////////////////
@interface ValueOsdViewController()

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation;
- (void) hideInfoViewAnimated;
- (void) hideInfoView:(BOOL)animated;
- (void) showInfoView;



@end

/////////////////////////////////////////////////////////////////////////////////
@implementation ValueOsdViewController

@synthesize batteryIcon;
@synthesize gpsMode;
@synthesize targetIcon;
@synthesize variometer;
@synthesize batteryView;
@synthesize gpsSateliteOk;
@synthesize gpsSateliteErr;
@synthesize heigth;
@synthesize heigthSetpoint;
@synthesize battery;
@synthesize current;
@synthesize usedCapacity;
@synthesize satelites;
@synthesize gpsSatelite;
//@synthesize gpsMode;
@synthesize gpsTarget;
@synthesize flightTime;
@synthesize compass;
@synthesize attitudeRoll;
@synthesize attitudeYaw;
@synthesize attitudeNick;
@synthesize attitude;
@synthesize speed;
@synthesize waypoint;
@synthesize targetPosDev;
@synthesize homePosDev;
@synthesize targetPosDevDistance;
@synthesize homePosDevDistance;
@synthesize targetTime;
@synthesize noData;
@synthesize altitudeControl;
@synthesize careFree;
@synthesize targetReached;
@synthesize targetReachedPending;
@synthesize batteryOk;
@synthesize batteryLow;
@synthesize infoView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    gpsOkColor=[[UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0]retain];
    functionOffColor=[[UIColor colorWithHexString:@"#E6E6E6" andAlpha:1.0]retain];
    functionOnColor=[UIColor blueColor];
    
    gpsPHColor = [[UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0] retain];
    gpsCHColor = [[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0] retain];
    
    
    self.gpsSateliteOk = [UIImage imageNamed:@"satelite.png"];
    self.gpsSateliteErr=[self.gpsSateliteOk imageTintedWithColor:[UIColor redColor]];
    
    self.targetReachedPending = [UIImage imageNamed:@"target.png"];
    self.targetReached=[self.targetReachedPending imageTintedWithColor:gpsOkColor];
    
    self.batteryOk = [UIImage imageNamed:@"battery.png"];
    self.batteryLow=[self.batteryOk imageTintedWithColor:[UIColor whiteColor]];
    
  }
  return self;
}

- (void)dealloc {
  [gpsOkColor release];
  [functionOffColor release];
  [gpsPHColor release];
  [gpsCHColor release];
  
  [attitudeYaw release];
  [attitudeRoll release];
  [attitudeYaw release];
  [attitudeNick release];
  [batteryView release];
  [targetPosDevDistance release];
  [homePosDevDistance release];
  [targetTime release];
  [gpsMode release];
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void)viewDidUnload
{
  [attitudeYaw release];
  attitudeYaw = nil;
  [self setAttitudeRoll:nil];
  [self setAttitudeYaw:nil];
  [self setAttitudeNick:nil];
  [self setBatteryView:nil];
  [self setTargetPosDevDistance:nil];
  [self setHomePosDevDistance:nil];
  [self setTargetTime:nil];
  [self setGpsMode:nil];
  [super viewDidUnload];
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateViewWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
  
  [self hideInfoViewAnimated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation  {
  
  NSString* nibName=@"ValueOsdViewController";
  
  if (UIInterfaceOrientationIsLandscape(orientation)){
    nibName = [nibName stringByAppendingString:@"Landscape"];
  }
  
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    nibName = [nibName stringByAppendingString:@"-iPad"];
  }
  
  [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
  
  
  if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
    self.altitudeControl.badgeScaleFactor=1.5;
    self.careFree.badgeScaleFactor=1.5;
    self.gpsMode.badgeScaleFactor=1.5;
    self.satelites.badgeScaleFactor=1.5;
  }
  else{
    self.altitudeControl.badgeScaleFactor=1.0;
    self.careFree.badgeScaleFactor=1.0;
    self.gpsMode.badgeScaleFactor=1.0;
    self.satelites.badgeScaleFactor=1.0;
  }
  
  self.altitudeControl.badgeInsetColor=functionOffColor;
  [self.altitudeControl autoBadgeSizeWithString:@"ALT"];
  
  self.careFree.badgeInsetColor=functionOffColor;
  [self.careFree autoBadgeSizeWithString:@"ALT"];
  
  self.gpsMode.badgeInsetColor=functionOffColor;
  [self.gpsMode autoBadgeSizeWithString:@"FREE"];
  
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  [self updateViewWithOrientation: orientation];
  
}

/////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Navigation bar Hideing 

- (void)showInfoView{
  
  CGRect frame = infoView.bounds;
  
  frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height - frame.size.height;
  
  self.infoView.hidden=NO;
  
  [UIView animateWithDuration:0.75
                   animations:^ {
                     self.infoView.frame = frame;
                   }];
  
  
  
  
}

- (void)hideInfoView:(BOOL)animated{
  
  CGRect frame = infoView.bounds;
  frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height;
  
  if(!animated){
    infoView.frame = frame;
    infoView.hidden=YES;
  }
  else{
    [UIView animateWithDuration:0.75
                     animations:^ {
                       self.infoView.frame = frame;
                     }
                     completion:^(BOOL finished) {
                       infoView.hidden=YES;
                     }];
  }
}

- (void)hideInfoViewAnimated{
  [self hideInfoView:YES];
}

- (void)hideInfoViewAfterDelay:(NSTimeInterval)delay
{
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideInfoViewAnimated) object:nil];
  qltrace(@"Calling performSelector with delay %f",delay);
  [self performSelector:@selector(hideInfoViewAnimated) withObject:nil afterDelay:delay];
}

#pragma mark OsdValueDelegate implementation
- (void) newValue:(OsdValue*)value {
  
  self.noData.hidden=YES;
  
  IKMkNaviData*data=value.data.data;
  
  if (data->Errorcode>0 && self.infoView.hidden) {
    infoView.text = [NSString stringWithFormat:NSLocalizedString(@"Error: %d", @"OSD NC error"),data->Errorcode];
    [self showInfoView];
  }
  else if(data->Errorcode==0 && !self.infoView.hidden) {
    [self hideInfoViewAnimated];
  }
  
  if(data->Variometer==0)
    variometer.text=@"—";
  else
    variometer.text=data->Variometer<0?@"▾":@"▴";
  
  
  heigth.text=[NSString stringWithFormat:@"%0.1f m",data->Altimeter/20.0];  
  heigthSetpoint.text=[NSString stringWithFormat:@"%0.1f",data->SetpointAltitude/20.0];  
  
  //-----------------------------------------------------------------------
  battery.text=[NSString stringWithFormat:@"%0.1f V ",data->UBat/10.0];    
  battery.textColor=value.isLowBat?[UIColor whiteColor]:[UIColor blackColor];
  
  batteryView.innerBackgroundColor = value.isLowBat?[UIColor redColor]:[UIColor whiteColor];
  
  current.text=[NSString stringWithFormat:@"%0.1f A",data->Current/10.0];
  current.textColor = battery.textColor;
  
  usedCapacity.text=[NSString stringWithFormat:@"%d mAh",data->UsedCapacity];  
  usedCapacity.textColor = battery.textColor;
  //-----------------------------------------------------------------------
  
  satelites.badgeInsetColor = value.isGpsOk?gpsOkColor:[UIColor redColor];
  [satelites autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",data->SatsInUse]];
  
  self.altitudeControl.badgeInsetColor=value.isAltControlOn?functionOnColor:functionOffColor;
  self.altitudeControl.badgeText=@"Alt";
  [self.altitudeControl setNeedsDisplay];
  
  self.careFree.badgeInsetColor=value.isCareFreeOn?functionOnColor:functionOffColor;
  self.careFree.badgeText=@"CF";
  [self.careFree setNeedsDisplay];
  
  
  attitude.text=[NSString stringWithFormat:@"%d° / %d° / %d°",data->CompassHeading,
                 data->AngleNick,
                 data->AngleRoll];
  
  attitudeYaw.text=[NSString stringWithFormat:@"%d°",data->CompassHeading];
  attitudeRoll.text=[NSString stringWithFormat:@"%d°",data->AngleRoll];
  attitudeNick.text=[NSString stringWithFormat:@"%d°",data->AngleNick];
  
  speed.text=[NSString stringWithFormat:@"%d km/h",(data->GroundSpeed*9)/250];
  
  waypoint.text=[NSString stringWithFormat:@"%d / %d (%d)",data->WaypointIndex,data->WaypointNumber,value.poiIndex];
  
  //-----------------------------------------------------------------------
  NSUInteger headingHome = (data->HomePositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  homePosDev.text=[NSString stringWithFormat:@"%d°",headingHome];
  homePosDevDistance.text=[NSString stringWithFormat:@"%d m",data->HomePositionDeviation.Distance / 10];
  
  NSUInteger headingTarget = (data->TargetPositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  if(value.isTargetReached && data->TargetHoldTime>0)
    targetTime.text=[NSString stringWithFormat:@"%d s",data->TargetHoldTime];
  else
    targetTime.text=@"";
  
  targetPosDev.text=[NSString stringWithFormat:@"%d°",headingTarget];
  targetPosDevDistance.text=[NSString stringWithFormat:@"%d m",data->TargetPositionDeviation.Distance / 10];
  
  compass.heading=data->CompassHeading;
  compass.homeDeviation=headingHome;
  compass.targetDeviation=headingTarget;
  //-----------------------------------------------------------------------
  
  gpsSatelite.image= value.isGpsOk?gpsSateliteOk:gpsSateliteErr;
  
  targetIcon.image = value.isTargetReached?targetReached:targetReachedPending;
  
  batteryIcon.image = value.isLowBat?batteryLow:batteryOk;
  
  if(value.isFreeModeEnabled){
    gpsMode.badgeInsetColor = functionOffColor;
    gpsMode.badgeText=@"FREE";    
  }
  else if(value.isPositionHoldEnabled){
    gpsMode.badgeInsetColor = gpsPHColor;
    gpsMode.badgeText=@"PH";    
  }
  else if(value.isComingHomeEnabled){
    gpsMode.badgeInsetColor = gpsCHColor;
    gpsMode.badgeText=@"CH";    
  }
  else{
    gpsMode.badgeInsetColor = [UIColor redColor];
    gpsMode.badgeText=@"??";    
  }
  
  [self.gpsMode setNeedsDisplay];
  
  flightTime.text=[NSString stringWithFormat:@"%02d:%02d",data->FlyingTime/60,data->FlyingTime%60];
  
  //  if(value.isTargetReached)
  //    gpsTarget.text=@"TARGET";
  //  else
  //    gpsTarget.text=@"";
}  

- (void) noDataAvailable {
  self.noData.hidden=NO;
}

@end
