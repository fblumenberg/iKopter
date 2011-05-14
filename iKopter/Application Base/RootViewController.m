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
//  return @"Testtext";
//}

- (void)mailComposeAttachment:(MFMailComposeViewController*)mailViewController{
  
  NSString *filePath=[LCLLogFile path];
  
  NSString *csv = [NSString stringWithContentsOfFile:[LCLLogFile path] encoding:NSUTF8StringEncoding error:nil];
  NSData *csvData = [csv dataUsingEncoding:NSUTF8StringEncoding];
  
  //  NSData *csvData = [NSData dataWithContentsOfFile:[LCLLogFile path]]; 
  
  [mailViewController addAttachmentData:csvData mimeType:@"text/plain" fileName:@"ikopter.log"];
}


- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender {
  [self dismissModalViewControllerAnimated:YES];
	
	// your code here to reconfigure the app for changed settings
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
  
  if(self.tableView.editing ) {
    
    if( editingHost ) {
      
      NSArray* indexPaths=[NSArray arrayWithObject:editingHost];
      
      NSLog(@"appear reload %@",indexPaths);
      [self.tableView beginUpdates];
      [self.tableView reloadRowsAtIndexPaths:indexPaths 
                            withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView endUpdates];
      
      editingHost=nil;
    }
    
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [hosts count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSLog(@"cellForRowAtIndexPath %@",indexPath);
  
  static NSString *CellIdentifier = @"MKHostCell";
  
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
  // Return NO if you do not want the specified item to be editable.
  return YES;
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
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
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
