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

#import "SettingsButtonStyle.h"

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


