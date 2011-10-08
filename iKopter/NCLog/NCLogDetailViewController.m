// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
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

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

#import "NCLogDetailViewController.h"
#import "NCLogRecord.h"
#import "IKNaviData.h"
#import "CHCSVWriter.h"
#import "UIViewController+SplitView.h"

#import "IKDropboxController.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+RFhelpers.h"

@interface NCLogDetailViewController() <DBRestClientDelegate>

-(void)sendSessionAsEmail;
-(void)uploadSession;
-(NSString*)writeCSVForSession;
-(void)deleteSession;

@property(nonatomic,retain) UIActionSheet* deleteQuerySheet;
@property(nonatomic,retain) UIBarButtonItem* deleteItem;
- (void)hideActionSheet;

@end

@implementation NCLogDetailViewController
@synthesize mapView;

@synthesize session;
@synthesize startDate,endDate,records;
@synthesize deleteQuerySheet;
@synthesize deleteItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)dealloc
{
  self.deleteItem=nil;
  [mapView release];
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIBarButtonItem* spacer;
  spacer =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
              target:nil
              action:nil] autorelease];

  UIBarButtonItem* mail;
  mail =  [[[UIBarButtonItem alloc]
              initWithImage:[UIImage imageNamed:@"icon-mail1.png"] 
              style:UIBarButtonItemStylePlain
              target:self
              action:@selector(sendSessionAsEmail)] autorelease];

  self.deleteItem =  [[[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                       target:self
                       action:@selector(deleteSession)] autorelease];

  UIBarButtonItem* action;
  action =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAction
              target:self
              action:@selector(uploadSession)] autorelease];

 	[self setToolbarItems:[NSArray arrayWithObjects:mail,spacer,self.deleteItem,spacer,action,nil]];
  self.navigationController.toolbarHidden=NO;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if(self.isPad)
    self.navigationItem.hidesBackButton=YES;
    
  self.startDate.text=[NSDateFormatter localizedStringFromDate:session.timeStampStart dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
  self.endDate.text=[NSDateFormatter localizedStringFromDate:session.timeStampEnd dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
  self.records.text=[NSString stringWithFormat:@"%d",[session.records count]];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  // here's where you specify the sort
  NSSortDescriptor* sortDescriptor = [[[NSSortDescriptor alloc]
                                       initWithKey:@"timeStamp" ascending:YES]autorelease];
  NSArray* sortDescriptors = [[[NSArray alloc] initWithObjects: sortDescriptor, nil] autorelease];
  
  NSArray* sortedRecords=[[session.records allObjects]sortedArrayUsingDescriptors: sortDescriptors];
  
  NSLog(@"%@",sortedRecords);
  
  CLLocationCoordinate2D coordinates[[sortedRecords count]];
  [self.mapView removeOverlays:self.mapView.overlays];
  
  int i=0;
  for (NCLogRecord* r in sortedRecords) {
    coordinates[i]=r.currentPosition.coordinate;
    i++;
  }
  
  [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coordinates count:i]];
  
  MKMapRect flyTo = MKMapRectNull;
  
  for (id <MKOverlay> overlay in mapView.overlays) {
    if (MKMapRectIsNull(flyTo)) {
      flyTo = [overlay boundingMapRect];
    } else {
      flyTo = MKMapRectUnion(flyTo, [overlay boundingMapRect]);
    }
  }
  
  flyTo = [mapView mapRectThatFits:flyTo];
  
  // Position the map so that all overlays and annotations are visible on screen.
  [mapView setVisibleMapRect:flyTo animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [self hideActionSheet];
  self.mapView.delegate=nil;
}

- (void)viewDidUnload
{
  [self setMapView:nil];
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
	
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		
		MKPolylineView *polylineView = [[[MKPolylineView alloc] initWithPolyline:overlay] autorelease];
		polylineView.strokeColor = [UIColor blueColor];
		polylineView.lineWidth = 1.5;
		return polylineView;
	}
	
	return nil;
}
#pragma - Actions

-(void)uploadSession{
  
  [[MBProgressHUD sharedProgressHUD] setLabelText:NSLocalizedString(@"Uploading", @"DB upload NC-Log HUD")];
  [[MBProgressHUD sharedProgressHUD] show:YES];

  NSString *fileName = [self writeCSVForSession];
  IKDropboxController* dbCtrl=[IKDropboxController sharedIKDropboxController];
  
  dbCtrl.restClient.delegate=self;
  
  [dbCtrl.restClient uploadFile:[fileName lastPathComponent] toPath:dbCtrl.dataPath fromPath:fileName];
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath{
  [[MBProgressHUD sharedProgressHUD] hide:YES];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error{
  [[MBProgressHUD sharedProgressHUD] hide:YES];
  [IKDropboxController showError:error withTitle:NSLocalizedString(@"Upload failed", @"NC-Log upload Error Title")];
}


-(void)deleteSession{
  
  self.deleteQuerySheet = [[[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Cancel",@"Cancel Button") 
                                         destructiveButtonTitle:NSLocalizedString(@"Delete", @"Delete Button") 
                                              otherButtonTitles:nil, nil] autorelease];
  self.deleteQuerySheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
  
  [self.deleteQuerySheet showFromBarButtonItem:self.deleteItem animated:YES];
  
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if(buttonIndex==actionSheet.cancelButtonIndex)
    return;
  
  if(buttonIndex == actionSheet.destructiveButtonIndex){
    // Delete the managed object for the given index path
    NSManagedObjectContext *context = [self.session managedObjectContext];
    [context deleteObject:self.session];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
    
    
    [self.navigationController popViewControllerAnimated:YES]; 

  }
  self.deleteQuerySheet=nil;
}

- (void)hideActionSheet{
  [self.deleteQuerySheet dismissWithClickedButtonIndex:self.deleteQuerySheet.cancelButtonIndex animated:NO];
}


-(void)sendSessionAsEmail{
  if ([MFMailComposeViewController canSendMail]) {
    
    [[MBProgressHUD sharedProgressHUD] showAnimated:YES];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        
        [mailViewController setSubject:NSLocalizedString(@"NaviCtrl Log-Data", "NC-Log Subject")];
        
        NSString* bodyText= [NSString stringWithFormat:NSLocalizedString(@"NaviCtlr logging session from %@ to %@  contains %d records",@"NC-Log Body"), 
                             [NSDateFormatter localizedStringFromDate:session.timeStampStart dateStyle:kCFDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle],
                             [NSDateFormatter localizedStringFromDate:session.timeStampEnd dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle],
                             [session.records count]];
        
        [mailViewController setMessageBody:bodyText isHTML:NO];
        
        NSString *fileName = [self writeCSVForSession];
        NSData *csvData = [NSData dataWithContentsOfFile:fileName];
        [[NSFileManager defaultManager]removeItemAtPath:fileName error:nil];
        
        [mailViewController addAttachmentData:csvData mimeType:@"text/csv" fileName:[fileName lastPathComponent]];
        
        mailViewController.mailComposeDelegate = self;
        
        [[MBProgressHUD sharedProgressHUD] hide:YES];
        
        [self presentModalViewController:mailViewController animated:YES];
        [mailViewController release];
      });
      
    });
    
  } else {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:NSLocalizedString(@"Mail not configured", @"InAppSettingsKit")
                          message:NSLocalizedString(@"This device is not configured for sending Email. Please configure the Mail settings in the Settings app.", @"InAppSettingsKit")
                          delegate: nil
                          cancelButtonTitle:NSLocalizedString(@"OK", @"InAppSettingsKit")
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
  }
}

-(NSString*)writeCSVForSession {
  
  NSDateFormatter *dateFormat = [[[NSDateFormatter alloc] init] autorelease];
  [dateFormat setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];

  NSString *fileName=[NSString stringWithFormat:@"NC-Log-%@-%@", 
                      [dateFormat stringFromDate:session.timeStampStart],
                      [dateFormat stringFromDate:session.timeStampEnd]];
  
  NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:fileName];
  CHCSVWriter* csvWriter=[[[CHCSVWriter alloc] initWithCSVFile:filePath atomic:YES]autorelease];
  
  if([session.records count]>0){
    
    BOOL hasHeader=NO;
    
    for (NCLogRecord* record in session.records) {
      //Get a reference to the entity description for the NSManagedObject subclass - CoreData created entity
      NSEntityDescription * myEntity = [record entity];
      
      //Get all of the attributes that are defined for the entity - not the relationship properties - just attributes
      NSDictionary * attributes = [myEntity attributesByName];
      if(!hasHeader){
        [csvWriter writeLineWithFields:[attributes allKeys]];
        hasHeader=YES;
      }
      
      
      //Loop over the attributes by name  
      for (NSString * attributeName in [attributes allKeys]) {
        
        //Determine if this property is a string
        SEL selector = NSSelectorFromString(attributeName);
        id attributeValue = [record performSelector:selector];
        [csvWriter writeField:[attributeValue description]];
        
      }        
      [csvWriter writeLine];
    }
  }
  
  return filePath;
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Function

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  // NOTE: No error handling is done here
  [self dismissModalViewControllerAnimated:YES];
}

@end
