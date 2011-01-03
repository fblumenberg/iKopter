//
//  InAppSettingsPotiValueSpecifierCell.m
//  InAppSettingsTestApp
//
//  Created by Frank Blumenberg on 04.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InAppSettingsPotiValueSpecifierCell.h"


@implementation InAppSettingsPotiValueSpecifierCell

- (NSString *)getValueTitle{
 
  NSNumber* value = [self.setting getValue];
  
  int intValue=[value intValue];
  
  if( intValue <= 245 )
    return [NSString stringWithFormat:@"%@",value];
  
  return [NSString stringWithFormat:NSLocalizedString(@"Poti%d",@"Potiname"),256-intValue];
}

- (void)setUIValues{
  [super setUIValues];
  
  [self setTitle];
  [self setDetail:[self getValueTitle]];
}

- (void)setupCell{
  [super setupCell];
  
  [self setDisclosure:YES];
  self.canSelectCell = YES;
}

@end
