// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010, Frank Blumenberg
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
#import "MKHostViewDataSource.h"
#import "StringToNumberTransformer.h"
#import "MKHostTypeTransformer.h"
#import "MKHost.h"
#import "SettingsButtonStyle.h"
#import "SettingsFieldStyle.h"
#import "BTDevice.h"

@interface MKHostViewDataSource()

-(void)showDiscoveryView;

@end

@implementation MKHostViewDataSource

- (id)initWithModel:(id)aModel {
	if ((self = [super initWithModel:aModel])) {
    
		IBAFormSection *hostSection = [self addSectionWithHeaderTitle:nil
                                    footerTitle:NSLocalizedString(@"WLAN - Hostname:Port\nBluetooth - aa:bb:cc:dd:ee:ff", @"Host footer")];
    hostSection.formFieldStyle = [[[SettingsFieldStyle alloc] init] autorelease];
    
    //------------------------------------------------------------------------------------------------------------------------
    [hostSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"name" title:NSLocalizedString(@"Name",@"Host name")] autorelease]];
    [hostSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"address" title:NSLocalizedString(@"Address",@"Host address")] autorelease]];
    [hostSection addFormField:[[[IBATextFormField alloc] initWithKeyPath:@"pin" title:NSLocalizedString(@"Pin",@"Host pin")] autorelease]];

    MKHostTypeTransformer *hostTransformer = [MKHostTypeTransformer instance];
    
		[hostSection addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:@"connectionClass"
                                                                           title:NSLocalizedString(@"Type", @"Host type")
                                                                valueTransformer:hostTransformer
                                                                   selectionMode:IBAPickListSelectionModeSingle
                                                                         options:hostTransformer.pickListOptions] autorelease]];

    
    ////////////////////////////////////////////////////////////////////////////////////////////////////
    
		IBAFormSection *btSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];

    btSection.formFieldStyle = [[[SettingsButtonStyle alloc] init] autorelease];
		
		[btSection addFormField:[[[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Search Bluetooth",@"BT search button")
                                                                       icon:nil
                                                             executionBlock:^{
                                                               [self showDiscoveryView];
                                                             }] autorelease]];
  }
  return self;
}

- (void)setModelValue:(id)value forKeyPath:(NSString *)keyPath {
	[super setModelValue:value forKeyPath:keyPath];
	
  [MKHost sendChangedNotification:self];
  
	qltrace(@"%@", [self.model description]);
}

-(void)showDiscoveryView{
  
	BTDiscoveryViewController *controller = [[BTDiscoveryViewController alloc] init];
  
	UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:controller];


	navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
  controller.delegate=self;
  [rootViewController presentModalViewController:navController animated:YES];
	
	[controller release];  
	[navController release];  
}


-(BOOL) discoveryView:(BTDiscoveryViewController*)discoveryView willSelectDeviceAtIndex:(int)deviceIndex {
  
  BTDevice* device=[discoveryView.bt deviceAtIndex:deviceIndex];
  
  [self.model setValue:[device nameOrAddress] forKey:@"name"];
  [self.model setValue:[device addressString] forKey:@"address"];

  [discoveryView.navigationController dismissModalViewControllerAnimated:YES];
  return YES;
}


@end
