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

/////////////////////////////////////////////////////////////////////////////////
@interface ValueOsdViewController()

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation;

@end

/////////////////////////////////////////////////////////////////////////////////
@implementation ValueOsdViewController

@synthesize gpsSateliteOk;
@synthesize gpsSateliteErr;
@synthesize heigth;
@synthesize heigthSetpoint;
@synthesize battery;
@synthesize current;
@synthesize usedCapacity;
@synthesize satelites;
@synthesize gpsSatelite;
@synthesize gpsMode;
@synthesize gpsTarget;
@synthesize flightTime;
@synthesize compass;
@synthesize attitude;
@synthesize speed;
@synthesize waypoint;
@synthesize targetPosDev;
@synthesize homePosDev;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.gpsSateliteOk = [UIImage imageNamed:@"gpsSat2.png"];
      self.gpsSateliteErr=[self.gpsSateliteOk imageTintedWithColor:[UIColor redColor]];
    }
    return self;
}


- (void)dealloc {
  [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  gpsOkColor=[[UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0]retain];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  [gpsOkColor release];
  gpsOkColor=nil;
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self updateViewWithOrientation:[UIApplication sharedApplication].statusBarOrientation];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation  {
  
  
  if ( UIInterfaceOrientationIsPortrait(orientation) ){
    [[NSBundle mainBundle] loadNibNamed:@"ValueOsdViewController" owner:self options:nil];
  }
  else if (UIInterfaceOrientationIsLandscape(orientation)){
    [[NSBundle mainBundle] loadNibNamed:@"ValueOsdViewControllerLandscape" owner:self options:nil];
  }

}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  [self updateViewWithOrientation: orientation];

}


#pragma mark OsdValueDelegate implementation
- (void) newValue:(OsdValue*)value {
  
  IKMkNaviData*data=value.data.data;
  
  heigth.text=[NSString stringWithFormat:@"%0.1f m",data->Altimeter/20.0];  
  heigthSetpoint.text=[NSString stringWithFormat:@"%0.1f",data->SetpointAltitude/20.0];  
  
  battery.text=[NSString stringWithFormat:@"%0.1f V",data->UBat/10.0];    
  current.text=[NSString stringWithFormat:@"%0.1f",data->Current/10.0];      
  usedCapacity.text=[NSString stringWithFormat:@"%d",data->UsedCapacity];  
  
  satelites.badgeInsetColor = value.isGpsOk?gpsOkColor:[UIColor redColor];
//  [satelites autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",data->SatsInUse]];
  satelites.badgeText=[NSString stringWithFormat:@"%d",data->SatsInUse];
  [satelites setNeedsDisplay];
  
  attitude.text=[NSString stringWithFormat:@"%d° %d° / %d°",data->CompassHeading,
                 data->AngleNick,
                 data->AngleRoll];
  speed.text=[NSString stringWithFormat:@"%d km/h",(data->GroundSpeed*9)/250];
  
  waypoint.text=[NSString stringWithFormat:@"%d / %d",data->WaypointIndex,data->WaypointNumber];
  
  NSUInteger headingHome = (data->HomePositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  homePosDev.text=[NSString stringWithFormat:@"%d° / %d m",headingHome,data->HomePositionDeviation.Distance / 10];
  
  NSUInteger headingTarget = (data->TargetPositionDeviation.Bearing + 360 - data->CompassHeading) % 360;
  targetPosDev.text=[NSString stringWithFormat:@"%d° / %d m",headingTarget,data->TargetPositionDeviation.Distance / 10];

  compass.heading=data->CompassHeading;
  compass.homeDeviation=headingHome;
  compass.targetDeviation=headingTarget;
 
  gpsSatelite.image= value.isGpsOk?gpsSateliteOk:gpsSateliteErr;
 
  if(value.isFreeModeEnabled)
    gpsMode.text=@"Free";    
  else if(value.isPositionHoldEnabled)
    gpsMode.text=@"Pos. Hold";    
  else if(value.isComingHomeEnabled)
    gpsMode.text=@"Coming Home";    
  else
    gpsMode.text=@"??";    
  
//  if(value.isTargetReached)
//    gpsTarget.text=@"TARGET";
//  else
//    gpsTarget.text=@"";
}  

@end
