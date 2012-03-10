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

#import <IBAForms/IBAForms.h>
#import "WPGenCircleViewController.h"
#import "WPGenCircleDataSource.h"
#import "StringToNumberTransformer.h"
#import "SettingsButtonStyle.h"
#import "SettingsFieldStyle.h"

@interface WPGenCircleDataSource ()
@end

@implementation WPGenCircleDataSource

- (id)initWithModel:(id)aModel {
  if ((self = [super initWithModel:aModel])) {

    IBAStepperFormField* stepperField;
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    IBAFormSection *configSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    configSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    //------------------------------------------------------------------------------------------------------------------------

    stepperField = [[IBAStepperFormField alloc] initWithKeyPath:WPnoPoints
                                                      title:NSLocalizedString(@"#WP", @"WP Numbers")
                                           valueTransformer:nil];
    
    stepperField.maximumValue = 100;
    stepperField.minimumValue = 2;
    
    [configSection addFormField:[stepperField autorelease]];
    
    [configSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:WPclockwise
                                                                        title:NSLocalizedString(@"Clockwise", @"WPclockwise")] autorelease]];
    
    [configSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:WPclearWpList
                                                                        title:NSLocalizedString(@"Clear Waipoints", @"WPclearWpList title")] autorelease]];
    
    [self addAttributeSection];
  }
  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
