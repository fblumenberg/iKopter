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
#import "MKParamStickDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamStickDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior{
	if (self = [super initWithModel:aModel]) {
    
        IBAFormSection *paramSection=nil;
        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addNumberFieldForKeyPath:@"Stick_P" title:NSLocalizedString(@"Nick-/Roll-P",@"MKParam Stick")];
        [paramSection addNumberFieldForKeyPath:@"Stick_D" title:NSLocalizedString(@"Nick-/Roll-D",@"MKParam Stick")];
        [paramSection addPotiFieldForKeyPath:@"StickGier_P" title:NSLocalizedString(@"Yaw-P",@"MKParam Stick")];

        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;
        [paramSection addPotiFieldForKeyPath:@"ExternalControl" title:NSLocalizedString(@"External control",@"MKParam Stick")];
  }
  
  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
