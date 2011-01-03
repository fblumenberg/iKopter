//
//  InAppSettingsPotiValueController.h
//  MK4PhoneNav
//
//  Created by Frank Blumenberg on 05.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettings.h"


@interface InAppSettingsPotiValueController : UIViewController<InAppSettingsChildPane, UITextFieldDelegate> {

  InAppSettingsSpecifier* setting;

  UITextField *numberField;
  UILabel     *sliderLabel;
  UISwitch    *potiSwitch;

	UIPickerView *potiPicker;
  NSArray	*pickerData;
}

@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, retain) InAppSettingsSpecifier* setting;

@property (nonatomic, retain) IBOutlet	UIPickerView *potiPicker;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet UILabel *sliderLabel;
@property (nonatomic, retain) IBOutlet UISwitch *potiSwitch;

- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)toggleControls:(id)sender;

@end
