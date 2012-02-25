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

#import "ChannelsViewController.h"
#import "ChannelsViewCell.h"
#import "MKConnectionController.h"
#import "NSData+MKCommandEncode.h"
#import "MKDataConstants.h"

#define kAnalogLabelFile @"AnalogLables.plist"

@interface ChannelsViewController (Private)
- (void) channelsValueNotification:(NSNotification *)aNotification;
- (void) requestChannelData;
@end

// ///////////////////////////////////////////////////////////////////////////////

@implementation ChannelsViewController

@synthesize updateTimer = _updateTimer;

#pragma mark -
#pragma mark View lifecycle

- (void) viewDidLoad {
  [super viewDidLoad];
    
  
}

- (void) viewWillAppear:(BOOL)animated {
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(channelsValueNotification:)
             name:MKChannelValuesNotification
           object:nil];

  [super viewWillAppear:animated];
  
  self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                      target:self 
                                                    selector:@selector(requestChannelData) 
                                                    userInfo:nil 
                                                     repeats:YES];
  [self requestChannelData];
}

- (void) viewDidDisappear:(BOOL)animated {

  [self.updateTimer invalidate];
  self.updateTimer=nil;
  [_updateTimer release];
  
  NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
  [nc removeObserver:self];

  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

#pragma mark -
#pragma mark Memory management

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) viewDidUnload {
}

- (void) dealloc {
  [super dealloc];
}

// ////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -

- (void) requestChannelData {
  
  MKConnectionController * cCtrl = [MKConnectionController sharedMKConnectionController];
  NSData * data = [NSData dataWithCommand:MKCommandChannelsValueRequest
                               forAddress:kIKMkAddressFC
                         payloadWithBytes:NULL
                                   length:0];

  [cCtrl sendRequest:data];
}

- (void) channelsValueNotification:(NSNotification *)aNotification {
  
  NSData* data = [[aNotification userInfo] objectForKey:kMKDataKeyChannels];
  
  if([data length]>=sizeof(channelValues))
    memcpy(channelValues, [data bytes], sizeof(channelValues));
  
  [self.tableView reloadData];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 25;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell * cell;
  if(indexPath.row==0){
    static NSString * CellIdentifier = @"ChannelsRSSITableCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = NSLocalizedString(@"RSSI", @"Channels Test");
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",channelValues[indexPath.row]];
  }
  else {
    
    static NSString * CellIdentifier = @"ChannelsTableCell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
      cell = [[[ChannelsViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if(indexPath.row<13)
      cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"RC Channel %d","Channel test"),indexPath.row];
    else     
      cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Serial %d","Channel test"),indexPath.row];
    
    [(ChannelsViewCell*)cell setChannelValue:channelValues[indexPath.row]];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",channelValues[indexPath.row]];
  }
  return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return nil;
}

@end

