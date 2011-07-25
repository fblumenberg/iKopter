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


#import "RootViewController.h"
#import "MainViewController.h"

#import "MKHosts.h"
#import "MKHost.h"
#import "MKHostViewController.h"
#import "MKConnectionController.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#import "NCLogViewController.h"
#import "MKHostsViewController.h"
#import "RoutesViewController.h"
#import "DropboxSDK.h"
#import "IKDropboxLoginController.h"

#define kDropBoxAction @"DropBoxAction"


@interface RootViewController() <IKDBLoginControllerDelegate>

- (void)updateDropboxButton;

@end

@implementation RootViewController

@synthesize appSettingsViewController;

- (IASKAppSettingsViewController*)appSettingsViewController {
	if (!appSettingsViewController) {
		appSettingsViewController = [[IASKAppSettingsViewController alloc] initWithNibName:@"IASKAppSettingsView" bundle:nil];
		appSettingsViewController.delegate = self;
	}
	return appSettingsViewController;
}

- (IBAction)showSettingsModal:(id)sender {
  
  [self updateDropboxButton];
  
  UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
  //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
  // But we encourage you not to uncomment. Thank you!
  self.appSettingsViewController.showDoneButton = YES;
  [self presentModalViewController:aNavController animated:YES];
  [aNavController release];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

- (void) updateDropboxButton{
  
  [self.appSettingsViewController.tableView reloadData];
}

- (void)mailComposeAttachment:(MFMailComposeViewController*)mailViewController{
  
  NSString *csv = [NSString stringWithContentsOfFile:[LCLLogFile path] encoding:NSUTF8StringEncoding error:nil];
  NSData *csvData = [csv dataUsingEncoding:NSUTF8StringEncoding];
  
  [mailViewController addAttachmentData:csvData mimeType:@"text/plain" fileName:@"ikopter.log"];
}


- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
  [self dismissModalViewControllerAnimated:YES];
	
  
# ifndef _LCL_NO_LOGGING
  
  BOOL logActive=NO;
  _lcl_level_t level=lcl_vCritical;
  
  NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingActive];
  if (testValue) {
    logActive = [[NSUserDefaults standardUserDefaults] boolForKey:kIKLoggingActive];
  }
  
  testValue = nil;
  testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingLevel];
  if (testValue) {
    level = [[NSUserDefaults standardUserDefaults] integerForKey:kIKLoggingLevel];
  }
  
  if(!logActive)  
    level=lcl_vOff;
  
  lcl_configure_by_identifier("*", level);
  
# endif

}

- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
		return 44;
}

- (void)showDropboxLogin {  
  if (![[DBSession sharedSession] isLinked]) {
    
    IKDropboxLoginController* controller = [[[IKDropboxLoginController alloc] initWithNibName:nil bundle:nil] autorelease];
//    DBLoginController* controller = [[DBLoginController new] autorelease];
//    controller.delegate = self;
    self.appSettingsViewController.navigationController.delegate=nil;
    [self.appSettingsViewController.navigationController pushViewController:controller animated:YES];
  } 
  else {
    [[DBSession sharedSession] unlink];
    [self updateDropboxButton];
  }
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
  
  UITableViewCell* cell = (UITableViewCell*)(gestureRecognizer.view);
  [cell setSelected:YES animated:NO];
  [self performSelector:@selector(showDropboxLogin) withObject:nil afterDelay:0.0];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[specifier key]];
  
  if (!cell) {
    cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[specifier key]] autorelease];
  }

  cell.accessoryType = UITableViewCellAccessoryNone;
  
	if ([[specifier key] isEqualToString:@"customCell"]) {
    cell.textLabel.text = NSLocalizedString(@"Version",nil);
    cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [cell setUserInteractionEnabled:NO];
  }
  else if ([[specifier key] isEqualToString:@"dropboxActionCell"]) {
    
    if (![[DBSession sharedSession] isLinked]) {
      cell.textLabel.text = NSLocalizedString(@"Link with Dropbox",@"Dropbox button link");
    }
    else {
      cell.textLabel.text = NSLocalizedString(@"Unlink from Dropbox",@"Dropbox button link");
    }

    if (![[DBSession sharedSession] isLinked])
      cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
    [cell setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
    [cell addGestureRecognizer:singleTap];
    [singleTap release];
  }
  
  return cell;
}

#pragma mark - DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(IKDropboxLoginController*)controller {
  [self updateDropboxButton];
}

- (void)loginControllerDidCancel:(IKDropboxLoginController*)controller {
  [self updateDropboxButton];
}

#pragma mark - View life cycle

- (void)viewDidLoad
{
  self.title = NSLocalizedString(@"iKopter",@"Root Title");
  
  hosts=[[MKHosts alloc]init];
  
  UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
  [infoButton addTarget:self action:@selector(showSettingsModal:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:infoButton] autorelease];
  
  self.tableView.allowsSelectionDuringEditing=YES;
  
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  self.navigationController.navigationBar.translucent=NO;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  
  [self.navigationController setToolbarHidden:NO animated:NO];
  [[MKConnectionController sharedMKConnectionController] stop];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade]; 
  
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section==0)
    return [hosts count]+1;
  
  return 2;
}


//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *) cellForExtra: (UITableView *) tableView indexPath: (NSIndexPath *) indexPath  {
  static NSString *CellIdentifier = @"RootExtraCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = NSLocalizedString(@"NC Log",@"NC-LOG cell");
      break;
    case 1:
      cell.textLabel.text = NSLocalizedString(@"Routes",@"Waypointlist cell");
      break;
    case 2:
      cell.textLabel.text = NSLocalizedString(@"Channels",@"Channels cell");
      break;
  }
  cell.accessoryView = nil;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  cell.imageView.image = nil;
  
  
  return cell;
  
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSLog(@"cellForRowAtIndexPath %@",indexPath);
  
  static NSString *CellIdentifier = @"MKHostCell";
  
  if(indexPath.section==1)
    return [self cellForExtra: tableView indexPath: indexPath];

  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  if( indexPath.row<[hosts count] ){
    MKHost* host = [hosts hostAtIndexPath:indexPath];
    
    cell.imageView.image = [host cellImage];
    cell.textLabel.text = host.name;
    cell.detailTextLabel.text = host.address;
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  else{
    cell.imageView.image = nil;
    cell.textLabel.text = NSLocalizedString(@"Edit Connections", "Root edit hosts");
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.editing && indexPath.section!=0) {
    return nil;
  }
  
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if( indexPath.section==0 ){
    
    if( indexPath.row<[hosts count] ){
      
      MKHost* host=[hosts hostAtIndexPath:indexPath];
      MainViewController* mainView = [[MainViewController alloc] initWithHost:host];
      [self.navigationController pushViewController:mainView animated:YES];
      [mainView release];   
    }
    else{
      MKHostsViewController* extraView = [[MKHostsViewController alloc] initWithHosts:hosts];
      
      [self.navigationController setToolbarHidden:NO animated:NO];
      [self.navigationController pushViewController:extraView animated:YES];
      [extraView release];
    }
  }
  else{
    UIViewController* extraView=nil;
    
    switch (indexPath.row) {
      case 0:
        extraView = [[NCLogViewController alloc] initWithStyle:UITableViewStylePlain];
        break;
      case 1:
        extraView = [[RoutesViewController alloc] init];
        break;
    }
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController pushViewController:extraView animated:YES];
    [extraView release];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  [hosts release];
  hosts = nil;
}

- (void)dealloc {
  [hosts release];
  [super dealloc];
}

@end
