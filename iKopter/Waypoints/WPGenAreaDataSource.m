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
#import "WPGenAreaDataSource.h"
#import "WPGenAreaViewController.h"

#import "IBAFormSection+MKParam.h"
#import "SettingsFieldStyle.h"


@interface WPGenAreaDataSource ()
@end

@implementation WPGenAreaDataSource

- (id)initWithModel:(id)aModel {
  if ((self = [super initWithModel:aModel])) {

    IBAStepperFormField *stepperField;

    ////////////////////////////////////////////////////////////////////////////////////////////////////
    IBAFormSection *configSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    configSection.formFieldStyle = [[[SettingsFieldStyleStepper alloc] init] autorelease];
    //------------------------------------------------------------------------------------------------------------------------
    [configSection addTextFieldForKeyPath:WPprefix title:NSLocalizedString(@"Prefix", @"WP Prefix")];

    stepperField = [configSection addStepperFieldForKeyPath:WPnoPointsX title:NSLocalizedString(@"#WP-X", @"WP Numbers")];
    stepperField.maximumValue = 100;
    stepperField.minimumValue = 0;

    stepperField = [configSection addStepperFieldForKeyPath:WPnoPointsY title:NSLocalizedString(@"#WP-Y", @"WP Numbers")];
    stepperField.maximumValue = 100;
    stepperField.minimumValue = 0;

    [self addAttributeSection];
  }
  return self;
}

@end
