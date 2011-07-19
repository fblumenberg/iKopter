//
//  SettingsButtonStyle.m
//  iKopter
//
//  Created by Frank Blumenberg on 08.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsButtonStyle.h"


@implementation SettingsButtonStyle

- (id)init {
  self = [super init];
  if (self) {
    self.labelTextColor = [UIColor blackColor];
		self.labelFont = [UIFont boldSystemFontOfSize:14];
		self.labelFrame = CGRectMake(10, 8, 300, 30);
		self.labelTextAlignment = UITextAlignmentCenter;
		self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
  }
  return self;
}

@end
