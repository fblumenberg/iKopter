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

    CGRect frame = CGRectMake(126.0, 20.0, kUIProgressBarWidth, kUIProgressBarHeight);
    progressBar = [[UIProgressView alloc] initWithFrame:frame];
    progressBar.progressViewStyle = UIProgressViewStyleDefault;
    progressBar.progress = 0.5;    // Initialization code
    
    [self.contentView addSubview:progressBar];
  }
  return self;
}

- (void)dealloc {
  
  [progressBar release];
  
  [super dealloc];
}

-(void)setChannelValue:(int16_t)value {
  
  progressBar.progress = (value+125)/250.0f;
}



@end
