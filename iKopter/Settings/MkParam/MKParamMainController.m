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


#import "MKParamMainController.h"

#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadEncode.h"

#import "UIViewController+SplitView.h"

#import "IKMkDataTypes.h"
#import "MKDataConstants.h"

@interface MKParamMainController()

- (void)saveSetting:(id)sender;
- (void)reloadSetting:(id)sender;

@end

@implementation MKParamMainController

- (void)loadView {
	[super loadView];

	UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	UITableView *formTableView = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped] autorelease];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
	
	[view addSubview:formTableView];
	[self setView:view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - View lifecycle

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
  qltrace(@"unload");  
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

- (void)viewWillDisappear:(BOOL)animated {
  
  [super viewWillDisappear:animated];
  
  [hud hide:NO];  
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  [self.detailViewController popToRootViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Save Setting

- (void)saveSetting:(id)sender {
  
  qltrace(@"save setting");
  
  IKParamSet* setting = self.formDataSource.model; 
  
  [[MKConnectionController sharedMKConnectionController]saveSetting:setting];
}

- (void) writeSettingNotification:(NSNotification *)aNotification {
  
  hud = [[MBProgressHUD alloc] initWithView:self.view];
  
  [self.view addSubview:hud];
  hud.delegate = self;
  hud.customView = [[[UIImageView alloc] initWithImage:
                     [UIImage imageNamed:@"icon-check.png"]] autorelease];
  hud.mode = MBProgressHUDModeCustomView;
  hud.labelText = NSLocalizedString(@"Setting saved",@"Setting saved success");
  
  [hud show:YES];
  [hud hide:YES afterDelay:1.0];
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
  
  [hud removeFromSuperview];
  [hud release];
  hud = nil;
}


#pragma mark -
#pragma mark Reload Setting

- (void)reloadSetting:(id)sender {
  
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  IKParamSet* setting = self.formDataSource.model; 
 
  uint8_t index = [setting.Index unsignedCharValue];
  
  NSData * data = [NSData dataWithCommand:MKCommandReadSettingsRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:&index
                                   length:1];
  
  [cCtrl sendRequest:data];
}

- (void) readSettingNotification:(NSNotification *)aNotification {
  
  IKParamSet* paramSet=[[aNotification userInfo] objectForKey:kIKDataKeyParamSet];
  self.formDataSource.model = paramSet;
  
  [self.detailViewController popToRootViewControllerAnimated:YES];
  [self.tableView reloadData];
}


@end
