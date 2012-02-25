//
//  ChannelsViewCell.m
//  myKopter
//
//  Created by Frank Blumenberg on 16.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChannelsViewCell.h"

#define kUIProgressBarWidth		160.0
#define kUIProgressBarHeight	24.0

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

-(void)setChannelValue:(int16_t)value {
  
  progressBar.progress = (value+127)/255.0f;
  self.detailTextLabel.text = [NSString stringWithFormat:@"%d",value+127];
}



@end
