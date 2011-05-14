//
//  MixerTableViewCell.m
//  iKopter
//
//  Created by Frank Blumenberg on 03.07.10.
//  Copyright 2010 de.frankblumenberg. All rights reserved.
//

#import "MixerTableViewCell.h"

#define TABLE_CELL_IDENTIFIER                   @"Mixer Table Cell Identifier"

@implementation MixerTableViewCell

@synthesize cellLabel;
@synthesize cellTextGas;
@synthesize cellTextNick;
@synthesize cellTextRoll;
@synthesize cellTextYaw;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
  [cellLabel release];
  [cellTextGas release];
  [cellTextNick release];
  [cellTextRoll release];
  [cellTextYaw release];
  [super dealloc];
}

+ (NSString *)reuseIdentifier
{
  return (NSString *)TABLE_CELL_IDENTIFIER;
}
- (NSString *)reuseIdentifier
{
  return [[self class] reuseIdentifier];
}


-(IBAction) exitEditing:(id)sender {
  NSLog(@"exit editing");
  [sender resignFirstResponder];
}

@end
