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
#import "MKParamMiscDataSource.h"
#import "IBAFormSection+MKParam.h"

#import "MKParamMainController.h"

#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@implementation MKParamMiscDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior{
	if (self = [super initWithModel:aModel]) {
    
    IBAFormFieldStyle* switchStyle = [[[SettingsFieldStyleSwitch alloc] init] autorelease];

    IBAFormSection *paramSection=nil;
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;
    
    [paramSection addNumberFieldForKeyPath:@"Gas_Min" title:NSLocalizedString(@"Min. Gas",@"MKParam Misc")];
    [paramSection addNumberFieldForKeyPath:@"Gas_Max" title:NSLocalizedString(@"Max. Gas",@"MKParam Misc")];
    
    [paramSection addNumberFieldForKeyPath:@"UnterspannungsWarnung" title:NSLocalizedString(@"Low voltage level",@"MKParam Misc")];
    
    NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:[NSArray arrayWithObjects:
                                                                                 NSLocalizedString(@"3.0 V",@"MKParam Misc"),
                                                                                 NSLocalizedString(@"3.3 V",@"MKParam Misc"),
                                                                                 nil]];
    
    IBASingleIndexTransformer *transformer = [[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptions] autorelease];
    
		[paramSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"ExtraConfig_3_3V_REFERENCE"
                                                                        title:NSLocalizedString(@"Voltage reference",@"MKParam Misc")
                                                             valueTransformer:transformer
                                                                selectionMode:IBAPickListSelectionModeSingle
                                                                      options:pickListOptions] autorelease]];
    
    
    [paramSection addPotiFieldForKeyPath:@"CareFreeModeControl" title:NSLocalizedString(@"Carefree control",@"MKParam Misc")];
    if(((IKParamSet*)aModel).Revision.integerValue>=88)
      [paramSection addSwitchFieldForKeyPath:@"ExtraConfig_LEARNABLE_CAREFREE" title:NSLocalizedString(@"Teachable Carefree",@"MKParam Misc") 
                                       style:switchStyle];
    
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Sender signal lost",@"MKParam Misc") footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;
   
    [paramSection addNumberFieldForKeyPath:@"NotGasZeit" title:NSLocalizedString(@"Emergency time (0.1s)",@"MKParam Misc")];
    [paramSection addNumberFieldForKeyPath:@"NotGas" title:NSLocalizedString(@"Emergency-Gas",@"MKParam Misc")];
    
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:NSLocalizedString(@"Failsafe",@"MKParam Misc") footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;

    if(((IKParamSet*)aModel).Revision.integerValue>=88)
      [paramSection addNumberFieldForKeyPath:@"FailSafeTime" title:NSLocalizedString(@"Comming Home time (s)",@"MKParam Misc")];
    
    if(((IKParamSet*)aModel).Revision.integerValue>=90){
      [paramSection addSwitchFieldForKeyPath:@"GlobalConfig3_CFG3_VARIO_FAILSAFE" title:NSLocalizedString(@"Use vario for altitude",@"MKParam Misc") 
                                       style:switchStyle];
      
      [paramSection addChannelsForKeyPath:@"FailsafeChannel" title:NSLocalizedString(@"Channel",@"MKParam Misc")];
    }
    
    
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;
    if(((IKParamSet*)aModel).Revision.integerValue>=88)
      [paramSection addSwitchFieldForKeyPath:@"ExtraConfig_NO_RCOFF_BEEPING" title:NSLocalizedString(@"No Beep w.o. active sender",@"MKParam Misc") 
                                       style:switchStyle];
    
    if(((IKParamSet*)aModel).Revision.integerValue>=88)
      [paramSection addSwitchFieldForKeyPath:@"ExtraConfig_IGNORE_MAG_ERR_AT_STARTUP" 
                                       title:NSLocalizedString(@"Ignore magnet error at startup",@"MKParam Misc") 
                                       style:switchStyle];
    if(((IKParamSet*)aModel).Revision.integerValue>=90){
      [paramSection addSwitchFieldForKeyPath:@"GlobalConfig3_CFG3_NO_SDCARD_NO_START" title:NSLocalizedString(@"No start without SD card",@"MKParam Misc") 
                                       style:switchStyle];
    }
    
    //------------------------------------------------------------------------------------------------------------------------
    paramSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    paramSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    paramSection.formFieldStyle.behavior = behavior;
    [paramSection addSwitchFieldForKeyPath:@"GlobalConfig_HEADING_HOLD" title:NSLocalizedString(@"Heading Hold",@"MKParam Misc") 
                                     style:switchStyle];
    
    
  }
  
  return self;
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
