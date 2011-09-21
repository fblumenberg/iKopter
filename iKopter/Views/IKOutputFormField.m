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

#import "IKOutputFormField.h"
#import "IKOutputSetting.h"

@interface IKOutputFormField () 
- (void)switchValueChanged:(id)sender;
@end


@implementation IKOutputFormField

@synthesize settingCell = settingsCell_;

- (void)dealloc {
	IBA_RELEASE_SAFELY(settingsCell_);
	
	[super dealloc];
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title valueTransformer:(NSValueTransformer *)valueTransformer {
	if ((self = [super initWithKeyPath:keyPath title:title valueTransformer:valueTransformer])) {
	}
	
	return self;	
}

- (id)initWithKeyPath:(NSString *)keyPath title:(NSString *)title {
	return [self initWithKeyPath:keyPath title:title valueTransformer:nil] ;
}


#pragma mark -
#pragma mark Cell management

- (IBAFormFieldCell *)cell {
    IBAFormFieldCell *cell = nil;
    
    cell = [self settingCell];
    return cell;
}

- (IKOutputCell *)settingCell {
    if (settingsCell_ == nil) {
        settingsCell_ = [[IKOutputCell alloc] initWithFormFieldStyle:self.formFieldStyle 
                                                   reuseIdentifier:@"IKOutputCell"
                                                         validator:self.validator];
        
        [settingsCell_.settingControl addTarget:self action:@selector(switchValueChanged:) 
                             forControlEvents:UIControlEventValueChanged];
    }
    
    return settingsCell_;
}


- (void)updateCellContents {
    self.settingCell.label.text = self.title;
    self.settingCell.settingControl.value =  [[self formFieldValue] integerValue];
}

- (void)switchValueChanged:(id)sender {
    if (sender == self.settingCell.settingControl) {
        [self setFormFieldValue:[NSNumber numberWithInteger:self.settingCell.settingControl.value]];
    }
}

@end
