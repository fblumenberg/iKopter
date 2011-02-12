//
//  ValueOsdViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 31.01.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OsdValue.h"
#import "CustomBadge.h"
#import "IKCompass.h"

@interface ValueOsdViewController : UIViewController<OsdValueDelegate> {

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
  
  IKCompass* compass;
 
  UIImageView* gpsSatelite;
  CustomBadge* satelites;
  UILabel* gpsMode;
  UILabel* gpsTarget;
  
  UILabel* flightTime;

  UIColor* gpsOkColor;

  UIImage* gpsSateliteOk;
  UIImage* gpsSateliteErr;
}

@property(retain) UIImage* gpsSateliteOk;
@property(retain) UIImage* gpsSateliteErr;

@property(retain) IBOutlet UILabel* heigth;
@property(retain) IBOutlet UILabel* heigthSetpoint;
@property(retain) IBOutlet UILabel* battery;
@property(retain) IBOutlet UILabel* current;
@property(retain) IBOutlet UILabel* usedCapacity;
@property(retain) IBOutlet UIImageView* gpsSatelite;
@property(retain) IBOutlet CustomBadge* satelites;
@property(retain) IBOutlet UILabel* gpsMode;
@property(retain) IBOutlet UILabel* gpsTarget;
@property(retain) IBOutlet UILabel* flightTime;
@property(retain) IBOutlet IKCompass* compass;
@property(retain) IBOutlet UILabel* attitude;
@property(retain) IBOutlet UILabel* speed;
@property(retain) IBOutlet UILabel* waypoint;
@property(retain) IBOutlet UILabel* targetPosDev;
@property(retain) IBOutlet UILabel* homePosDev;

@end
