//
// Copyright 2010 Itty Bitty Apps Pty Ltd
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import <IBAForms/IBAFormConstants.h>
#import "SettingsFieldStyle.h"


@implementation SettingsFieldStyleText

- (id)init {
  self = [super init];
  if (self) {
    self.labelTextColor = [UIColor blackColor];
    self.labelFont = [UIFont boldSystemFontOfSize:18];
    self.labelTextAlignment = UITextAlignmentLeft;
    self.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 90, IBAFormFieldLabelHeight);
    
    self.valueTextAlignment = UITextAlignmentLeft;
    self.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
    self.valueFont = [UIFont systemFontOfSize:16];
    self.valueFrame = CGRectMake(110, 13, 200, IBAFormFieldValueHeight);  }
  return self;
}

@end

@implementation SettingsFieldStyle

- (id)init {
  self = [super init];
  if (self) {
		self.labelTextColor = [UIColor blackColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 190, IBAFormFieldLabelHeight);
    self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;

		self.valueTextAlignment = UITextAlignmentLeft;
		self.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
		self.valueFont = [UIFont systemFontOfSize:16];
		self.valueFrame = CGRectMake(210, 13, 100, IBAFormFieldValueHeight);
    self.valueAutoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
  }
  return self;
}

@end

@implementation SettingsFieldStyleDisabled

- (id)init {
  self = [super init];
  if (self) {
		self.labelTextColor = [UIColor grayColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 190, IBAFormFieldLabelHeight);
    self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;

		self.valueTextAlignment = UITextAlignmentLeft;
		self.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
		self.valueFont = [UIFont systemFontOfSize:16];
		self.valueFrame = CGRectMake(210, 13, 100, IBAFormFieldValueHeight);
  }
  return self;
}

@end

@implementation SettingsFieldStyleSwitch

- (id)init {
  self = [super init];
  if (self) {
		self.labelTextColor = [UIColor blackColor];
		self.labelFont = [UIFont boldSystemFontOfSize:18];
		self.labelTextAlignment = UITextAlignmentLeft;
		self.labelFrame = CGRectMake(IBAFormFieldLabelX, 8, 210, IBAFormFieldLabelHeight);
		self.labelAutoresizingMask = UIViewAutoresizingFlexibleWidth;
    
		self.valueTextAlignment = UITextAlignmentLeft;
		self.valueTextColor = [UIColor colorWithRed:0.220 green:0.329 blue:0.529 alpha:1.0];
		self.valueFont = [UIFont systemFontOfSize:16];
		self.valueFrame = CGRectMake(160, 13, 150, IBAFormFieldValueHeight);
  }
  return self;
}

@end
