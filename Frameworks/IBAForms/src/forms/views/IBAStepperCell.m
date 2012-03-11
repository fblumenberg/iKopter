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

#import "IBAStepperCell.h"
#import "IBAFormConstants.h"

@implementation IBAStepperCell

@synthesize stepperControl = stepperControl_;
@synthesize valueLabel = _valueLabel;



- (void)dealloc {
	IBA_RELEASE_SAFELY(stepperControlUI_);
	IBA_RELEASE_SAFELY(stepperControlBF_);
	IBA_RELEASE_SAFELY(_valueLabel);
  
	[super dealloc];
}

-(id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier validator:(IBAInputValidatorGeneric *)valueValidator
{
  if ((self = [super initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:valueValidator])) {
    
		stepperControlUI_ = [[UIStepper alloc] initWithFrame:CGRectZero];
    if (stepperControlUI_) {
      
      [self.cellView addSubview:stepperControlUI_];
      stepperControlUI_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
      stepperControlUI_.frame = CGRectMake(style.valueFrame.origin.x + style.valueFrame.size.width - stepperControlUI_.bounds.size.width,
                                           ceil((self.bounds.size.height - stepperControlUI_.bounds.size.height)/2),
                                           stepperControlUI_.bounds.size.width,
                                           stepperControlUI_.bounds.size.height);
      stepperControl_ = stepperControlUI_;
    }
    else {
      stepperControlBF_ = [[BFStepper alloc] initWithFrame:CGRectZero];
      [self.cellView addSubview:stepperControlBF_];
      stepperControlBF_.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
      stepperControlBF_.frame = CGRectMake(style.valueFrame.origin.x + style.valueFrame.size.width - stepperControlBF_.bounds.size.width,
                                           ceil((self.bounds.size.height - stepperControlBF_.bounds.size.height)/2),
                                           stepperControlBF_.bounds.size.width,
                                           stepperControlBF_.bounds.size.height);
      stepperControl_ = stepperControlBF_;
    }
    
    _valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.cellView addSubview:_valueLabel];
    _valueLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _valueLabel.frame = CGRectMake(stepperControl_.frame.origin.x-50,stepperControl_.frame.origin.y,
                                       40,
                                       stepperControl_.bounds.size.height);
    _valueLabel.textAlignment = UITextAlignmentRight;
    _valueLabel.font = style.valueFont;
    _valueLabel.textColor = style.valueTextColor;
    _valueLabel.adjustsFontSizeToFitWidth=YES;
    
    self.validator = valueValidator;
	}
  
  return self;
}

- (id)initWithFormFieldStyle:(IBAFormFieldStyle *)style reuseIdentifier:(NSString *)reuseIdentifier {
  return [self initWithFormFieldStyle:style reuseIdentifier:reuseIdentifier validator:nil];
}

@end
