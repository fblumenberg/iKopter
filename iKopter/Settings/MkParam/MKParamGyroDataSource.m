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
#import "MKParamGyroDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamGyroDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior{
	if (self = [super initWithModel:aModel]) {
    
        IBAFormSection *paramSection=nil;
        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Gyro",@"MKParam Camera") footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addPotiFieldForKeyPath:@"Gyro_P" title:NSLocalizedString(@"Gyro-P",@"MKParam Gyro")];
        [paramSection addPotiFieldForKeyPath:@"Gyro_I" title:NSLocalizedString(@"Gyro-I",@"MKParam Gyro")];
        [paramSection addPotiFieldForKeyPath:@"Gyro_D" title:NSLocalizedString(@"Gyro-D",@"MKParam Gyro")];
        
        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Yaw",@"MKParam Camera") footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addPotiFieldForKeyPath:@"Gyro_Gier_P" title:NSLocalizedString(@"Yaw-P",@"MKParam Gyro")];
        [paramSection addPotiFieldForKeyPath:@"Gyro_Gier_I" title:NSLocalizedString(@"Yaw-I",@"MKParam Gyro")];

        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addPotiFieldForKeyPath:@"DynamicStability" title:NSLocalizedString(@"Dynamic Stability",@"MKParam Gyro")];
        [paramSection addNumberFieldForKeyPath:@"Driftkomp" title:NSLocalizedString(@"Drift compensation",@"MKParam Gyro")];
        [paramSection addSwitchFieldForKeyPath:@"GlobalConfig_DREHRATEN_BEGRENZER" title:NSLocalizedString(@"Rotation limiter",@"MKParam Gyro")];

        //------------------------------------------------------------------------------------------------------------------------
        paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
        paramSection.formFieldStyle.behavior = behavior;

        [paramSection addNumberFieldForKeyPath:@"GyroAccFaktor" title:NSLocalizedString(@"ACC/Gyro factor",@"MKParam Gyro")];
        [paramSection addNumberFieldForKeyPath:@"GyroAccAbgleich" title:NSLocalizedString(@"ACC/Gyro comp.",@"MKParam Gyro")];
        [paramSection addPotiFieldForKeyPath:@"I_Faktor" title:NSLocalizedString(@"Main I",@"MKParam Gyro")];
        [paramSection addNumberFieldForKeyPath:@"MotorSmooth" title:NSLocalizedString(@"Motor smooth",@"MKParam Gyro")];
  }
  
  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
