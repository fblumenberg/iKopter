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
    self.valueFrame = CGRectMake(110, 13, 200, IBAFormFieldValueHeight);
  }
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
