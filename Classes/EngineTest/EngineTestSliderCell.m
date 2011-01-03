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

#import "EngineTestSliderCell.h"
#import "InAppSettingsConstants.h"


#define kUISliderWidth	160.0
#define kUISliderHeight	 24.0

@implementation EngineTestSliderCell

@synthesize valueSlider;

- (void)slideAction{
}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
  
  self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
  
  if(self) {

    CGRect frame = CGRectMake(126.0, 20.0, kUISliderWidth, kUISliderHeight);
    valueSlider = [[UISlider alloc] initWithFrame:frame];

    self.valueSlider.minimumValue = 0;
    self.valueSlider.maximumValue = 1;
    self.valueSlider.value = 0;
    
    CGRect valueSliderFrame = self.valueSlider.frame;
    valueSliderFrame.origin.y = (CGFloat)round((self.contentView.frame.size.height*0.5f)-(valueSliderFrame.size.height*0.5f));
    valueSliderFrame.origin.x = 85;
    valueSliderFrame.size.width = InAppSettingsScreenWidth-(InAppSettingsTotalTablePadding+InAppSettingsCellPadding+85);
    self.valueSlider.frame = valueSliderFrame;
    
    [self.valueSlider addTarget:self action:@selector(slideAction) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.valueSlider];

    self.detailTextLabel.hidden = YES;
  }
  return self;
}

- (void)dealloc{
    [valueSlider release];
    [super dealloc];
}

@end
