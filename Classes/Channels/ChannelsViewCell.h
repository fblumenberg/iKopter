//
//  ChannelsViewCell.h
//  myKopter
//
//  Created by Frank Blumenberg on 16.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ChannelsViewCell : UITableViewCell {

  UIProgressView* progressBar;
}

-(void)setChannelValue:(int16_t) value;

@end
