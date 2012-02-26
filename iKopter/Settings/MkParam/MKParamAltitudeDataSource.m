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
#import "MKParamAltitudeDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"
#import "MKParamPotiValueTransformer.h"
#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamAltitudeDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior {
  self = [super initWithModel:aModel];
  if (self) {

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    basicFieldSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    basicFieldSection.formFieldStyle.behavior = behavior;

    [basicFieldSection addSwitchFieldForKeyPath:@"GlobalConfig_HOEHENREGELUNG" title:NSLocalizedString(@"Enable altitude control", @"MKParam Altitude")];

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *mainSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    mainSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    mainSection.formFieldStyle.behavior = behavior;

    NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:
            NSLocalizedString(@"Vario altitude", @"MKParam Altitude"),
            NSLocalizedString(@"Height limitation", @"MKParam Altitude"),
            nil]];

    IBASingleIndexTransformer *transformer = [[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptions] autorelease];

    [mainSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"ExtraConfig_HEIGHT_LIMIT"
                                                                       title:NSLocalizedString(@"Control mode", @"MKParam Altitude") valueTransformer:transformer
                                                               selectionMode:IBAPickListSelectionModeSingle
                                                                     options:pickListOptions] autorelease]];

    [mainSection addSwitchFieldForKeyPath:@"GlobalConfig_HOEHEN_SCHALTER" title:NSLocalizedString(@"Switch for setpoint", @"MKParam Altitude")];
    [mainSection addSwitchFieldForKeyPath:@"GlobalConfig_HOEHEN_SCHALTER" title:NSLocalizedString(@"Acoustic vario", @"MKParam Altitude")];

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"MaxHoehe" title:NSLocalizedString(@"Setpoint", @"MKParam Altitude")];
    [paramSection addNumberFieldForKeyPath:@"Hoehe_MinGas" title:NSLocalizedString(@"Min. Gas", @"MKParam Altitude")];
    [paramSection addNumberFieldForKeyPath:@"Hoehe_HoverBand" title:NSLocalizedString(@"Hover variation", @"MKParam Altitude")];
    [paramSection addPotiFieldForKeyPath:@"Hoehe_P" title:NSLocalizedString(@"Altitude-P", @"MKParam Altitude")];
    [paramSection addPotiFieldForKeyPath:@"Hoehe_GPS_Z" title:NSLocalizedString(@"GPS-Z", @"MKParam Altitude")];
    [paramSection addPotiFieldForKeyPath:@"Luftdruck_D" title:NSLocalizedString(@"Barometric-D", @"MKParam Altitude")];
    [paramSection addPotiFieldForKeyPath:@"Hoehe_ACC_Wirkung" title:NSLocalizedString(@"Z-ACC", @"MKParam Altitude")];

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *paramSection2 = [self addSectionWithHeaderTitle:nil footerTitle:NSLocalizedString(@"0 - automatic / 127 - middle position", @"MKParam Altitude")];
    paramSection2.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection2.formFieldStyle.behavior = behavior;

    [paramSection2 addNumberFieldForKeyPath:@"Hoehe_Verstaerkung" title:NSLocalizedString(@"Gain/Rate", @"MKParam Altitude")];
    if (((IKParamSet *)aModel).Revision.integerValue >= 88)
    [paramSection2 addNumberFieldForKeyPath:@"MaxAltitude" title:NSLocalizedString(@"Max. Altitude", @"MKParam Altitude")];
    [paramSection2 addNumberFieldForKeyPath:@"Hoehe_StickNeutralPoint" title:NSLocalizedString(@"Stick neutral point", @"MKParam Altitude")];

  }

  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
