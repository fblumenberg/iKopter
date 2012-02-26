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
#import "MKParamNaviControlDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamNaviControlDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior {
  self = [super initWithModel:aModel];
  if (self) {

    IBAFormFieldStyle *switchStyle = [[[SettingsFieldStyleSwitch alloc] init] autorelease];

    IBAFormSection *paramSection = nil;
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addSwitchFieldForKeyPath:@"GlobalConfig_GPS_AKTIV" title:NSLocalizedString(@"Enable GPS", @"MKParam NaviCtrl") style:switchStyle];

    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"NaviGpsModeControl" title:NSLocalizedString(@"GPS Mode control", @"MKParam NaviCtrl")];
    if (((IKParamSet *)aModel).Revision.integerValue >= 88){
      [paramSection addSwitchFieldForKeyPath:@"ExtraConfig_GPS_AID" title:NSLocalizedString(@"Dynamic PH", @"MKParam NaviCtrl") style:switchStyle];
      if (((IKParamSet *)aModel).Revision.integerValue >= 90){
        [paramSection addSwitchFieldForKeyPath:@"GlobalConfig3_CFG3_DPH_MAX_RADIUS"
                                         title:NSLocalizedString(@"Use GPS max. raduis for dPH ", @"MKParam NaviCtrl") style:switchStyle];
      }
      [paramSection addPotiFieldForKeyPath:@"ComingHomeAltitude" title:NSLocalizedString(@"CH Altitude", @"MKParam NaviCtrl")];
    }
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"NaviGpsGain" title:NSLocalizedString(@"GPS Gain", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviStickThreshold" title:NSLocalizedString(@"GPS stick threshold", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsMinSat" title:NSLocalizedString(@"GPS min. Sat", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsP" title:NSLocalizedString(@"GPS-P", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsPLimit" title:NSLocalizedString(@"GPS-P limit", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsI" title:NSLocalizedString(@"GPS-I", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsILimit" title:NSLocalizedString(@"GPS-I limit", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsD" title:NSLocalizedString(@"GPS-D", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviGpsDLimit" title:NSLocalizedString(@"GPS-D limit", @"MKParam NaviCtrl")];

    [paramSection addPotiFieldForKeyPath:@"NaviGpsACC" title:NSLocalizedString(@"GPS ACC", @"MKParam NaviCtrl")];
    [paramSection addPotiFieldForKeyPath:@"NaviAccCompensation" title:NSLocalizedString(@"GPS ACC comp.", @"MKParam NaviCtrl")];
    [paramSection addPotiFieldForKeyPath:@"NaviWindCorrection" title:NSLocalizedString(@"GPS wind corr.", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviOperatingRadius" title:NSLocalizedString(@"GPS max. radius", @"MKParam NaviCtrl")];

    [paramSection addPotiFieldForKeyPath:@"NaviAngleLimitation" title:NSLocalizedString(@"GPS angle limit", @"MKParam NaviCtrl")];
    [paramSection addNumberFieldForKeyPath:@"NaviPH_LoginTime" title:NSLocalizedString(@"PH login time", @"MKParam NaviCtrl")];
  }

  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
