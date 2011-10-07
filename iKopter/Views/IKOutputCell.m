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

#import "IKOutputCell.h"
#import "IKOutputSetting.h"

#import "IBAForms/IBAFormConstants.h"

@implementation IKOutputCell

@synthesize settingControl = settingControl_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(settingControl_);
  
	[super dealloc];
}

-(id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier validator:(IBAInputValidatorGeneric *)valueValidator
{
  if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:valueValidator])) {
    
    CGRect frame=self.cellView.frame;
    self.cellView.frame = CGRectMake(frame.origin.x, frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame)*2);;
    
    self.label.frame = CGRectMake(CGRectGetMinX(self.label.frame),CGRectGetMinY(self.label.frame),CGRectGetWidth(self.cellView.bounds)-20,CGRectGetHeight(self.label.frame));
    
		settingControl_ = [[IKOutputSetting alloc] initWithFrame:CGRectZero];
    
		[self.cellView addSubview:settingControl_];
		settingControl_.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
    settingControl_.frame = CGRectMake(10 , CGRectGetHeight(self.cellView.bounds)-44, CGRectGetWidth(self.cellView.bounds)-20, 40);
    self.validator = valueValidator;
	}
  
  return self;
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
  return [self initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:nil];
}

@end
