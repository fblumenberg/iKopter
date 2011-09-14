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
#import "IASKSpecifier.h"
#import "IASKSettingsReader.h"
#import "IKOutputSettingCell.h"
#import "IKOutputSettingSwitchCell.h"


@implementation SettingViewController

@synthesize setting=_setting;

#pragma mark -

- (id)initWithSetting:(IKParamSet*)aSetting {
  
  if (self =  [super initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
    self.file = @"Setting";
    self.settingsStore = [[[IASKSettingsStoreObject alloc] initWithObject:aSetting] autorelease];
    self.setting = aSetting;
    self.showCreditsFooter=NO;
    self.showDoneButton=NO;
    self.delegate=self;
    self.title = NSLocalizedString(@"Setting",nil);
  }
  
  return self;
}

- (void)dealloc {
  
  self.setting=nil;

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
}


#pragma mark -
#pragma mark Save Setting

- (void)saveSetting:(id)sender {
  
  qltrace(@"save setting");
  [[MKConnectionController sharedMKConnectionController]saveSetting:self.setting];
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
  
  uint8_t index = [self.setting.Index unsignedCharValue];
  
  NSData * data = [NSData dataWithCommand:MKCommandReadSettingsRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:&index
                                   length:1];
  
  [cCtrl sendRequest:data];
}

- (void) readSettingNotification:(NSNotification *)aNotification {
  
  IKParamSet* paramSet=[[aNotification userInfo] objectForKey:kIKDataKeyParamSet];
  self.setting = paramSet;
  self.settingsStore = [[[IASKSettingsStoreObject alloc] initWithObject:paramSet]autorelease];
  [_tableView reloadData];
}

#pragma makr - IASKSettingsDelegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender{
  
}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
  NSLog(@"heightForSpecifier %@",specifier);
	if ([specifier.key isEqualToString:@"J16Bitmask"] || [specifier.key isEqualToString:@"J17Bitmask"]) {
		return 88;
	}
  else if([specifier.key isEqualToString:@"WARN_J16_Bitmask"] || [specifier.key isEqualToString:@"WARN_J17_Bitmask"]){
		return 132;
  }
	return 0;
}

////////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell*)tableView:(UITableView*)tableView outputCellForSpecifier:(IASKSpecifier*)specifier {
  IKOutputSettingCell *cell = (IKOutputSettingCell*)[tableView dequeueReusableCellWithIdentifier:specifier.key];
  if (!cell) {
    cell = (IKOutputSettingCell*)[[[NSBundle mainBundle] loadNibNamed:@"IKOutputSettingCell" 
                                                                owner:self 
                                                              options:nil] objectAtIndex:0];
  }
  
  [cell.output addTarget:self action:@selector(outputChangedValue:) forControlEvents:UIControlEventValueChanged];
  cell.output.key = specifier.key;
  cell.label.text = specifier.title;
  
  cell.output.value=0;
  NSNumber* n=[self.settingsStore objectForKey:specifier.key];
  if(n)
    cell.output.value=[n integerValue];
  
	return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell*)tableView:(UITableView*)tableView outputSwitchCellForSpecifier:(IASKSpecifier*)specifier {
  IKOutputSettingSwitchCell *cell = (IKOutputSettingSwitchCell*)[tableView dequeueReusableCellWithIdentifier:specifier.key];
  if (!cell) {
    cell = (IKOutputSettingSwitchCell*)[[[NSBundle mainBundle] loadNibNamed:@"IKOutputSettingSwitchCell" 
                                                                      owner:self 
                                                                    options:nil] objectAtIndex:0];
  }
  
  
  [cell.output addTarget:self action:@selector(outputChangedValue:) forControlEvents:UIControlEventValueChanged];
  cell.output.key = specifier.key;
  cell.label.text = specifier.title;
  
  cell.output.value=0;
  NSNumber* n=[self.settingsStore objectForKey:specifier.key];
  if(n)
    cell.output.value=[n integerValue];
  
	return cell;
}

////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
  
  UITableViewCell* cell=nil;

 	if ([specifier.key isEqualToString:@"J16Bitmask"] || [specifier.key isEqualToString:@"J17Bitmask"]) {
    cell = [self tableView:tableView outputCellForSpecifier:specifier];
	}
  else if([specifier.key isEqualToString:@"WARN_J16_Bitmask"] || [specifier.key isEqualToString:@"WARN_J17_Bitmask"]){
    cell = [self tableView:tableView outputSwitchCellForSpecifier:specifier];
  }

	[cell setNeedsLayout];
	return cell;
}

- (void)outputChangedValue:(id)sender {
  IKOutputSetting *output = (IKOutputSetting*)sender;
  [self.settingsStore setInteger:output.value forKey:output.key];
  [[NSNotificationCenter defaultCenter] postNotificationName:kIASKAppSettingChanged object:output.key];
}


@end
