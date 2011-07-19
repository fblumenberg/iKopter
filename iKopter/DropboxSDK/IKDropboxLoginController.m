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

#import "IKDropboxLoginController.h"
#import "DBRestClient.h"
#import "MBProgressHUD.h"

@interface IKDropboxLoginController() <DBRestClientDelegate,MBProgressHUDDelegate>

- (void)setWorking:(BOOL)working;
- (void)errorWithTitle:(NSString*)title message:(NSString*)message;

@property (nonatomic, readonly) DBRestClient* restClient;

@end

@implementation IKDropboxLoginController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  
  IKDropboxLoginData* model=[[[IKDropboxLoginData alloc] init] autorelease];
  IKDropboxLoginSource *dataSource = [[[IKDropboxLoginSource alloc] initWithModel:model] autorelease];
  
  self=[super initWithNibName:nil bundle:nil formDataSource:dataSource];
    if (self) {
      self.hidesBottomBarWhenPushed = NO;
      self.title=NSLocalizedString(@"Log In to Dropbox",@"DB Login Link Account");
      dataSource.delegate=self;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark -

- (void)loadView {
	[super loadView];
  
	UIView *view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	[view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	
	UITableView *formTableView = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped] autorelease];
	[formTableView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[self setTableView:formTableView];
	
	[view addSubview:formTableView];
	[self setView:view];
}


- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if( indexPath.section==0 || [(IKDropboxLoginSource *)(self.formDataSource) isUserDataValid] )
    return indexPath;
  
  return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark -

- (void)presentFromController:(UIViewController*)controller {
  UINavigationController* navController = 
  [[[UINavigationController alloc] initWithRootViewController:self] autorelease];
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
  }
  shownModal=YES;
  [controller presentModalViewController:navController animated:YES];
}


-(void) logInToDropbox:(IKDropboxLoginSource *)dataSource{
  [self setWorking:YES];
  
  qltrace(@"start login");
  IKDropboxLoginData* data = (IKDropboxLoginData*)dataSource.model;
  
  [self.restClient loginWithEmail:data.email password:data.password];

}

#pragma mark DBRestClient methods

- (void)restClientDidLogin:(DBRestClient*)client {
  [self setWorking:NO];
  if(shownModal)
    [self.navigationController.parentViewController dismissModalViewControllerAnimated:YES];
  else
    [self.navigationController popViewControllerAnimated:YES];
 
  [self.delegate loginControllerDidLogin:self];
}


- (void)restClient:(DBRestClient*)client loginFailedWithError:(NSError*)error {
  [self setWorking:NO];
  
  qltrace(@"Login error");
  
  
  NSString* message;
  if ([error.domain isEqual:NSURLErrorDomain]) {
    message = NSLocalizedString(@"There was an error connecting to Dropbox.",@"DB Login Err Msg");
  } else {
    NSObject* errorResponse = [[error userInfo] objectForKey:@"error"];
    if ([errorResponse isKindOfClass:[NSString class]]) {
      message = [[NSBundle mainBundle] localizedStringForKey:(NSString*)errorResponse value:@"" table:nil];
    } else if ([errorResponse isKindOfClass:[NSDictionary class]]) {
      NSDictionary* errorDict = (NSDictionary*)errorResponse;
      message = [[NSBundle mainBundle] localizedStringForKey:([errorDict objectForKey:[[errorDict allKeys] objectAtIndex:0]]) value:@"" table:nil];
    } else {
      message = NSLocalizedString(@"An unknown error has occurred.",@"DB Login Err Unknown Msg");
    }
  }
  [self errorWithTitle:NSLocalizedString(@"Login Failed",@"DB Login Err Title") message:message];
}


#pragma mark private methods

- (void)setWorking:(BOOL)working {
  
  if (working) {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = NSLocalizedString(@"Logging In", @"DB Login HUD");
  }
  else
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (void)errorWithTitle:(NSString*)title message:(NSString*)message {
  [[[[UIAlertView alloc] 
     initWithTitle:title message:message delegate:nil 
     cancelButtonTitle:@"OK" otherButtonTitles:nil]
    autorelease]
   show];
}

- (DBRestClient*)restClient {
  if (restClient == nil) {
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
  }
  return restClient;
}

#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
  
  [hud removeFromSuperview];
  [hud release];
}

@end
