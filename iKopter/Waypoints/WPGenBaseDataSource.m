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

#import "WPGenBaseDataSource.h"

#import "WPCamAngleTransformer.h"
#import "SettingsFieldStyle.h"
#import "IBAFormSection+MKParam.h"

@interface WPGenBaseDataSource ()
@end

@implementation WPGenBaseDataSource

@synthesize delegate;

- (id)initWithModel:(id)aModel {
  if ((self = [super initWithModel:aModel])) {

  }
  return self;
}

- (void)addAttributeSection {

  IBAStepperFormField *stepperField;

  IBAFormSection *clearSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
  clearSection.formFieldStyle = [[[SettingsFieldStyleStepper alloc] init] autorelease];
  //------------------------------------------------------------------------------------------------------------------------
  [clearSection addSwitchFieldForKeyPath:@"clearWpList"
                                   title:NSLocalizedString(@"Clear Waipoints", @"WPclearWpList title") style:[SettingsFieldStyleSwitch style]];

  ////////////////////////////////////////////////////////////////////////////////////////////////////

  IBAFormSection *attributeSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
  attributeSection.formFieldStyle = [[[SettingsFieldStyleStepper alloc] init] autorelease];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"altitude"
                                                        title:NSLocalizedString(@"Altitude", @"WP Altitude title") valueTransformer:nil];

  stepperField.maximumValue = 500;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"heading"
                                                        title:NSLocalizedString(@"Heading", @"WP Heading title") valueTransformer:nil];

  stepperField.maximumValue = 360;
  stepperField.minimumValue = -100;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"toleranceRadius"
                                                        title:NSLocalizedString(@"Radius", @"WP toleranceRadius title") valueTransformer:nil];

  stepperField.maximumValue = 100;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"holdTime"
                                                        title:NSLocalizedString(@"HaltTime", @"WP holdTime title") valueTransformer:nil];

  stepperField.maximumValue = 3600;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"wpEventChannelValue"
                                                        title:NSLocalizedString(@"Event", @"WP event title") valueTransformer:nil];

  stepperField.maximumValue = 255;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"altitudeRate"
                                                        title:NSLocalizedString(@"Climb rate", @"WP event title") valueTransformer:nil];

  stepperField.maximumValue = 255;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"speed"
                                                        title:NSLocalizedString(@"Speed", @"WP event title") valueTransformer:nil];

  stepperField.maximumValue = 255;
  stepperField.minimumValue = 0;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
  stepperField = [[IBAStepperFormField alloc] initWithKeyPath:@"camAngle"
                                                        title:NSLocalizedString(@"Camera nick angle", @"WP event title") valueTransformer:nil];

  stepperField.displayValueTransformer = [WPCamAngleTransformer instance];
  stepperField.maximumValue = 254;
  stepperField.minimumValue = -1;

  [attributeSection addFormField:[stepperField autorelease]];
  //------------------------------------------------------------------------------------------------------------------------
//  [attributeSection addFormField:[[[IBABooleanFormField alloc] initWithKeyPath:@"cameraNickControl"
//                                                                         title:NSLocalizedString(@"Camera nick control", @"cameraNickControl title")] autorelease]];

}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  [self.delegate dataSource:self];
  NSLog(@"%@", [self.model description]);
}

@end
