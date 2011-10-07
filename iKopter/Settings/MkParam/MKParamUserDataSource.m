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
#import "MKParamUserDataSource.h"

#import "MKParamMainController.h"
#import "IBAFormSection+MKParam.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamUserDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior{
	if (self = [super initWithModel:aModel]) {
    
        IBAFormSection *paramSection=nil;
        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addPotiFieldForKeyPath:@"UserParam1" title:NSLocalizedString(@"Parameter 1",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam2" title:NSLocalizedString(@"Parameter 2",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam3" title:NSLocalizedString(@"Parameter 3",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam4" title:NSLocalizedString(@"Parameter 4",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam5" title:NSLocalizedString(@"Parameter 5",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam6" title:NSLocalizedString(@"Parameter 6",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam7" title:NSLocalizedString(@"Parameter 7",@"MKParam User")];
        [paramSection addPotiFieldForKeyPath:@"UserParam8" title:NSLocalizedString(@"Parameter 8",@"MKParam User")];
  }
  
  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
