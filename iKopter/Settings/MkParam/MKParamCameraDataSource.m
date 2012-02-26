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
#import "MKParamCameraDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamCameraDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior {
  self = [super initWithModel:aModel];
  if (self) {

    IBAFormSection *paramSection = nil;
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Nick", @"MKParam Camera") footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"ServoNickControl" title:NSLocalizedString(@"Servo control", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoNickComp" title:NSLocalizedString(@"Compensation", @"MKParam Camera")];
    [paramSection addSwitchFieldForKeyPath:@"ServoCompInvert_NICK" title:NSLocalizedString(@"Invert direction", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoNickMin" title:NSLocalizedString(@"Min", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoNickMax" title:NSLocalizedString(@"Max", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoFilterNick" title:NSLocalizedString(@"Filter", @"MKParam Camera")];

    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Roll", @"MKParam Camera") footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addPotiFieldForKeyPath:@"ServoRollControl" title:NSLocalizedString(@"Servo control", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoRollComp" title:NSLocalizedString(@"Compensation", @"MKParam Camera")];
    [paramSection addSwitchFieldForKeyPath:@"ServoCompInvert_ROLL" title:NSLocalizedString(@"Invert direction", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoRollMin" title:NSLocalizedString(@"Min", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoRollMax" title:NSLocalizedString(@"Max", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoFilterRoll" title:NSLocalizedString(@"Filter", @"MKParam Camera")];

    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    [paramSection addNumberFieldForKeyPath:@"ServoNickRefresh" title:NSLocalizedString(@"Servo refresh rate", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"ServoManualControlSpeed" title:NSLocalizedString(@"Manual control speed", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"Servo3" title:NSLocalizedString(@"Servo 3", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"Servo4" title:NSLocalizedString(@"Servo 4", @"MKParam Camera")];
    [paramSection addNumberFieldForKeyPath:@"Servo5" title:NSLocalizedString(@"Servo 5", @"MKParam Camera")];
  }

  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
