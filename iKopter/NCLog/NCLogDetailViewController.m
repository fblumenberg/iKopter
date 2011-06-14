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

#import "NCLogDetailViewController.h"
#import "NCLogRecord.h"
#import "CHCSVWriter.h"

@interface NCLogDetailViewController()

-(void)sendSessionAsEmail;
-(void)uploadSession;
-(void)deleteSession;

@end

@implementation NCLogDetailViewController

@synthesize session;
@synthesize startDate,endDate,records;

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

  UIBarButtonItem* delete;
  delete =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
              target:self
              action:@selector(deleteSession)] autorelease];

  UIBarButtonItem* action;
  action =  [[[UIBarButtonItem alloc]
              initWithBarButtonSystemItem:UIBarButtonSystemItemAction
              target:self
              action:@selector(uploadSession)] autorelease];

 	[self setToolbarItems:[NSArray arrayWithObjects:mail,spacer,delete,spacer,action,nil]];

}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  self.startDate.text=[NSDateFormatter localizedStringFromDate:session.timeStampStart dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
  self.endDate.text=[NSDateFormatter localizedStringFromDate:session.timeStampEnd dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle];
  self.records.text=[NSString stringWithFormat:@"%d",[session.records count]];

}

- (void)viewDidUnload
{
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma - Actions

-(void)uploadSession{
  
}

-(void)deleteSession{
  
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

-(void)sendSessionAsEmail{
  if ([MFMailComposeViewController canSendMail]) {
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    
    [mailViewController setSubject:NSLocalizedString(@"NaviCtrl Log-Data", "NC-Log Subject")];
    
    NSString* bodyText= [NSString stringWithFormat:NSLocalizedString(@"NaviCtlr logging session from %@ to %@  contains %d records",@"NC-Log Body"), 
                         [NSDateFormatter localizedStringFromDate:session.timeStampStart dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle],
                         [NSDateFormatter localizedStringFromDate:session.timeStampEnd dateStyle:kCFDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle],
                         [session.records count]];
    
    [mailViewController setMessageBody:bodyText isHTML:NO];
    
    NSString *fileName = [NSTemporaryDirectory() stringByAppendingString:@"/CSVFile.csv"];
    CHCSVWriter* csvWriter=[[[CHCSVWriter alloc] initWithCSVFile:fileName atomic:YES]autorelease];
    
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

    NSData *csvData = [NSData dataWithContentsOfFile:fileName];
    [[NSFileManager defaultManager]removeItemAtPath:fileName error:nil];
    
    [mailViewController addAttachmentData:csvData mimeType:@"text/csv" fileName:@"CSVFile.csv"];
    
    mailViewController.mailComposeDelegate = self;
    [self presentModalViewController:mailViewController animated:YES];
    [mailViewController release];
    
    
    
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


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate Function

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
  // NOTE: No error handling is done here
  [self dismissModalViewControllerAnimated:YES];
}

@end
