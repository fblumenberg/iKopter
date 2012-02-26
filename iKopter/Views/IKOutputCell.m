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
