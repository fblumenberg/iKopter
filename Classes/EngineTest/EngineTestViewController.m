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
#import "EngineValues.h"
#import "EngineTestViewController.h"
#import "EngineTestSliderCell.h"
#import "TTCorePreprocessorMacros.h"


//////////////////////////////////////////////////////////////////////////////////////////////

@interface EngineTestViewController ()
- (IBAction)engineValueChangedForAllAction:(UISlider *)sender;
- (IBAction)engineValueChangedAction:(UISlider *)sender;
@end

//////////////////////////////////////////////////////////////////////////////////////////////
@implementation EngineTestViewController

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIBarButtonItem* spacer;
  spacer =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
              target:nil
              action:nil] autorelease];
  
  NSArray* segmentItems = [NSArray arrayWithObjects:@"Quadro",@"Hexa",@"Okto",nil];
  segment = [[UISegmentedControl alloc] initWithItems:segmentItems];
  segment.segmentedControlStyle=UISegmentedControlStyleBar;
  
  [segment addTarget:self
              action:@selector(changeDevice)
    forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem* segmentButton;
  segmentButton =  [[[UIBarButtonItem alloc]
                     initWithCustomView:segment] autorelease];
  
 	[self setToolbarItems:[NSArray arrayWithObjects:spacer,segmentButton,spacer,nil]];
  
  segment.selectedSegmentIndex=0;
}


//////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  engineValues = [[EngineValues alloc] init];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [engineValues start];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [engineValues stop];
  TT_RELEASE_SAFELY(engineValues);
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  if(section==0)
    return 1;
  
  // Return the number of rows in the section.
  static NSInteger numberOfRows[3]={4,6,8};
  return numberOfRows[segment.selectedSegmentIndex];
}

- (IBAction) changeDevice {
  [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"MotorTestSliderCell";
  
  EngineTestSliderCell *cell = (EngineTestSliderCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[[EngineTestSliderCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
  }
  
  if(indexPath.section==0 ) {
    cell.textLabel.text = [NSString stringWithFormat:@"All", [indexPath row]];
    
    [cell.valueSlider addTarget:self 
                         action:@selector(engineValueChangedForAllAction:) 
               forControlEvents:UIControlEventValueChanged ];
  }
  else {
    
    cell.textLabel.text = [NSString stringWithFormat:@"Motor %d", [indexPath row]+1];
    cell.valueSlider.tag = indexPath.row;
    
    [cell.valueSlider addTarget:self 
                         action:@selector(engineValueChangedAction:) 
               forControlEvents:UIControlEventValueChanged];
  }
  
  return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (IBAction)engineValueChangedForAllAction:(UISlider *)sender {
  [engineValues setValueForAllEngines:(uint8_t)(sender.value*255.0)];
}

- (IBAction)engineValueChangedAction:(UISlider *)sender {
  NSInteger theEngine=sender.tag;
  [engineValues setValueForEngine:theEngine value:(uint8_t)(sender.value*255.0)];
}



//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
  TT_RELEASE_SAFELY(segment);
}


- (void)dealloc {
  TT_RELEASE_SAFELY(engineValues);
  [super dealloc];
}


@end

