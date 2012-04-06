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

#import "RouteListViewController.h"
#import "WaypointViewController.h"
#import "IKPoint.h"
#import "IASKPSTextFieldSpecifierViewCell.h"
#import "IASKTextField.h"
#import "UIViewController+SplitView.h"

@interface RouteListViewController ()

- (void)routeChangedNotification:(NSNotification *)aNotification;

@end

@implementation RouteListViewController

@synthesize list;
@synthesize editingPoint;

@synthesize surrogateParent;

- (id)initWithRoute:(Route *)aList {
  if ((self = [super initWithStyle:UITableViewStyleGrouped])) {
    self.list = aList;
    self.title = NSLocalizedString(@"Route", @"Waypoint Lists title");

  }
  return self;
}

- (void)dealloc {
  self.list = nil;
  self.editingPoint = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.allowsSelectionDuringEditing = NO;
}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.list = nil;
  self.editingPoint = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  qltrace(@"Reload route list");
  [self.tableView reloadData];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(routeChangedNotification:)
                                               name:MKRouteChangedNotification
                                             object:nil];
}


- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];

  if (self.editingPoint) {
    [self.tableView reloadData];
    self.editingPoint = nil;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate Functions

- (void)_textChanged:(id)sender {
  IASKTextField *text = (IASKTextField *) sender;
  list.name = text.text;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0)
    return 1;

  return [self.list count];
}

//////////////////////////////////////////////////////////////////////////////////////////////

- (UITableViewCell *)cellForExtra:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"WaypointExtraCell";

  IASKPSTextFieldSpecifierViewCell *cell = (IASKPSTextFieldSpecifierViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (!cell) {
    cell = (IASKPSTextFieldSpecifierViewCell *) [[[NSBundle mainBundle] loadNibNamed:@"IASKPSTextFieldSpecifierViewCell"
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

  if (indexPath.section == 0) {
    return [self cellForExtra:tableView indexPath:indexPath];
  }

  static NSString *CellIdentifier = @"IKPointListCell";

  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
  }

  IKPoint *point = [self.list pointAtIndexPath:indexPath];

  if (point.type == POINT_TYPE_WP) {
    cell.imageView.image = [UIImage imageNamed:@"icon-flag.png"];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d - Waypoint", @"Waypoint cell"), point.index];
  } else {
    cell.imageView.image = [UIImage imageNamed:@"icon-poi.png"];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%d - POI", @"POI cell"), point.index];
  }

  cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %d m - %d s - %.0f m/s - %@", 
                               point.name,point.altitude, point.holdTime, 
                               (point.speed*0.1),[point formatHeading]];

  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

  return cell;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return indexPath.section == 1;
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
  return indexPath.section == 1;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  [super setEditing:editing animated:animated];

//  UIBarButtonItem* spacerButton;
//  spacerButton =  [[[UIBarButtonItem alloc]
//                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                    target:nil
//                    action:nil] autorelease];
//  if(editing)
//    [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,nil] animated:YES];
//  else
//    [self setToolbarItems:[NSArray arrayWithObjects:self.editButtonItem,spacerButton,self.addButton,nil] animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (self.tableView.editing || indexPath.section == 0) {
    return nil;
  }

  return indexPath;
}


- (void)showViewControllerForPoint:(IKPoint *)point {
  WaypointViewController *hostView = [[WaypointViewController alloc] initWithPoint:point];
  if (self.isPad) {
    UIPopoverController *popOverController = [[UIPopoverController alloc] initWithContentViewController:hostView];
    popOverController.popoverContentSize = CGSizeMake(320, 500);
    popOverController.delegate = self;


    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.editingPoint];
    [popOverController presentPopoverFromRect:cell.bounds inView:cell.contentView
                     permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
  }
  else {
    [self.surrogateParent.navigationController pushViewController:hostView animated:YES];
  }
  [hostView release];

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  [popoverController release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (indexPath.section == 1) {
    IKPoint *point = [self.list pointAtIndexPath:indexPath];
    if (!self.tableView.editing) {

      self.editingPoint = indexPath;
      [self showViewControllerForPoint:point];
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addPoint {

  self.editingPoint = [self.list addPointAtCenter];

  NSArray *indexPaths = [NSArray arrayWithObject:self.editingPoint];

  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];

  IKPoint *point = [self.list pointAtIndexPath:self.editingPoint];
  [self showViewControllerForPoint:point];

  [Route sendChangedNotification:self];
}

- (void)addPointWithLocation:(CLLocation *)location {

  self.editingPoint = [self.list addPointAtCoordinate:location.coordinate];

  NSArray *indexPaths = [NSArray arrayWithObject:self.editingPoint];

  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:indexPaths
                        withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];

  IKPoint *point = [self.list pointAtIndexPath:self.editingPoint];
  [self showViewControllerForPoint:point];

  [Route sendChangedNotification:self];
}

- (void)routeChangedNotification:(NSNotification *)aNotification {
  if (![aNotification.object isEqual:self] && ![aNotification.object isEqual:self.list])
    [self.tableView reloadData];
}

@end
