//
//  IASKTextField.m
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2009:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import "IASKPotiTextField.h"

const int kCountryPickerTag = 3002;

@implementation IASKPotiTextField

@synthesize key=_key;
@synthesize value=_value;

- (void)awakeFromNib {
  [super awakeFromNib];
  
  _valuePicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
  _valuePicker.tag = kCountryPickerTag;
  _valuePicker.delegate = self;
  _valuePicker.dataSource = self;
  [_valuePicker setShowsSelectionIndicator:YES];
  self.inputView = _valuePicker;
}

- (void)dealloc {
  [_valuePicker release];	
  [_key release];
  [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated {
  [_valuePicker selectRow:self.value inComponent:0 animated:NO];
}

#pragma mark UIPickerViewDelegate

- (NSString *)titleForValue:(NSInteger)value  {
    if( value <= 245 )
        return [NSString stringWithFormat:@"%@",value];
      
  return [NSString stringWithFormat:NSLocalizedString(@"Poti%d",@"Potiname"),256-value];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
  if (pickerView.tag == kCountryPickerTag) {
    return [self titleForValue:row];
  }
  
  return @"Unknown title";
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  if (pickerView.tag == kCountryPickerTag) {
    self.value = row;
    self.text = [self titleForValue:row];
  }
}

#pragma mark -

#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
  if (pickerView.tag == kCountryPickerTag)
  {
    return 256;
  }

  return 0;
}

#pragma mark -

@end
