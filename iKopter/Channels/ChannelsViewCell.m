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

#import "ChannelsViewCell.h"

@implementation ChannelsViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

    CGRect frame = self.contentView.frame;
    CGFloat height = frame.size.height;

    self.textLabel.frame = CGRectMake(20.0, 0.0, 100, height);
    self.detailTextLabel.frame = CGRectMake(20.0, 0.0, 100, height);

    frame = CGRectMake(128.0, 17, 135, 9);
    progressBar = [[UIProgressView alloc] initWithFrame:frame];
    progressBar.progressViewStyle = UIProgressViewStyleDefault;
    progressBar.progress = 0.5;    // Initialization code
    progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.contentView addSubview:progressBar];
  }
  return self;
}

- (void)dealloc {

  [progressBar release];

  [super dealloc];
}

- (void)setChannelValue:(int16_t)value {

  progressBar.progress = (value + 127) / 255.0f;
  self.detailTextLabel.text = [NSString stringWithFormat:@"%d", value + 127];
}


@end
