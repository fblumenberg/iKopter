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
#import "MKParamCouplingDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamCouplingDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior {
  self = [super initWithModel:aModel];
  if (self) {

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addSwitchFieldForKeyPath:@"GlobalConfig_ACHSENKOPPLUNG_AKTIV"
                                     title:NSLocalizedString(@"Axis coupling", @"MKParam Coupling")];

    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"AchsKopplung1" title:NSLocalizedString(@"Yaw pos. feedbak", @"MKParam Coupling")];
    [paramSection addPotiFieldForKeyPath:@"AchsKopplung2" title:NSLocalizedString(@"Nick/Roll feedback", @"MKParam Coupling")];
    [paramSection addPotiFieldForKeyPath:@"CouplingYawCorrection" title:NSLocalizedString(@"Yaw correction", @"MKParam Coupling")];
  }

  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
