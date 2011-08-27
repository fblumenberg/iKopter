//
//  BaseOsdViewController.m
//  iKopter
//
//  Created by Frank Blumenberg on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

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


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.gpsOkColor=[UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0];
      self.functionOffColor=[UIColor colorWithHexString:@"#E6E6E6" andAlpha:1.0];
      self.functionOnColor=[UIColor blueColor];
      
      self.gpsPHColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:1.0];
      self.gpsCHColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
      
      self.gpsSateliteOk = [UIImage imageNamed:@"satelite.png"];
      self.gpsSateliteErr=[self.gpsSateliteOk imageTintedWithColor:[UIColor redColor]];
      
      
      self.batteryOk = [UIImage imageNamed:@"battery.png"];
      self.batteryLow=[self.batteryOk imageTintedWithColor:[UIColor whiteColor]];

    }
    return self;
}

- (void)dealloc {
  self.satelites=nil;
  self.careFree=nil;
  self.altitudeControl=nil;
  self.gpsMode=nil;
  
  self.flightTime=nil;
  
  self.gpsOkColor=nil;
  self.functionOffColor=nil;
  self.functionOnColor=nil;
  self.gpsPHColor=nil;
  self.gpsCHColor=nil;
  
  self.batteryView=nil;
  self.gpsSatelite=nil;
  self.batteryOk=nil;
  self.batteryLow=nil;
  
  self.batteryIcon=nil;
  self.gpsSateliteOk=nil;
  self.gpsSateliteErr=nil;
  
  self.heigth=nil;
  self.variometer=nil;
  self.heigthSetpoint=nil;
  self.battery=nil;
  self.current=nil;
  self.usedCapacity=nil;
  
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void) updateViewWithOrientation: (UIInterfaceOrientation) orientation {
  
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
  
  self.altitudeControl.badgeInsetColor=self.functionOffColor;
  [self.altitudeControl autoBadgeSizeWithString:@"ALT"];
  
  self.careFree.badgeInsetColor=self.functionOffColor;
  [self.careFree autoBadgeSizeWithString:@"ALT"];
  
  self.gpsMode.badgeInsetColor=self.functionOffColor;
  [self.gpsMode autoBadgeSizeWithString:@"FREE"];

}

- (void) updateStateView:(OsdValue*)value {
  IKMkNaviData*data=value.data.data;
  
  self.gpsSatelite.image= value.isGpsOk?self.gpsSateliteOk:self.gpsSateliteErr;
  self.satelites.badgeInsetColor = value.isGpsOk?self.gpsOkColor:[UIColor redColor];
  [self.satelites autoBadgeSizeWithString:[NSString stringWithFormat:@"%d",data->SatsInUse]];
  
  self.altitudeControl.badgeInsetColor=value.isAltControlOn?self.functionOnColor:self.functionOffColor;
  self.altitudeControl.badgeText=@"Alt";
  [self.altitudeControl setNeedsDisplay];
  
  self.careFree.badgeInsetColor=value.isCareFreeOn?self.functionOnColor:self.functionOffColor;
  self.careFree.badgeText=@"CF";
  [self.careFree setNeedsDisplay];
  
  if(value.isFreeModeEnabled){
    self.gpsMode.badgeInsetColor = self.functionOffColor;
    self.gpsMode.badgeText=@"FREE";    
  }
  else if(value.isPositionHoldEnabled){
    self.gpsMode.badgeInsetColor = self.gpsPHColor;
    self.gpsMode.badgeText=@"PH";    
  }
  else if(value.isComingHomeEnabled){
    self.gpsMode.badgeInsetColor = self.gpsCHColor;
    self.gpsMode.badgeText=@"CH";    
  }
  else{
    self.gpsMode.badgeInsetColor = [UIColor redColor];
    self.gpsMode.badgeText=@"??";    
  }
  
  self.flightTime.text=[NSString stringWithFormat:@"%02d:%02d",data->FlyingTime/60,data->FlyingTime%60];

  [self.gpsMode setNeedsDisplay];
}

- (void) updateBatteryView:(OsdValue*)value {
  
  IKMkNaviData*data=value.data.data;

  self.battery.text=[NSString stringWithFormat:@"%0.1f V ",data->UBat/10.0];    
  self.battery.textColor=value.isLowBat?[UIColor whiteColor]:[UIColor blackColor];
  
  self.batteryView.innerBackgroundColor = value.isLowBat?[UIColor redColor]:[UIColor whiteColor];
  
  self.current.text=[NSString stringWithFormat:@"%0.1f A",data->Current/10.0];
  self.current.textColor = battery.textColor;
  
  self.usedCapacity.text=[NSString stringWithFormat:@"%d mAh",data->UsedCapacity];  
  self.usedCapacity.textColor = self.battery.textColor;
  
  self.batteryIcon.image = value.isLowBat?self.batteryLow:self.batteryOk;
}

- (void) updateHeightView:(OsdValue*)value {
  IKMkNaviData*data=value.data.data;

  if(data->Variometer==0)
    self.variometer.text=@"—";
  else
    self.variometer.text=data->Variometer<0?@"▾":@"▴";
  
  
  self.heigth.text=[NSString stringWithFormat:@"%0.1f m",data->Altimeter/20.0];  
  self.heigthSetpoint.text=[NSString stringWithFormat:@"%0.1f m",data->SetpointAltitude/20.0];  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
