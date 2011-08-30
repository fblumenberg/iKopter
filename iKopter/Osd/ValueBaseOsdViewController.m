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

#import "ValueBaseOsdViewController.h"
#import "UIImage+Tint.h"

#import "IKAttitudeIndicator.h"
#import "IKCompass.h"
#import "OsdValue.h"


@implementation ValueBaseOsdViewController

@synthesize targetPosDev;
@synthesize targetPosDevBearing;
@synthesize targetPosDevDistance;
@synthesize homePosDev;
@synthesize homePosDevBearing;
@synthesize homePosDevDistance;
@synthesize targetTime;
@synthesize targetIcon;

@synthesize targetReached;
@synthesize targetReachedPending;


@synthesize waypoint;
@synthesize waypointPOI;
@synthesize waypointCount;
@synthesize waypointIndex;

@synthesize attitudeRoll;
@synthesize attitudeYaw;
@synthesize attitudeNick;
@synthesize attitude;

@synthesize speed;
@synthesize topSpeed;

@synthesize compass;
@synthesize attitudeIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.targetReachedPending = [UIImage imageNamed:@"target.png"];
    self.targetReached=[self.targetReachedPending imageTintedWithColor:self.gpsOkColor];
  }
  return self;
}


- (void)dealloc {
  self.targetPosDev=nil;
  self.homePosDev=nil;
  self.targetPosDevDistance=nil;
  self.homePosDevDistance=nil;
  self.targetTime=nil;
  self.targetIcon=nil;
  
  self.targetReached=nil;
  self.targetReachedPending=nil;
  
  
  self.waypoint=nil;
  self.waypointPOI=nil;
  self.waypointCount=nil;
  self.waypointIndex=nil;
  
  self.attitudeRoll=nil;
  self.attitudeYaw=nil;
  self.attitudeNick=nil;
  self.attitude=nil;
  
  self.speed=nil;
  self.topSpeed=nil;
  
  self.attitudeIndicator=nil;
  self.compass=nil;

  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void) updateAttitueViews:(OsdValue*)value{
  IKMkNaviData*data=value.data.data;
  
  self.attitude.text=[NSString stringWithFormat:@"%d° / %d° / %d°",data->CompassHeading,
                      data->AngleNick,
                      data->AngleRoll];
  
  self.attitudeYaw.text=[NSString stringWithFormat:@"%d°",data->CompassHeading];
  self.attitudeRoll.text=[NSString stringWithFormat:@"%d°",data->AngleRoll];
  self.attitudeNick.text=[NSString stringWithFormat:@"%d°",data->AngleNick];
  
  self.attitudeIndicator.pitch=-1*(value.data.data->AngleNick);
  self.attitudeIndicator.roll=-1*(value.data.data->AngleRoll);
}

- (void) updateWaypointViews:(OsdValue*)value{
  IKMkNaviData*data=value.data.data;
  
  self.speed.text=[NSString stringWithFormat:@"%d km/h",(data->GroundSpeed*9)/250];
  self.topSpeed.text=[NSString stringWithFormat:@"%d m/s",(data->TopSpeed)/100];
}

- (void) updateTargetHomeViews:(OsdValue*)value{
  IKMkNaviData*data=value.data.data;

  NSUInteger headingHome = (data->HomePositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  self.homePosDevBearing.text=[NSString stringWithFormat:@"%d°",headingHome];
  self.homePosDevDistance.text=[NSString stringWithFormat:@"%d m",data->HomePositionDeviation.Distance / 10];

  self.homePosDev.text=[NSString stringWithFormat:@"%d° / %d m",headingHome,data->HomePositionDeviation.Distance / 10];
  
  NSUInteger headingTarget = (data->TargetPositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  if(value.isTargetReached && data->TargetHoldTime>0)
    self.targetTime.text=[NSString stringWithFormat:@"%d s",data->TargetHoldTime];
  else
    self.targetTime.text=@"";

  self.targetPosDev.text=[NSString stringWithFormat:@"%d° / %d m ",headingHome,data->TargetPositionDeviation.Distance / 10];
  self.targetPosDevBearing.text=[NSString stringWithFormat:@"%d°",headingTarget];
  self.targetPosDevDistance.text=[NSString stringWithFormat:@"%d m",data->TargetPositionDeviation.Distance / 10];
  
  self.targetIcon.image = value.isTargetReached?self.targetReached:self.targetReachedPending;
  
  self.compass.heading=data->CompassHeading;
  self.compass.homeDeviation=headingHome;
  self.compass.targetDeviation=headingTarget;

}

- (void) updateSpeedViews:(OsdValue*)value{
  IKMkNaviData*data=value.data.data;
 
  self.waypoint.text=[NSString stringWithFormat:@"%d / %d (%d)",data->WaypointIndex,data->WaypointNumber,value.poiIndex];
  self.waypointIndex.text=[NSString stringWithFormat:@"%d",data->WaypointIndex];
  self.waypointCount.text=[NSString stringWithFormat:@"/ %d",data->WaypointNumber];
  self.waypointPOI.text=[NSString stringWithFormat:@"%d",value.poiIndex];
}

@end
