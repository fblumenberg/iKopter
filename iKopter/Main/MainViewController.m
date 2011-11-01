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
//#import "GradientButton.h"

#import "IASKSettingsStoreObject.h"
#import "IASKPSTitleValueSpecifierViewCell.h"
#import "IASKSpecifier.h"

#import "MBProgressHUD.h"
#import "MBProgressHUD+RFhelpers.h"

#import "MKConnectionController.h"
#import "MKDataConstants.h"
#import "IKDeviceVersion.h"

#import "UIViewController+SplitView.h"

#import "OsdTabBarController.h"

@implementation MainViewController

@synthesize host=_host;

#pragma mark -

- (id)initWithHost:(MKHost*)theHost {
  
  if (self =  [super initWithNibName:@"IASKAppSettingsView" bundle:nil]) {
    self.file = @"Main";
    self.settingsStore = [[[IASKSettingsStoreObject alloc] initWithObject:nil] autorelease];
    
    self.showCreditsFooter=NO;
    self.showDoneButton=NO;
    
    self.title = theHost.name;
    self.host = theHost;

    connectionState=MKConnectionStateDisconnected;
    
    self.delegate=self;
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
             name:MKFoundDeviceNotification
           object:nil];

  [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  if( ![[MKConnectionController sharedMKConnectionController] isRunning]) {
    
    [MBProgressHUD sharedProgressHUD].labelText=NSLocalizedString(@"Connecting",@"HUD connecting");
    [[MBProgressHUD sharedProgressHUD] show:YES];
    
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
  [[MBProgressHUD sharedProgressHUD] hide:NO];
  NSNotificationCenter* nc=[NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
  
  if (self.navigationController.topViewController != self){
    if(self.isPad)
      [self.detailViewController popToRootViewControllerAnimated:YES];
  }  
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

  qltrace(@"%d state %d",section,connectionState);

  if(connectionState==MKConnectionStateConnected )
    return [super tableView:tableView numberOfRowsInSection:section];
 
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  qltrace(@"%@ state %d",indexPath,connectionState);

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



- (CGFloat)tableView:(UITableView*)tableView heightForSpecifier:(IASKSpecifier*)specifier {
		return 44;
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
  
  UITableViewCell* cell = (UITableViewCell*)(gestureRecognizer.view);
  [cell setSelected:YES animated:NO];
  
  OsdTabBarController* tbc = [[[OsdTabBarController alloc] initWithNibName:nil bundle:nil]autorelease];
  UINavigationController* nc= [[[UINavigationController alloc] initWithRootViewController:tbc]autorelease];
  
  nc.navigationBar.barStyle=UIBarStyleDefault;
  nc.navigationBar.translucent=YES;
  
  if( [self isPad]){
    [self.splitViewController presentModalViewController:nc animated:YES];
  }
  else
    [self presentModalViewController:nc animated:YES];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSpecifier:(IASKSpecifier*)specifier {
  UITableViewCell *cell = nil;
  if( [specifier.key isEqualToString:@"OSD"] ){
    static NSString *CellIdentifier = @"OSDCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = NSLocalizedString(@"OSD",@"OSD button link");
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
    [cell addGestureRecognizer:singleTap];
    [singleTap release];
    
  }
  else{
    static NSString *CellIdentifier = @"DeviceInfoCell";
    
    IKMkAddress address=kIKMkAddressMK3MAg;
    
    if( [specifier.key isEqualToString:@"NC"] ) 
      address=kIKMkAddressNC;
    else if( [specifier.key isEqualToString:@"FC"] ) 
      address=kIKMkAddressFC;
    
    IKDeviceVersion* v = [[MKConnectionController sharedMKConnectionController] versionForAddress:address];
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(v){  
      cell.textLabel.text = v.versionString;
      cell.detailTextLabel.text = v.hasError?@"\ue219":@"\ue21a"; 
    }
    else{
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      cell.textLabel.text = [specifier title];
      cell.detailTextLabel.text=NSLocalizedString(@"not available", @"Device not available");
    }
  }
  
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  static IKMkAddress addressMapping[3]={kIKMkAddressNC, kIKMkAddressFC, kIKMkAddressMK3MAg};
  
  NSLog(@"didSelectRowAtIndexPath %d %d",[indexPath section],[indexPath row]);
  if([indexPath section]==0)
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  else{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    
    IKMkAddress address=addressMapping[[indexPath row]];
    IKDeviceVersion* v=[[MKConnectionController sharedMKConnectionController] versionForAddress:address];
    
    if(v){
      NSString *msg;
      
      if([v hasError])
        msg = [[v errorDescriptions] componentsJoinedByString:@"\n"];
      else 
        msg = NSLocalizedString(@"No Errors",@"");
      
      UIAlertView *alert = [[UIAlertView alloc] 
                            initWithTitle:v.versionString 
                            message:msg 
                            delegate:self 
                            cancelButtonTitle:NSLocalizedString(@"OK",@"") 
                            otherButtonTitles:nil];
      [alert show];
      [alert release];
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Connection status actions (Statemachine)

- (void)userDidDisconnect;
{
  [self setToolbarItems:[NSArray array]];
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
  [[MBProgressHUD sharedProgressHUD] hideAnimated:NO];

  [UIApplication sharedApplication].idleTimerDisabled=NO;
  
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
  qltrace(@"Got connected");
  _tableView.userInteractionEnabled=YES;

  connectionState=MKConnectionStateConnected;

  [_tableView reloadData];
  
  [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
  [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];

  [[MBProgressHUD sharedProgressHUD] hide:YES];
  
  [UIApplication sharedApplication].idleTimerDisabled=YES;
}

- (void)disconnected:(NSNotification *)aNotification;
{
  [[MBProgressHUD sharedProgressHUD] hide:NO];

  connectionState=MKConnectionStateDisconnected;
  [UIApplication sharedApplication].idleTimerDisabled=NO;
  [self.navigationController popToRootViewControllerAnimated:YES]; 
}

- (void)versionResponse:(NSNotification *)aNotification;
{
  IKDeviceVersion* version = [[aNotification userInfo] objectForKey:kIKDataKeyVersion];
  [MBProgressHUD sharedProgressHUD].labelText=[NSString stringWithFormat:NSLocalizedString(@"Found %@",@"HUD device"),version.deviceName];
}

#pragma mark - IASKSettingsDelegate

- (UINavigationController*) navigationControllerForChildPaneForKey:(NSString*)key{
  
  if([key isEqualToString:@"Settings"]||[key isEqualToString:@"Routes"])
    return nil;
  
  self.detailViewController.navigationBar.barStyle=UIBarStyleDefault;
  
  return self.detailViewController;
}


@end
