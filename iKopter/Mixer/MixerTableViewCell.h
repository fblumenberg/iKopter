//
//  MixerTableViewCell.h
//  iKopter
//
//  Created by Frank Blumenberg on 03.07.10.
//  Copyright 2010 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MixerTableViewCell : UITableViewCell {
  UILabel *cellLabel;
  UITextField *cellTextGas;
  UITextField *cellTextNick;
  UITextField *cellTextRoll;
  UITextField *cellTextYaw;
}

@property(nonatomic, retain) IBOutlet UILabel *cellLabel;
@property(nonatomic, retain) IBOutlet UITextField *cellTextGas;
@property(nonatomic, retain) IBOutlet UITextField *cellTextNick;
@property(nonatomic, retain) IBOutlet UITextField *cellTextRoll;
@property(nonatomic, retain) IBOutlet UITextField *cellTextYaw;

+ (NSString *)reuseIdentifier;
- (IBAction)exitEditing:(id)sender;

@end
