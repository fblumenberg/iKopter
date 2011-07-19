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

#import "MKHostsViewController.h"
#import "MKHost.h"
#import "MKHostViewController.h"


@implementation MKHostsViewController

@synthesize hosts;
@synthesize addButton;

- (id)initWithHosts:(MKHosts *)theHostList {
  if ((self =  [super initWithStyle:UITableViewStylePlain])) {
    self.hosts=theHostList;
    self.title=NSLocalizedString(@"MK Connections", @"MKHost List title");
  }
  return self;
}

- (void)dealloc
{
  self.hosts = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.addButton =  [[[UIBarButtonItem alloc]
                 initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                 target:self
                 action:@selector(addHost)] autorelease];
  self.addButton.style = UIBarButtonItemStyleBordered;
  
  UIBarButtonItem* spacerButton;
  spacerButton =  [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil
                    action:nil] autorelease];
  
  [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,self.addButton,nil]];
  self.tableView.allowsSelectionDuringEditing=YES;
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  self.hosts = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:NO];
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
    
    [self.hosts save];
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.hosts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"MKHostCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  MKHost* host = [self.hosts hostAtIndexPath:indexPath];
  
  cell.imageView.image = [host cellImage];
  cell.textLabel.text = host.name;
  cell.detailTextLabel.text = host.address;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
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
    [self.hosts deleteHostAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [self.hosts moveHostAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section==0;
}

- (void) setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing: editing animated: animated];
  
  UIBarButtonItem* spacerButton;
  spacerButton =  [[[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                    target:nil
                    action:nil] autorelease];
  if(editing)
    [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,nil] animated:YES];
  else
    [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,self.addButton,nil] animated:YES];
}

//
//-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//  
//  UIBarButtonItem* spacerButton;
//  spacerButton =  [[[UIBarButtonItem alloc]
//                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                    target:nil
//                    action:nil] autorelease];
//  
//  [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,nil] animated:YES];
//
//}
//
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//  
//  UIBarButtonItem* spacerButton;
//  spacerButton =  [[[UIBarButtonItem alloc]
//                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                    target:nil
//                    action:nil] autorelease];
//  
//  [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,self.addButton,nil] animated:YES];
//}
//
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
  
  if( indexPath.section==0 ){
    MKHost* host=[self.hosts hostAtIndexPath:indexPath];
    if (!self.tableView.editing ) {
      MKHostViewController* hostView = [[MKHostViewController alloc] initWithHost:host];
      editingHost = indexPath;
      [self.navigationController pushViewController:hostView animated:YES];
      [hostView release];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addHost {
  
  editingHost=[self.hosts addHost];
  
  NSArray* indexPaths=[NSArray arrayWithObject:editingHost];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths 
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
  
  MKHost* host=[self.hosts hostAtIndexPath:editingHost]; 
  MKHostViewController* hostView = [[MKHostViewController alloc] initWithHost:host];
  [self.navigationController pushViewController:hostView animated:YES];
  [hostView release];   
}

@end
