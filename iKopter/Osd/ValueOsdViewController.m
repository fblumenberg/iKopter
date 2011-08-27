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

@synthesize attitudeIndicator;
@synthesize topSpeed;
@synthesize targetIcon;
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
@synthesize targetReached;
@synthesize targetReachedPending;
@synthesize waypointPOI;
@synthesize waypointCount;
@synthesize waypointIndex;
@synthesize infoView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.targetReachedPending = [UIImage imageNamed:@"target.png"];
    self.targetReached=[self.targetReachedPending imageTintedWithColor:self.gpsOkColor];
  }
  return self;
}

- (void)dealloc {
  [attitudeYaw release];
  [attitudeRoll release];
  [attitudeYaw release];
  [attitudeNick release];
  [targetPosDevDistance release];
  [homePosDevDistance release];
  [targetTime release];
  [attitudeIndicator release];
  [topSpeed release];
  [waypointPOI release];
  [waypointCount release];
  [waypointIndex release];
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
}

- (void)viewDidUnload
{
  attitudeYaw = nil;
  [self setAttitudeRoll:nil];
  [self setAttitudeYaw:nil];
  [self setAttitudeNick:nil];
  [self setBatteryView:nil];
  [self setTargetPosDevDistance:nil];
  [self setHomePosDevDistance:nil];
  [self setTargetTime:nil];
  [self setAttitudeIndicator:nil];
  [self setTopSpeed:nil];
  [self setWaypointPOI:nil];
  [self setWaypointCount:nil];
  [self setWaypointIndex:nil];
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
  
  [super updateViewWithOrientation:orientation];
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
  
  //-----------------------------------------------------------------------
  [self updateHeightView:value];
  //-----------------------------------------------------------------------
  [self updateBatteryView:value];
  //-----------------------------------------------------------------------
  [self updateStateView:value];
  //-----------------------------------------------------------------------
  attitude.text=[NSString stringWithFormat:@"%d° / %d° / %d°",data->CompassHeading,
                 data->AngleNick,
                 data->AngleRoll];
  
  attitudeYaw.text=[NSString stringWithFormat:@"%d°",data->CompassHeading];
  attitudeRoll.text=[NSString stringWithFormat:@"%d°",data->AngleRoll];
  attitudeNick.text=[NSString stringWithFormat:@"%d°",data->AngleNick];
  
  self.attitudeIndicator.pitch=-1*(value.data.data->AngleNick);
  self.attitudeIndicator.roll=-1*(value.data.data->AngleRoll);
  
  //-----------------------------------------------------------------------
  
  speed.text=[NSString stringWithFormat:@"%d km/h",(data->GroundSpeed*9)/250];
  topSpeed.text=[NSString stringWithFormat:@"%d m/s",(data->TopSpeed)/100];
  
  //-----------------------------------------------------------------------
  waypoint.text=[NSString stringWithFormat:@"%d / %d (%d)",data->WaypointIndex,data->WaypointNumber,value.poiIndex];
  waypointIndex.text=[NSString stringWithFormat:@"%d",data->WaypointIndex];
  waypointCount.text=[NSString stringWithFormat:@"/ %d",data->WaypointNumber];
  waypointPOI.text=[NSString stringWithFormat:@"%d",value.poiIndex];
  
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
  
  targetIcon.image = value.isTargetReached?targetReached:targetReachedPending;
  
  compass.heading=data->CompassHeading;
  compass.homeDeviation=headingHome;
  compass.targetDeviation=headingTarget;
  //-----------------------------------------------------------------------
  

}  

- (void) noDataAvailable {
  self.noData.hidden=NO;
}

@end
