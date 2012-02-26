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

#import "RoutesViewController.h"
#import "RouteViewController.h"
#import "Route.h"

#import "IKDropboxController.h"
#import "NSString+Dropbox.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+RFhelpers.h"


@interface RoutesViewController () <IKDropboxControllerDelegate>
//- (void)setWorking:(BOOL)working;


@property(nonatomic, retain) UIActionSheet *backupRestoreSheet;

- (void)hideActionSheet;

@end;

@implementation RoutesViewController

@synthesize routes;
@synthesize addButton;
@synthesize syncButton;
@synthesize backupRestoreSheet;
@synthesize editingRoute;

- (id)init {
  if ((self = [super initWithStyle:UITableViewStylePlain])) {
    self.routes = [[[Routes alloc] init] autorelease];
    self.title = NSLocalizedString(@"Routes", @"Waypoint Lists title");
  }
  return self;
}

- (void)dealloc {
  self.routes = nil;
  self.addButton = nil;
  self.syncButton = nil;
  self.backupRestoreSheet = nil;
  self.editingRoute = nil;

  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.addButton = [[[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                               target:self
                               action:@selector(addRoute)] autorelease];
  self.addButton.style = UIBarButtonItemStyleBordered;

  self.syncButton = [[[UIBarButtonItem alloc]
          initWithImage:[UIImage imageNamed:@"icon-backforth.png"]
                  style:UIBarButtonItemStyleBordered
                 target:self
                 action:@selector(syncRoutes)] autorelease];


  UIBarButtonItem *spacerButton;
  spacerButton = [[[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil] autorelease];

  isSynActive = [[NSUserDefaults standardUserDefaults] boolForKey:@"IKSyncActive"];

  [self setToolbarItems:[NSArray arrayWithObjects:
          self.editButtonItem,
          spacerButton,
          isSynActive ? self.syncButton : spacerButton,
          spacerButton,
          self.addButton,
          nil]];

  self.tableView.allowsSelectionDuringEditing = YES;


}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.routes = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:NO];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(hideActionSheet)
                                               name:UIApplicationWillResignActiveNotification
                                             object:[UIApplication sharedApplication]];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if (self.editingRoute) {

    NSArray *indexPaths = [NSArray arrayWithObject:self.editingRoute];

    NSLog(@"appear reload %@", indexPaths);
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];

    self.editingRoute = nil;

    [self.routes save];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [self hideActionSheet];
  [[MBProgressHUD sharedProgressHUD] hide:NO];
}

- (void)hideActionSheet {
  [self.backupRestoreSheet dismissWithClickedButtonIndex:self.backupRestoreSheet.cancelButtonIndex animated:NO];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.routes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *CellIdentifier = @"RoutesCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }

  Route *list = [self.routes routeAtIndexPath:indexPath];

  cell.textLabel.text = list.name;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section == 0;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    [self.routes deleteRouteAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [self.routes moveRouteAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section == 0;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];

  UIBarButtonItem *spacerButton;
  spacerButton = [[[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:nil action:nil] autorelease];
  if (editing)
    [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem, spacerButton, nil] animated:YES];
  else
    [self setToolbarItems:[NSArray arrayWithObjects:
            self.editButtonItem,
            spacerButton,
            isSynActive ? self.syncButton : spacerButton,
            spacerButton,
            self.addButton,
            nil] animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.editing) {
    return nil;
  }

  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (indexPath.section == 0) {
    Route *list = [self.routes routeAtIndexPath:indexPath];
    if (!self.tableView.editing) {
      RouteViewController *listView = [[RouteViewController alloc] initWithRoute:list];
      self.editingRoute = indexPath;
      [self.navigationController pushViewController:listView animated:YES];
      [listView release];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addRoute {

  self.editingRoute = [self.routes addRoute];

  NSArray *indexPaths = [NSArray arrayWithObject:self.editingRoute];

  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];

  Route *newRoute = [self.routes routeAtIndexPath:self.editingRoute];
  newRoute.name = NSLocalizedString(@"Route", @"Route default name");

  [self.routes save];

  RouteViewController *listView = [[RouteViewController alloc] initWithRoute:newRoute];
  [self.navigationController pushViewController:listView animated:YES];
  [listView release];
}

- (void)syncRoutes {

  IKDropboxController *dbCtrl = [IKDropboxController sharedIKDropboxController];
  dbCtrl.delegate = self;
  [dbCtrl connectAndPrepareMetadata];
}

#pragma mark - IKDropboxControllerDelegate

- (void)dropboxReady:(IKDropboxController *)controller {

  NSString *routesFileName = [self.routes.routesFile lastPathComponent];
  BOOL hasRoutesFile = [controller metadataContainsPath:routesFileName];

  self.backupRestoreSheet = [[[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Routes Syncronisation", @"Routes Sync Title") delegate:self
                                                cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel Button") destructiveButtonTitle:hasRoutesFile ? NSLocalizedString(@"Restore", @"Restore Button") : nil otherButtonTitles:NSLocalizedString(@"Backup", @"Backup Button"), nil] autorelease];
  self.backupRestoreSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
  [self.backupRestoreSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (buttonIndex == actionSheet.cancelButtonIndex)
    return;

  NSString *routesFileName = [self.routes.routesFile lastPathComponent];
  IKDropboxController *dbCtrl = [IKDropboxController sharedIKDropboxController];

  dbCtrl.restClient.delegate = self;

  if (buttonIndex == actionSheet.destructiveButtonIndex) {
    NSString *remoteRoutesPath = [dbCtrl.dataPath stringByAppendingPathComponent:routesFileName];
    [dbCtrl.restClient loadFile:remoteRoutesPath intoPath:self.routes.routesFile];
  }
  else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
    [dbCtrl.restClient uploadFile:routesFileName toPath:dbCtrl.dataPath fromPath:self.routes.routesFile];
  }

  self.backupRestoreSheet = nil;

  [[MBProgressHUD sharedProgressHUD] setLabelText:NSLocalizedString(@"Syncing", @"DB Sync routes HUD")];
  [[MBProgressHUD sharedProgressHUD] show:YES];
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)destPath {
  [[MBProgressHUD sharedProgressHUD] hide:YES];

  [self.routes load];
  [self.tableView reloadData];
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
  [[MBProgressHUD sharedProgressHUD] hide:YES];
  [self.routes save];

  [IKDropboxController showError:error withTitle:NSLocalizedString(@"Restore failed", @"Routes Restore Error Title")];
}

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath {
  [[MBProgressHUD sharedProgressHUD] hide:YES];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error {
  [[MBProgressHUD sharedProgressHUD] hide:YES];
  [IKDropboxController showError:error withTitle:NSLocalizedString(@"Backup failed", @"Routes Backup Error Title")];
}

@end
