// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////


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
