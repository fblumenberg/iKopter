//
//  RootViewController.m
//  iKopter
//
//  Created by Frank Blumenberg on 20.06.10.
//  Copyright de.frankblumenberg 2010. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "AboutViewController.h"

#import "MKHosts.h";
#import "MKHost.h";
#import "MKHostViewController.h"
#import "MKConnectionController.h"

@implementation RootViewController


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  [infoButton addTarget:self action:@selector(showInfoView:) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
  
  self.tableView.allowsSelectionDuringEditing=YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
  
  [self.navigationController setToolbarHidden:NO animated:NO];
  [[MKConnectionController sharedMKConnectionController] stop];
  
}

- (void)viewDidAppear:(BOOL)animated {
  
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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)showInfoView:(id)sende {
	AboutViewController *controller = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	
	controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];  
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

