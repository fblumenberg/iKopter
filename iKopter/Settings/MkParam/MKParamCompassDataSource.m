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
#import "MKParamCompassDataSource.h"
#import "IBAFormSection+MKParam.h"
#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamCompassDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior {
  self = [super initWithModel:aModel];
  if (self) {

    //------------------------------------------------------------------------------------------------------------------------
    IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    basicFieldSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    basicFieldSection.formFieldStyle.behavior = behavior;

    [basicFieldSection addSwitchFieldForKeyPath:@"GlobalConfig_KOMPASS_AKTIV"
                                          title:NSLocalizedString(@"Compass active", @"MKParam Compass")];
    [basicFieldSection addSwitchFieldForKeyPath:@"GlobalConfig_KOMPASS_FIX"
                                          title:NSLocalizedString(@"Orientation fixed", @"MKParam Compass")];

    [basicFieldSection addNumberFieldForKeyPath:@"KompassWirkung"
                                          title:NSLocalizedString(@"Compass effect", @"MKParam Compass")];
  }

  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
  [super setModelValue:value forKeyPath:keyPath];

  NSLog(@"%@", [self.model description]);
}

@end
