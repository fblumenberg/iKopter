//
// Copyright 2010 Itty Bitty Apps Pty Ltd
// 
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this 
// file except in compliance with the License. You may obtain a copy of the License at 
// 
// http://www.apache.org/licenses/LICENSE-2.0 
// 
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF 
// ANY KIND, either express or implied. See the License for the specific language governing
// permissions and limitations under the License.
//

#import "IBAStepperFormField.h"


@interface IBAStepperFormField ()
- (void)switchValueChanged:(id)sender;
@end


@implementation IBAStepperFormField {
@private
  double _value;
  double _minimumValue;
  double _maximumValue;
  double _stepValue;
  BOOL _autorepeat;
  BOOL _wraps;
  BOOL _continuous;
}

- (void)setValue:(double)value {

  _value = value;
  if ([_stepperCell.stepperControl isKindOfClass:[UIStepper class]])
    ((UIStepper *) _stepperCell.stepperControl).value = value;
  else
    ((BFStepper *) _stepperCell.stepperControl).value = value;
}

- (double)value {
  NSAssert(_stepperCell != nil, @"Cell must exist");
  if ([_stepperCell.stepperControl isKindOfClass:[UIStepper class]])
    return ((UIStepper *) _stepperCell.stepperControl).value;

  return ((BFStepper *) _stepperCell.stepperControl).value;
}

@synthesize stepperCell =_stepperCell;
@synthesize minimumValue = _minimumValue;
@synthesize maximumValue = _maximumValue;
@synthesize stepValue = _stepValue;
@synthesize autorepeat = _autorepeat;
@synthesize wraps = _wraps;
@synthesize displayValueTransformer = _displayValueTransformer;
@synthesize continuous = _continuous;
- (void)dealloc {
  IBA_RELEASE_SAFELY(_stepperCell);
  
  self.displayValueTransformer = nil;
  
  [super dealloc];
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer {
  if ((self = [super initWithKeyPath:keyPath title:title valueTransformer:valueTransformer])) {
    _value = 0;
    _maximumValue = 100;
    _minimumValue = 0;
    _stepValue = 1;
    _autorepeat = YES;
    _wraps = NO;
    _continuous = YES;
  }

  return self;
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title {
  return [self initWithKeyPath:keyPath title:title valueTransformer:nil];
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {

  if (_stepperCell == nil) {
    _stepperCell = [[IBAStepperCell alloc] initWithFormFieldStyle:self.formFieldStyle
                                                  reuseIdentifier:@"IBAStepperCell"
                                                        validator:self.validator];

    if ([_stepperCell.stepperControl isKindOfClass:[UIStepper class]]) {
      ((UIStepper *) _stepperCell.stepperControl).value = _value;
      ((UIStepper *) _stepperCell.stepperControl).minimumValue = _minimumValue;
      ((UIStepper *) _stepperCell.stepperControl).maximumValue = _maximumValue;
      ((UIStepper *) _stepperCell.stepperControl).stepValue = _stepValue;
      ((UIStepper *) _stepperCell.stepperControl).autorepeat = _autorepeat;
      ((UIStepper *) _stepperCell.stepperControl).wraps = _wraps;
      ((UIStepper *) _stepperCell.stepperControl).continuous = _continuous;
    }
    else {
      ((BFStepper *) _stepperCell.stepperControl).value = _value;
      ((BFStepper *) _stepperCell.stepperControl).minimumValue = _minimumValue;
      ((BFStepper *) _stepperCell.stepperControl).maximumValue = _maximumValue;
      ((BFStepper *) _stepperCell.stepperControl).stepValue = _stepValue;
      ((BFStepper *) _stepperCell.stepperControl).autorepeat = _autorepeat;
      ((BFStepper *) _stepperCell.stepperControl).wraps = _wraps;
      ((BFStepper *) _stepperCell.stepperControl).continuous = _continuous;
    }

    [_stepperCell.stepperControl addTarget:self action:@selector(switchValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
  }
  return _stepperCell;
}

- (void)updateCellContents {
  self.stepperCell.label.text = self.title;
  self.value = [[self formFieldValue] integerValue];
  if( self.displayValueTransformer)
    self.stepperCell.valueLabel.text = [[self.displayValueTransformer transformedValue:[NSNumber numberWithInteger:(NSInteger) self.value]] description];
  else
    self.stepperCell.valueLabel.text = [NSString stringWithFormat:@"%d", (NSInteger) self.value];
}

- (void)switchValueChanged:(id)sender {
  if (sender == self.stepperCell.stepperControl) {
    [self setFormFieldValue:[NSNumber numberWithInteger:(NSInteger) self.value]];
    
    if( self.displayValueTransformer)
      self.stepperCell.valueLabel.text = [[self.displayValueTransformer transformedValue:[NSNumber numberWithInteger:(NSInteger) self.value]] description];
    else
      self.stepperCell.valueLabel.text = [NSString stringWithFormat:@"%d", (NSInteger) self.value];
  }
}

@end
