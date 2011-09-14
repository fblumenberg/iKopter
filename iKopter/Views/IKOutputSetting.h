//
//  IKOutputSetting.h
//  InAppSettingsKitSampleApp
//
//  Created by mtg on 14.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKOutputSetting : UIControl<NSCoding>

@property(nonatomic,readwrite) NSInteger value;
          
@property(nonatomic,retain) UIColor *insetColorOn;
@property(nonatomic,retain) UIColor *insetColorOff;
@property(nonatomic,retain) UIColor *frameColor;

@property(nonatomic,readwrite) BOOL doDrawFrame;
@property(nonatomic,readwrite) BOOL shining;

@property(nonatomic,readwrite) CGFloat cornerRoundness;

@property (nonatomic, retain) NSString *key;

@end
