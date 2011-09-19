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

#import "AnalogViewController.h"
#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "MKDataConstants.h"
#import "UIViewController+SplitView.h"

#import "TTCorePreprocessorMacros.h"

// ///////////////////////////////////////////////////////////////////////////////

@implementation AnalogViewController

- (void) updateSegment {
 
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasNaviCtrl] forSegmentAtIndex:0];
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasFlightCtrl] forSegmentAtIndex:1];
  [segment setEnabled:[[MKConnectionController sharedMKConnectionController] hasMK3MAG] forSegmentAtIndex:2];

  IKMkAddress currentDevice=[MKConnectionController sharedMKConnectionController].currentDevice;
  switch (currentDevice) {
    case kIKMkAddressNC:
      segment.selectedSegmentIndex=0;
      break;
    case kIKMkAddressFC:
      segment.selectedSegmentIndex=1;
      break;
    case kIKMkAddressMK3MAg:
      segment.selectedSegmentIndex=2;
      break;
    default:
      break;
  }
}

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad {

  
  UIBarButtonItem* spacer;
  spacer =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
              target:nil
              action:nil] autorelease];
  
  NSArray* segmentItems = [NSArray arrayWithObjects:@"NaviCtrl",@"FlightCtrl",@"MK3Mag",nil];
  segment = [[UISegmentedControl alloc] initWithItems:segmentItems];
  segment.segmentedControlStyle=UISegmentedControlStyleBar;

  [segment addTarget:self
              action:@selector(changeDevice)
    forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem* segmentButton;
  segmentButton =  [[[UIBarButtonItem alloc]
                    initWithCustomView:segment] autorelease];
  
 	[self setToolbarItems:[NSArray arrayWithObjects:spacer,segmentButton,spacer,nil]];

}

- (void) viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
 
  
    if(self.isPad)
      self.navigationItem.hidesBackButton=YES;
 
  values = [[AnalogValues alloc] init];
  values.delegate = self;
  
  self.navigationController.hidesBottomBarWhenPushed=NO;
  [self.navigationController setToolbarHidden:NO animated:YES];
  
  [self updateSegment];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [values startRequesting];
}

- (void) viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [values stopRequesting];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  
  TT_RELEASE_SAFELY(values);
}

- (void) viewDidUnload {
  TT_RELEASE_SAFELY(segment);
}

#pragma mark -

-(void) reloadAll {
  [values reloadLabels];  
  [self.tableView reloadData];
} 

- (IBAction) changeDevice {
  
  [[MKConnectionController sharedMKConnectionController] activateNaviCtrl];
  
  switch (segment.selectedSegmentIndex) {
    case 1:
      [[MKConnectionController sharedMKConnectionController] activateFlightCtrl];
      break;
    case 2:
      [[MKConnectionController sharedMKConnectionController] activateMK3MAG];
      break;
  }
  
#ifdef DEBUG
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  qltrace(@"Device set to %d", cCtrl.currentDevice);
#endif
  
  [self performSelector:@selector(reloadAll) withObject:self afterDelay:0.1];
}



#pragma mark -
#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [values count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString * CellIdentifier = @"AnalogTableCell";

  UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
  }

  cell.textLabel.text = [values labelAtIndexPath:indexPath];
  cell.detailTextLabel.text = [values valueAtIndexPath:indexPath]; 

  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

#pragma mark -
#pragma mark Analog values delegate

- (void) didReceiveValues {
  [self.tableView reloadData];
}

- (void) didReceiveLabelForIndexPath:(NSIndexPath *)indexPath {
  [self.tableView reloadData];
}

- (void) changed {
  [self.tableView reloadData];
}

@end

