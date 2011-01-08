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

#import "MainViewController.h"
#import "MKHost.h"
#import "GradientButton.h"
#import "IASKSettingsStoreObject.h"

#import "MKConnectionController.h"
#import "MKDataConstants.h"


@implementation MainViewController

@synthesize host=_host;

#pragma mark -

- (id)initWithHost:(MKHost*)theHost {
  
  if (self =  [super initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
    self.file = @"Main";
    self.settingsStore = [[IASKSettingsStoreObject alloc] initWithObject:nil];
    
    self.showCreditsFooter=NO;
    self.showDoneButton=NO;
    
    self.title = theHost.name;
    self.host = theHost;

    connectionState=MKConnectionStateDisconnected;
  }
  
  return self;
}

- (void)dealloc {
  
  self.host = nil;
  [_host release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void)viewDidLoad  {  
  
  [super viewDidLoad];
  
  //Create an instance of activity indicator view
  UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
  //set the initial property
  [activityIndicator stopAnimating];
  [activityIndicator hidesWhenStopped];
  
  //Create an instance of Bar button item with custome view which is of activity indicator
  UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
  
  //Set the bar button the navigation bar
  [self navigationItem].rightBarButtonItem = barButton;

  //Memory clean up
  [activityIndicator release];
  [barButton release];
  
}

- (void)viewWillAppear:(BOOL)animated {	
  [super viewWillAppear:animated];

  NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
  [nc addObserver:self 
         selector:@selector(connectionRequestDidSucceed:) 
             name:MKConnectedNotification 
           object:nil];
  
  [nc addObserver:self 
         selector:@selector(disconnected:) 
             name:MKDisconnectedNotification 
           object:nil];
  
  [nc addObserver:self 
         selector:@selector(connectionRequestDidFail:) 
             name:MKDisconnectErrorNotification 
           object:nil];
  
  [nc addObserver:self 
         selector:@selector(versionResponse:) 
             name:MKVersionNotification
           object:nil];
  
  [self.navigationController setToolbarHidden:NO animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if( ![[MKConnectionController sharedMKConnectionController] isRunning]) {
    
    _tableView.userInteractionEnabled=NO;
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
    [[MKConnectionController sharedMKConnectionController] start:self.host];
    
  }
  else {
    [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];
  }
  
  [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {
  NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  [super viewWillDisappear:animated];
}

- (void)viewDidUnload {
  [[MKConnectionController sharedMKConnectionController] stop];
  [super viewDidUnload];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return YES;
}
///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  if(connectionState==MKConnectionStateConnected )
    return [super numberOfSectionsInTableView:tableView];

  return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  DLog(@"%d state %d",section,connectionState);

  if(connectionState==MKConnectionStateConnected )
    return [super tableView:tableView numberOfRowsInSection:section];
 
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  DLog(@"%@ state %d",indexPath,connectionState);

  if(connectionState==MKConnectionStateConnected )
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
  
  static NSString *CellIdentifier = @"MKConnectionCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  cell.textLabel.text = NSLocalizedString(@"Connecting…",@"Text connecting label");
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  cell.accessoryType = UITableViewCellAccessoryNone;
  
  return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection status actions (Statemachine)

- (void)userDidDisconnect;
{
  [[MKConnectionController sharedMKConnectionController] stop];
}

- (void)userDidCancelLastConnectRequest;
{
  [[MKConnectionController sharedMKConnectionController] stop];
  connectionState=MKConnectionStateDisconnected;
  [_tableView reloadData];
}

- (void)connectionRequestDidFail:(NSNotification *)aNotification;
{
  NSError* err = [[aNotification userInfo] objectForKey:@"error"];
  
  UIAlertView *alert = [[UIAlertView alloc] 
                        initWithTitle:NSLocalizedString(@"Server error", @"Server error")
                        message:[err localizedDescription] 
                        delegate:self 
                        cancelButtonTitle:@"Ok" 
                        otherButtonTitles:nil];
  [alert show];
  [alert release];
  
  connectionState=MKConnectionStateDisconnected;
  [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (void)connectionRequestDidSucceed:(NSNotification *)aNotification;
{
  DLog(@"Got connected");
  _tableView.userInteractionEnabled=YES;

  connectionState=MKConnectionStateConnected;

  [_tableView beginUpdates]; 
  [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade]; 
  [_tableView endUpdates];
  
  [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
  
  [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];
}

- (void)disconnected:(NSNotification *)aNotification;
{
  connectionState=MKConnectionStateDisconnected;
  [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (void)versionResponse:(NSNotification *)aNotification;
{
//  self.versionString = [[MKConnectionController sharedMKConnectionController]longVersionForAddress:kIKMkAddressFC]; 
//  [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:CONNECT_SECTIONID]  withRowAnimation:UITableViewRowAnimationNone];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

@end
