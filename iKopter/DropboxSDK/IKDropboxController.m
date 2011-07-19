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

#import "DropboxSDK.h"
#import "NSString+Dropbox.h"
#import "IKDropboxController.h"

#define kIKDropboxPath @"/iKopterData"

@interface IKDropboxController() <DBRestClientDelegate>


@end

@implementation IKDropboxController

SYNTHESIZE_SINGLETON_FOR_CLASS(IKDropboxController);

@synthesize delegate;
@synthesize metaData;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)dealloc {
  [restClient release];
  [super dealloc];
}

-(void) connectAndPrepareMetadata{

  NSLog(@"Delegate %@",self.delegate);
  if (![[DBSession sharedSession] isLinked]) {
    IKDropboxLoginController* loginController = [[[IKDropboxLoginController alloc] initWithNibName:nil bundle:nil] autorelease];
    loginController.delegate=self;
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [loginController presentFromController:rootViewController];
  }
  else {
    [self.restClient loadMetadata:kIKDropboxPath withHash:[self.metaData hash]];
  }
}

#pragma mark - DBRestClientDelegate methods

- (void) restClient:(DBRestClient *)client createdFolder:(DBMetadata *)folder{
  if([folder.path isEqualToDropboxPath:kIKDropboxPath]){
    [metaData release];
    metaData = [folder retain];
    qlinfo(@"Created the Dropbox folder %@",folder.path);
    
    [self.delegate dropboxReady:self];
  }
}

- (void) restClient:(DBRestClient *)client createFolderFailedWithError:(NSError *)error{
  NSLog(@"restClient:createFolderFailedWithError: %@", [error localizedDescription]);
//  [self displayError];
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)newMetadata {
  if([newMetadata.path isEqualToDropboxPath:kIKDropboxPath]){
    [metaData release];
    metaData = [newMetadata retain];
    qlinfo(@"Loaded the meta data for the Dropbox folder %@ call delegate %@",newMetadata.path,self.delegate);
    [self.delegate dropboxReady:self];
  }
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
  [self.delegate dropboxReady:self];
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error {
  qlinfo(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
  
  if([error code]==404 ){
    qlinfo(@"The Dropbox path for iKopter is not there, create one");
    [self.restClient createFolder:kIKDropboxPath];
  }
//  [self displayError];
//  [self setWorking:NO];
}

#pragma mark - DBLoginControllerDelegate methods

- (void)loginControllerDidLogin:(IKDropboxLoginController*)controller {
  controller.delegate=nil;
  [self connectAndPrepareMetadata];
}

- (void)loginControllerDidCancel:(IKDropboxLoginController*)controller {
  controller.delegate=nil;
}

#pragma mark - 

- (DBRestClient*)restClient {
  if (restClient == nil) {
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
  }
  return restClient;
}


@end

