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
#import "MGSplitViewController.h"
#import "MKParamMainDataSource.h"

#import "MKParamViewController.h"

#import "MKParamAltitudeDataSource.h"
#import "MKParamCameraDataSource.h"
#import "MKParamChannelsDataSource.h"
#import "MKParamCompassDataSource.h"
#import "MKParamCouplingDataSource.h"
#import "MKParamGyroDataSource.h"
#import "MKParamLoopingDataSource.h"
#import "MKParamMiscDataSource.h"
#import "MKParamNaviControlDataSource.h"
#import "MKParamOutputDataSource.h"
#import "MKParamStickDataSource.h"
#import "MKParamUserDataSource.h"


#import "StringToNumberTransformer.h"
#import "SettingsFieldStyle.h"
#import "SettingsButtonStyle.h"

@interface MKParamMainDataSource()

-(void)showDetailViewForKey:(Class)nsclass withTitle:(NSString*)title;

@end

@implementation MKParamMainDataSource

- (id)initWithModel:(id)aModel andBehavior:(int)behavior{
	if (self = [super initWithModel:aModel]) {
    
		// Some basic form fields that accept text input
		IBAFormSection *basicFieldSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    basicFieldSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    basicFieldSection.formFieldStyle.behavior = behavior;
    
		[basicFieldSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"Name" title:NSLocalizedString(@"Name",@"MKParam Name")] autorelease]];
    
    //------------------------------------------------------------------------------------------------------------------------
    
		IBAFormSection *buttonsSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
    buttonsSection.formFieldStyle = [[[SettingsButtonIndicatorStyle alloc] init] autorelease];
    
		buttonsSection.formFieldStyle.behavior = behavior;
    
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Channels",@"MKParam Channels button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamChannelsDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Channels",@"MKParam Channels button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Compass",@"MKParam Compass button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamCompassDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Compass",@"MKParam Compass button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Navi Control",@"MKParam Navi Control button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamNaviControlDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Navi Control",@"MKParam Navi Control button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Stick",@"MKParam Stick button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamStickDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Stick",@"MKParam Stick button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Altitude",@"MKParam Altitude button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamAltitudeDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Altitude",@"MKParam Altitude button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Camera",@"MKParam Camera button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamCameraDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Camera",@"MKParam Camera button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Gyro",@"MKParam Gyro button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamGyroDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Gyro",@"MKParam Gyro button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Coupling",@"MKParam Coupling button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamCouplingDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Coupling",@"MKParam Coupling button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Looping",@"MKParam Looping button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamLoopingDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Looping",@"MKParam Looping button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Output",@"MKParam Output button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamOutputDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Output",@"MKParam Output button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Misc",@"MKParam Misc button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamMiscDataSource class] 
                                                                                withTitle:NSLocalizedString(@"Misc",@"MKParam Misc button")];
                                                             }] autorelease]];
		[buttonsSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"User",@"MKParam User button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDetailViewForKey:[MKParamUserDataSource class] 
                                                                                withTitle:NSLocalizedString(@"User",@"MKParam User button")];
                                                             }] autorelease]];
  }
  
  return self;
}


-(void)showDetailViewForKey:(Class)nsclass withTitle:(NSString*)title{
  
  IBAFormDataSource* dataSource = [[[nsclass alloc] initWithModel:self.model
                                                      andBehavior:IBAFormFieldBehaviorClassic|IBAFormFieldBehaviorNoCancel] autorelease];
  
	MKParamViewController *settingsFormController = [[[MKParamViewController alloc] initWithNibName:nil 
                                                                                           bundle:nil 
                                                                                   formDataSource:dataSource] autorelease];
	settingsFormController.title = title;
	
  [[IBAInputManager sharedIBAInputManager] setInputNavigationToolbarEnabled:YES];
  
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  
  if ([rootViewController isKindOfClass:[UINavigationController class]]) {
    [(UINavigationController *)rootViewController pushViewController:settingsFormController animated:YES];
  }
  else if ([rootViewController isKindOfClass:[MGSplitViewController class]]) {
    
    MGSplitViewController* splitViewController =(MGSplitViewController*)rootViewController;
    
    UIViewController* controller=splitViewController.detailViewController;
    if( [controller isKindOfClass:[UINavigationController class]] ){
      controller.navigationItem.hidesBackButton=YES;
      
      [(UINavigationController *)controller popToRootViewControllerAnimated:NO];
      [(UINavigationController *)controller pushViewController:settingsFormController animated:YES];
    }
  }
}


- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
	NSLog(@"%@", [self.model description]);
}

@end
