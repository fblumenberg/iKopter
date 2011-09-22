//
//  SettingsButtonStyle.m
//  iKopter
//
//  Created by Frank Blumenberg on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsButtonStyle.h"
#import <IBAForms/IBAFormFieldStyle.h>
#import <IBAForms/IBAFormConstants.h>


@implementation SettingsButtonStyle

- (id)init {
  self = [super init];
  if (self) {
    self.labelTextColor = [UIColor blackColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelFrame = CGRectMake(10, 8, 300, 30);
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

@end

@implementation SettingsButtonStyleDisabled

- (id)init {
  self = [super init];
  if (self) {
    self.labelTextColor = [UIColor grayColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelFrame = CGRectMake(10, 8, 300, 30);
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

@end

@implementation SettingsButtonIndicatorStyle

- (id)init {
  self = [super init];
  if (self) {
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  return self;
}

@end


