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

#import "SettingsSelectionViewController.h"
#import "SettingViewController.h"
#import "MKConnectionController.h"

#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadEncode.h"

#import "MKDataConstants.h"

#import "IKParamSet.h"

#import "UIViewController+SplitView.h"

#import "MixerViewController.h"
#import "ChannelsViewController.h"
#import "EngineTestViewController.h"

static NSUInteger kNumberOfSettings = 5;

@interface SettingsSelectionViewController (Private)

@end

// ///////////////////////////////////////////////////////////////////////////////

@implementation SettingsSelectionViewController

@synthesize settings=_settings;

// ///////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark View lifecycle


- (id)init {
  
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.title = NSLocalizedString(@"Settings",@"Settings controller title");
    self.hidesBottomBarWhenPushed=NO;
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(readSettingNotification:)
             name:MKReadSettingNotification
           object:nil];

  [nc addObserver:self
         selector:@selector(changeSettingNotification:)
             name:MKChangeSettingNotification
           object:nil];
  
  
  [self.tableView setAllowsSelectionDuringEditing:YES];
  
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];
   
  self.settings=nil;
  [_settings release];
}


- (void)dealloc {
  [super dealloc];
  [_settings release];
}

// ////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:NO];
  [[MKConnectionController sharedMKConnectionController] activateFlightCtrl];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self cancelEditActiveSetting:self]; 
  [self reloadAllSettings];
  
//  UIBarButtonItem* actionButton;
//  
//  actionButton =  [[[UIBarButtonItem alloc]
//                    initWithTitle:NSLocalizedString(@"Change Active",@"")
//                            style:UIBarButtonItemStyleBordered|UIBarButtonItemStyleDone
//                            target:self
//                            action:@selector(saveActiveSetting:)] autorelease];
//  
//  
//	[self setToolbarItems:[NSArray arrayWithObject:actionButton] animated:YES];
}

-(void) viewWillDisappear:(BOOL)animated {

  if (self.navigationController.topViewController != self)
  {
    if(self.isPad)
      [self.detailViewController popToRootViewControllerAnimated:YES];
  }  
  
  [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}
// ////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (IBAction) reloadAllSettings {

  NSMutableArray * settings = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < kNumberOfSettings; i++) {
    [settings addObject:[NSNull null]];
  }
  self.settings = settings;
  [settings release];
  
  activeSetting=0xFF;
  [[MKConnectionController sharedMKConnectionController] requestSettingForIndex:0xFF];
  
}



- (void) readSettingNotification:(NSNotification *)aNotification {

  IKParamSet* paramSet=[[aNotification userInfo] objectForKey:kIKDataKeyParamSet];
  NSUInteger index = [[paramSet Index]unsignedIntValue]-1;
  
  if (activeSetting==0xFF) {
    activeSetting=index;
    if(![paramSet isValid]){
      
      UIAlertView *alert = [[UIAlertView alloc] 
                            initWithTitle:NSLocalizedString(@"Flight-Ctrl wrong Version", @"Setting read error")
                            message:NSLocalizedString(@"Flight-Ctrl is NOT compatible to this App!\nPlease update to the lastest App AND firmware versions.",@"Setting read error msg") 
                            delegate:nil 
                            cancelButtonTitle:@"Ok" 
                            otherButtonTitles:nil];
      [alert show];
      [alert release];
      [self.navigationController popViewControllerAnimated:YES]; 
      return;
    }
  }
  
  [self.settings replaceObjectAtIndex:index withObject:paramSet];

  BOOL allSettingsLoaded=YES;
  for (int i=0; i<kNumberOfSettings; i++) {
    if ([self.settings objectAtIndex:i] == [NSNull null]) {
      [[MKConnectionController sharedMKConnectionController] requestSettingForIndex:i+1];
      allSettingsLoaded=NO;
      break;
    }   
  }
  
  if(allSettingsLoaded){
     [[MKConnectionController sharedMKConnectionController] setActiveSetting:activeSetting+1];
  }

  [self.tableView reloadData];
}


//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.tableView.editing?1:2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section==0)
    return [self.settings count];
  
  return 3;
}

//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *) cellForSetting: (UITableView *) tableView indexPath: (NSIndexPath *) indexPath  {
  static NSString *CellIdentifier = @"SettingsSelectionCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }

  NSUInteger row = [indexPath row];
  IKParamSet* setting=[self.settings objectAtIndex:row]; 

  if ((NSNull *)setting == [NSNull null]) {
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Setting #%d",@"Setting i"), row];
    
    UIActivityIndicatorView *activityView = 
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [cell setAccessoryView:activityView];
    [activityView release];
  } 
  else {

    cell.textLabel.text = [setting Name];
    cell.accessoryView = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }

  
  int currActiveSetting= self.tableView.editing? newActiveSetting:activeSetting;
  
  if( row == currActiveSetting ){
    UIImage *image = [UIImage imageNamed:@"star.png"];
    cell.imageView.image = image;
  }
  else {
    cell.imageView.image = nil;
  }
  
  
  return cell;

}

//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *) cellForExtra: (UITableView *) tableView indexPath: (NSIndexPath *) indexPath  {
  static NSString *CellIdentifier = @"SettingsMixerCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
  }
  
  switch (indexPath.row) {
    case 0:
      cell.textLabel.text = NSLocalizedString(@"Mixer",@"Mixer cell");
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

//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.section==0)
    return [self cellForSetting: tableView indexPath: indexPath];

  return [self cellForExtra: tableView indexPath: indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
  return NO;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0;
}

#pragma mark - Actions

- (void) changeSettingNotification:(NSNotification *)aNotification {
  
  NSDictionary* d=[aNotification userInfo];
  
  NSInteger index = [[d objectForKey:kMKDataKeyIndex] integerValue]-1;
  
  activeSetting=index;
  
//  [self cancelEditActiveSetting:self];
}

- (void)saveActiveSetting:(id)sender
{
  [[MKConnectionController sharedMKConnectionController] setActiveSetting:newActiveSetting+1];
}

- (void)editActiveSetting:(id)sender
{
  [self.navigationController setToolbarHidden:NO animated:YES];
  
  UIBarButtonItem *cancelButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
                                                                                target:self
                                                                                action:@selector(cancelEditActiveSetting:)]autorelease];
  
  [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
 
  newActiveSetting = activeSetting;
  
  [self.tableView setEditing:YES animated:YES];
  [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)cancelEditActiveSetting:(id)sender
{
  [self.navigationController setToolbarHidden:YES animated:YES];
  
//  UIBarButtonItem *editButton = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
//                                                                             target:self
//                                                                             action:@selector(editActiveSetting:)]autorelease];
//  
//  [self.navigationItem setRightBarButtonItem:editButton animated:NO];
  [self.tableView setEditing:NO animated:YES];
  
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger row = [indexPath row];
  
  if( (self.tableView.editing && indexPath.section!=0) || ([self.settings objectAtIndex:row] == [NSNull null]) )
    return nil;
  
  return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
  NSUInteger row = [indexPath row];
  
  if (self.tableView.editing ) {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0 && newActiveSetting != row) {
      NSArray *row0 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:newActiveSetting inSection:0]];  
      newActiveSetting = row;
      NSArray *row1 = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:newActiveSetting inSection:0]];  
      
      [self.tableView beginUpdates];
      [self.tableView reloadRowsAtIndexPaths:row0 withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView reloadRowsAtIndexPaths:row1 withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView endUpdates];
    }
  }
  else {
    if( indexPath.section==0 ) {
      [tableView deselectRowAtIndexPath:indexPath animated:YES];

      IKParamSet* setting=[self.settings objectAtIndex:row]; 
      SettingViewController* settingView = [[SettingViewController alloc] initWithSetting:setting];
      
      [self.navigationController setToolbarHidden:NO animated:NO];
      
      [self.navigationController pushViewController:settingView animated:YES];
      [settingView release];
    }
    else {

      if(!self.isPad)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

      MixerViewController* extraView=nil;

      switch (indexPath.row) {
        case 0:
          extraView = [[MixerViewController alloc] initWithStyle:UITableViewStylePlain];
          break;
        case 1:
          extraView = [[EngineTestViewController alloc] initWithStyle:UITableViewStyleGrouped];
          break;
        case 2:
          extraView = [[ChannelsViewController alloc] initWithStyle:UITableViewStylePlain];
          break;
      }

      if(self.isPad){
        BOOL animated=self.isRootForDetailViewController;
        extraView.navigationItem.hidesBackButton=YES;
        [self.detailViewController popToRootViewControllerAnimated:NO];
        [self.detailViewController pushViewController:extraView animated:animated];
      }
      else
        [self.navigationController pushViewController:extraView animated:YES];

      [self.navigationController setToolbarHidden:NO animated:NO];
      
      [extraView release];
    }
  }
}




@end

