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

#import "WaypointListViewController.h"
#import "WaypointViewController.h"
#import "IKPoint.h"
#import "IASKPSTextFieldSpecifierViewCell.h"
#import "IASKTextField.h"

@implementation WaypointListViewController

@synthesize list;
@synthesize addButton;

- (id)initWithList:(IKPointList*) aList {
  if ((self =  [super initWithStyle:UITableViewStyleGrouped])) {
    self.list=aList;
    self.title=NSLocalizedString(@"Waypoint List", @"Waypoint Lists title");
  }
  return self;
}

- (void)dealloc
{
  self.list = nil;
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
  self.list = nil;
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
  
  if( editingPoint ) {
    
    NSArray* indexPaths=[NSArray arrayWithObject:editingPoint];
    
    NSLog(@"appear reload %@",indexPaths);
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:indexPaths 
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    editingPoint=nil;
  }
}

#pragma mark -
#pragma mark UITextFieldDelegate Functions

- (void)_textChanged:(id)sender {
  IASKTextField *text = (IASKTextField*)sender;
  list.name=text.text;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[textField setTextAlignment:UITextAlignmentLeft];
//	self.currentFirstResponder = textField;
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//	self.currentFirstResponder = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
	return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if(section==0) 
    return 1;
  
  return [self.list count];
}

//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *) cellForExtra: (UITableView *) tableView indexPath: (NSIndexPath *) indexPath  {
  static NSString *CellIdentifier = @"WaypointExtraCell";

  IASKPSTextFieldSpecifierViewCell *cell = (IASKPSTextFieldSpecifierViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (!cell) {
    cell = (IASKPSTextFieldSpecifierViewCell*) [[[NSBundle mainBundle] loadNibNamed:@"IASKPSTextFieldSpecifierViewCell" 
                                                                              owner:self 
                                                                            options:nil] objectAtIndex:0];
    
    cell.textField.textAlignment = UITextAlignmentLeft;
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
  
  [[cell label] setText:NSLocalizedString(@"Name", @"Waypoint List name label")];      
  
  [[cell textField] setText:list.name];
  
  [[cell textField] setDelegate:self];
  [[cell textField] addTarget:self action:@selector(_textChanged:) forControlEvents:UIControlEventEditingChanged];
  [[cell textField] setSecureTextEntry:NO];
  [[cell textField] setKeyboardType:UIKeyboardTypeAlphabet];
  [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
  [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
  [cell setNeedsLayout];
  return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSLog(@"cellForRowAtIndexPath %@",indexPath);
  
  if(indexPath.section==0){
    return [self cellForExtra:tableView indexPath:indexPath];
  }
  
  static NSString *CellIdentifier = @"IKPointListCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }
  
  IKPoint* point = [self.list pointAtIndexPath:indexPath];
  
  cell.textLabel.text = [NSString stringWithFormat:@"Waypoint %d",point.index];
//  cell.detailTextLabel.text = host.address;
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section==1;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source.
    [self.list deletePointAtIndexPath:indexPath];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
  }   
  else if (editingStyle == UITableViewCellEditingStyleInsert) {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
  }   
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  [self.list movePointAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section==1;
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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.editing || indexPath.section==0 ) {
    return nil;
  }
  
  return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if( indexPath.section==1 ){
    IKPoint* point=[self.list pointAtIndexPath:indexPath];
    if (!self.tableView.editing ) {
      
      WaypointViewController* hostView = [[WaypointViewController alloc] initWithPoint:point];
      editingPoint = indexPath;
      [self.navigationController pushViewController:hostView animated:YES];
      [hostView release];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addHost {
  
  editingPoint=[self.list addPoint];
  
  NSArray* indexPaths=[NSArray arrayWithObject:editingPoint];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths 
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
  
  IKPoint* point = [self.list pointAtIndexPath:editingPoint];
  WaypointViewController* hostView = [[WaypointViewController alloc] initWithPoint:point];
  [self.navigationController pushViewController:hostView animated:YES];
  [hostView release];
}

@end
