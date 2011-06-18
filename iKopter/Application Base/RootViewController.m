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
  UINavigationController *aNavController = [[UINavigationController alloc] initWithRootViewController:self.appSettingsViewController];
  //[viewController setShowCreditsFooter:NO];   // Uncomment to not display InAppSettingsKit credits for creators.
  // But we encourage you not to uncomment. Thank you!
  self.appSettingsViewController.showDoneButton = YES;
  [self presentModalViewController:aNavController animated:YES];
  [aNavController release];
}

#pragma mark -
#pragma mark IASKAppSettingsViewControllerDelegate protocol

//- (NSString*)mailComposeBody {
//  
//  return [NSString stringWithFormat:@"The iKopter log file from a customer.\n%@",[LCLLogFile path]];
//}

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
	if ([[specifier key] isEqualToString:@"customCell"]) {
		return 44;
	}
	return 0;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[specifier key]];
  
  if (!cell) {
    cell = [[[IASKPSTitleValueSpecifierViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[specifier key]] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  cell.textLabel.text = NSLocalizedString(@"Version",nil);
  cell.detailTextLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
  
  [cell setUserInteractionEnabled:NO];
  
  return cell;
}


#pragma mark -
#pragma mark View life cycle

- (void)viewDidLoad
{
  self.title = NSLocalizedString(@"iKopter",@"Root Title");
  
  hosts=[[MKHosts alloc]init];
  
  UIBarButtonItem* addButton;
  addButton =  [[[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:self
                 action:@selector(addHost)] autorelease];
  addButton.style = UIBarButtonItemStyleBordered;
  
  UIBarButtonItem* spacerButton;
  spacerButton =  [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil
                    action:nil] autorelease];
  
  [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,addButton,nil]];
  
  UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; 
  [infoButton addTarget:self action:@selector(showSettingsModal:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
  
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
  
  if( editingHost ) {
    
    NSArray* indexPaths=[NSArray arrayWithObject:editingHost];
    
    NSLog(@"appear reload %@",indexPaths);
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths 
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    editingHost=nil;
    
    [hosts save];
  }
  
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
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;//self.tableView.editing?1:2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section==0)
    return [hosts count];
  
  return 1;
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
      cell.textLabel.text = NSLocalizedString(@"Engine test",@"Motor test cell");
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
  
  MKHost* host = [hosts hostAtIndexPath:indexPath];
  
  cell.imageView.image = [host cellImage];
  cell.textLabel.text = host.name;
  cell.detailTextLabel.text = host.address;
  cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section==0;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    [hosts deleteHostAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [hosts moveHostAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section==0;
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
    MKHost* host=[hosts hostAtIndexPath:indexPath];
    if (self.tableView.editing ) {
      MKHostViewController* hostView = [[MKHostViewController alloc] initWithHost:host];
      editingHost = indexPath;
      [self.navigationController pushViewController:hostView animated:YES];
      [hostView release];
    }
    else {
      MainViewController* mainView = [[MainViewController alloc] initWithHost:host];
      [self.navigationController pushViewController:mainView animated:YES];
      [mainView release];   
    }
  }
  else{
    UIViewController* extraView=nil;
    
    switch (indexPath.row) {
      case 0:
        extraView = [[NCLogViewController alloc] initWithStyle:UITableViewStylePlain];
        break;
    }
    
    [self.navigationController setToolbarHidden:NO animated:NO];
    [self.navigationController pushViewController:extraView animated:YES];
    [extraView release];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addHost {
  
  editingHost=[hosts addHost];
  
  NSArray* indexPaths=[NSArray arrayWithObject:editingHost];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths 
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
  
  MKHost* host=[hosts hostAtIndexPath:editingHost]; 
  MKHostViewController* hostView = [[MKHostViewController alloc] initWithHost:host];
  [self.navigationController pushViewController:hostView animated:YES];
  [hostView release];   
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
