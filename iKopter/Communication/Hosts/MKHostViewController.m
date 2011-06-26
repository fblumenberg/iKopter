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

#import "MKHostViewController.h"
#import "IASKSettingsStoreObject.h"

#import "BTDiscoveryViewController.h"
#import "BTDevice.h"

@implementation MKHostViewController

#pragma mark -

- (id)initWithHost:(MKHost*)theHost {
  if (self =  [super initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
    self.file = @"MKHost";
    self.settingsStore = [[IASKSettingsStoreObject alloc] initWithObject:theHost];
    
    self.showCreditsFooter=NO;
    self.showDoneButton=NO;
    
    self.delegate=self;
    
    self.title=NSLocalizedString(@"MK Connection", @"MKHost title");
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark -

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{	
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:YES animated:NO];
}

-(void)settingsViewController:(id)sender buttonTappedForKey:(NSString*)key {
	BTDiscoveryViewController *controller = [[BTDiscoveryViewController alloc] init];
  
  UINavigationController* navController = [[UINavigationController alloc]initWithRootViewController:controller];
	
	navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    controller.delegate=self;
	[self presentModalViewController:navController animated:YES];
	
	[controller release];  
	[navController release];  
}

-(BOOL) discoveryView:(BTDiscoveryViewController*)discoveryView willSelectDeviceAtIndex:(int)deviceIndex {
  
  BTDevice* device=[discoveryView.bt deviceAtIndex:deviceIndex];
  
  [self.settingsStore setObject:[device nameOrAddress] forKey:@"name"];
  [self.settingsStore setObject:[device addressString] forKey:@"address"];
  [_tableView reloadData];
  
  [discoveryView.navigationController dismissModalViewControllerAnimated:YES];
  return YES;
}


@end

