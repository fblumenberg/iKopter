//
//  IKOutputSettingCell.h
//  InAppSettingsKitSampleApp
//
//  Created by mtg on 14.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKOutputSetting.h"

@interface IKOutputSettingCell : UITableViewCell

@property (nonatomic, assign) IBOutlet IKOutputSetting *output;
@property (nonatomic, assign) IBOutlet UILabel *label;

@end
