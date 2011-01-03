//
//  InAppSettingsPotiValueController.m
//  MK4PhoneNav
//
//  Created by Frank Blumenberg on 05.05.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "InAppSettingsPotiValueController.h"


@implementation InAppSettingsPotiValueController

@synthesize setting;
@synthesize numberField;
@synthesize sliderLabel;
@synthesize potiSwitch;
@synthesize pickerData;
@synthesize potiPicker;

- (id) initWithSetting:(InAppSettingsSpecifier *)inputSetting {
  
  if ((self = [super initWithNibName:@"InAppSettingsPotiValueController" bundle:nil])) {
    self.setting=inputSetting;
    
    NSArray *array = [[NSArray alloc] initWithObjects:
                      @"Poti1", 
                      @"Poti2", 
                      @"Poti3", 
                      @"Poti4", 
                      @"Poti5", 
                      @"Poti6", 
                      @"Poti7", 
                      @"Poti8", 
                      nil];
    self.pickerData = array;
    [array release];
    
  }
  return self;
}


- (void) viewDidLoad {
  [super viewDidLoad];
  
  self.title = [self.setting localizedTitle];
}

- (void)viewWillAppear:(BOOL)animated {

  int value = [[setting getValue] intValue];
  if (value<248) {
    potiSwitch.on = NO;
    numberField.alpha = 1.0f;
    potiPicker.alpha = 0.0f;
    numberField.text =[NSString stringWithFormat:@"%d",value];
  }
  else {
    potiSwitch.on = YES;
    numberField.alpha = 0.0f;
    potiPicker.alpha = 1.0f;
    numberField.text =@"0";
    [potiPicker selectRow:255-value inComponent:0 animated:NO];
  }
}

-(void) viewWillDisappear:(BOOL)animated
{
  int value=0;
  if(potiSwitch.on)
  {
    int row = [potiPicker selectedRowInComponent:0];
    value = 255-row;
  }
  else 
  {
    value = [numberField.text intValue];
  }

  [setting setValue:[NSNumber numberWithInt:value]];
}

- (void) dealloc {
  [setting release];
  [numberField release];
  [sliderLabel release];
  [potiSwitch release];
  [pickerData release];
  [potiPicker release];
  [super dealloc];
}

- (id) getValue {
  return nil; 
}

- (void) setValue:(id)newValue {
  
}

- (IBAction)textFieldDoneEditing:(id)sender {
	[sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
	[numberField resignFirstResponder];	
  
}

- (IBAction)toggleControls:(id)sender {

  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  numberField.alpha = potiSwitch.on?0.0f:1.0f;
  potiPicker.alpha = potiSwitch.on?1.0f:0.0f;
  [UIView commitAnimations];	
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  self.numberField = nil;
  self.sliderLabel = nil;
  self.potiSwitch = nil;
  self.pickerData = nil;
  self.potiPicker = nil;
  [super viewDidUnload];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSMutableString* s = [textField.text mutableCopy];
  [s replaceCharactersInRange:range withString:string];

  int value = [s intValue];
  [s release];
  if (value <=245 ) {
    return YES;
  }
  return NO; 
}

#pragma mark -
#pragma mark Picker Data Source Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [pickerData count];
}
#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerData objectAtIndex:row];
}

@end
