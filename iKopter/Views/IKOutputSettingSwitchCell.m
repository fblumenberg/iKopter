//
//  IKOutputSettingCell.m
//  InAppSettingsKitSampleApp
//
//  Created by mtg on 14.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IKOutputSettingSwitchCell.h"
#import "IASKSettingsReader.h"

@implementation IKOutputSettingSwitchCell

@synthesize output;
@synthesize label;
@synthesize activeSwitch;
@synthesize labelSwitch;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      self.labelSwitch.text = NSLocalizedString(@"Active", @"Output Setting activeLabel");
    }
    return self;
}

-(void)awakeFromNib{
  self.labelSwitch.text = NSLocalizedString(@"Active", @"Output Setting activeLabel");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)activeChanged:(id)sender {

  self.output.enabled = self.activeSwitch.isOn;
  if(activeSwitch.isOn){
    self.output.value = 0xAA;
  }
  else{
    self.output.value = 0;
  }
    
  [self.output sendActionsForControlEvents:UIControlEventValueChanged];
  [self.output setNeedsDisplay];
}

@end
