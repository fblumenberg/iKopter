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

#import "SettingViewController.h"

#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadEncode.h"

#import "IASKSettingsStoreObject.h"
#import "IKMkDataTypes.h"
#import "MKDataConstants.h"

@implementation SettingViewController

@synthesize setting=_setting;

#pragma mark -

- (id)initWithSetting:(IKParamSet*)aSetting {
  
  if (self =  [super initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
    self.file = @"Setting";
    self.settingsStore = [[IASKSettingsStoreObject alloc] initWithObject:aSetting];
    self.setting = aSetting;
    self.showCreditsFooter=NO;
    self.showDoneButton=NO;
    
    self.title = NSLocalizedString(@"Setting",nil);
  }
  
  return self;
}

- (void)dealloc {
  
  self.setting=nil;
  [_setting release];
  [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem* renameButton;
  renameButton =  [[[UIBarButtonItem alloc]
                    initWithTitle:NSLocalizedString(@"Save",@"Save toolbar item")
                            style:UIBarButtonItemStyleDone
                            target:self
                            action:@selector(saveSetting:)] autorelease];
  

  UIBarButtonItem* spacer;
  spacer =  [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil
                    action:nil] autorelease];
  
  UIBarButtonItem* reloadButton;
  reloadButton =  [[[UIBarButtonItem alloc]
                    initWithTitle:NSLocalizedString(@"Reload", @"Reload toolbar item")
                            style:UIBarButtonItemStyleBordered
                            target:self
                            action:@selector(reloadSetting:)] autorelease];
  
 	[self setToolbarItems:[NSArray arrayWithObjects:renameButton,spacer,reloadButton,nil]];

}

- (void)viewDidUnload {
  [super viewDidUnload];

  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  DLog(@"unload");  
}

#pragma mark -

// called after this controller's view will appear
- (void)viewWillAppear:(BOOL)animated
{	
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:NO];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(readSettingNotification:)
             name:MKReadSettingNotification
           object:nil];
  
  [nc addObserver:self
         selector:@selector(writeSettingNotification:)
             name:MKWriteSettingNotification
           object:nil];
}

// called after this controller's view will appear
- (void)viewWillDisappear:(BOOL)animated {
  
  [super viewWillDisappear:animated];
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
}


#pragma mark -
#pragma mark Save Setting

- (void)saveSetting:(id)sender {
  
  DLog(@"save setting");

  IASKSettingsStoreObject* store=(IASKSettingsStoreObject*)self.settingsStore;
  IKParamSet* setting=store.object;
  [[MKConnectionController sharedMKConnectionController]saveSetting:setting];
}

- (void) writeSettingNotification:(NSNotification *)aNotification {
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Setting" message:@"Setting saved"
                                                 delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
}

#pragma mark -
#pragma mark Reload Setting

- (void)reloadSetting:(id)sender {
  
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  
  uint8_t index = [self.setting.Index unsignedCharValue];
  
  NSData * data = [NSData dataWithCommand:MKCommandReadSettingsRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:&index
                                   length:1];
  
  [cCtrl sendRequest:data];
}

- (void) readSettingNotification:(NSNotification *)aNotification {
  
  NSDictionary* d=[aNotification userInfo];
  self.setting = [d mutableCopy];
  [_tableView reloadData];
}

@end
