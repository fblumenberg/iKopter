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

#import "NSString+Dropbox.h"
#import "IKDropboxController.h"

#define kIKDropboxPath @"/iKopterData"
#define kMKToolPath @"/Apps/MK Tool/RouteData"

typedef enum {
  IKDropboxConnectStateIDLE,
  IKDropboxConnectStateWAIT_iKopterData,
  IKDropboxConnectStateWAIT_MKToolData
} IKDropboxConnectState;

@interface IKDropboxController () <DBRestClientDelegate>{
  IKDropboxConnectState state;
}


- (void)startGettingiKopterData;
- (void)startGettingMKToolData;
- (void)notifyDelegate;


@end

@implementation IKDropboxController

+ (IKDropboxController *)sharedIKDropboxController {

  static dispatch_once_t once;
  static IKDropboxController *sharedIKDropboxController__ = nil;

  dispatch_once(&once, ^{
    sharedIKDropboxController__ = [[IKDropboxController alloc] init];
  });

  return sharedIKDropboxController__;

}

@synthesize delegate;
@synthesize metaData;
@synthesize metaDataMKTool;

@synthesize dataPath;

- (id)init {
  self = [super init];
  if (self) {
    dataPath = kIKDropboxPath;
    state = IKDropboxConnectStateIDLE;
  }
  return self;
}

- (void)dealloc {
  [restClient release];
  [super dealloc];
}

- (void)connectAndPrepareMetadata {

  restClient.delegate = self;

  state = IKDropboxConnectStateIDLE;
  
  NSLog(@"Delegate %@", self.delegate);
  if (![[DBSession sharedSession] isLinked]) {
    [[DBSession sharedSession] link];
  }
  else {
    [self startGettingiKopterData];
  }
}




- (BOOL)metadataContainsPath:(NSString *)path {
  NSString *testPath = [self.dataPath stringByAppendingPathComponent:path];

  for (DBMetadata *child in self.metaData.contents) {
    qltrace(@"Check path %@", child.path);
    if ([testPath isEqualToDropboxPath:child.path])
      return YES;
  }

  return NO;
}


+ (void)showError:(NSError *)error withTitle:(NSString *)title {

  NSString *message;
  if ([error.domain isEqual:NSURLErrorDomain]) {
    message = NSLocalizedString(@"There was an error connecting to Dropbox.", @"DB Login Err Msg");
  } else {
    NSObject *errorResponse = [[error userInfo] objectForKey:@"error"];
    if ([errorResponse isKindOfClass:[NSString class]]) {
      message = [[NSBundle mainBundle] localizedStringForKey:(NSString *) errorResponse value:@"" table:nil];
    } else if ([errorResponse isKindOfClass:[NSDictionary class]]) {
      NSDictionary *errorDict = (NSDictionary *) errorResponse;
      message = [[NSBundle mainBundle] localizedStringForKey:([errorDict objectForKey:[[errorDict allKeys] objectAtIndex:0]]) value:@"" table:nil];
    } else {
      message = NSLocalizedString(@"An unknown error has occurred.", @"DB Login Err Unknown Msg");
    }
  }

  [[[[UIAlertView alloc]
          initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
          autorelease]
          show];
}


- (void)startGettingiKopterData{
  [self.restClient loadMetadata:kIKDropboxPath withHash:[self.metaData hash]];
  state = IKDropboxConnectStateWAIT_iKopterData;
}

- (void)startGettingMKToolData{
  [self.restClient loadMetadata:kMKToolPath withHash:[self.metaDataMKTool hash]];
  state = IKDropboxConnectStateWAIT_MKToolData;
}

- (void)notifyDelegate{
  restClient.delegate = self.delegate;
  [self.delegate dropboxReady:self];
  state = IKDropboxConnectStateIDLE;
}


#pragma mark - DBRestClientDelegate methods

- (void)restClient:(DBRestClient *)client createdFolder:(DBMetadata *)folder {
  if ([folder.path isEqualToDropboxPath:kIKDropboxPath]) {
    self.metaData = folder;
    [self startGettingMKToolData];
  }
}

- (void)restClient:(DBRestClient *)client createFolderFailedWithError:(NSError *)error {
  [IKDropboxController showError:error withTitle:NSLocalizedString(@"Creating iKopter data folder failed", @"Create Data Folder Error Title")];
  state = IKDropboxConnectStateIDLE;
}

//-----------------------------------------------------------------------------------------------

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)newMetadata {
  
  if( state==IKDropboxConnectStateWAIT_iKopterData ){
    if( [newMetadata.path isEqualToDropboxPath:kIKDropboxPath] )
      self.metaData = newMetadata;
    
    [self startGettingMKToolData];
  }
  else if (state==IKDropboxConnectStateWAIT_MKToolData) {
    self.metaDataMKTool = newMetadata;
    [self notifyDelegate];
  }
}

- (void)restClient:(DBRestClient *)client metadataUnchangedAtPath:(NSString *)path {
  
  if( state==IKDropboxConnectStateWAIT_iKopterData ){
    [self startGettingMKToolData];
  }
  else if (state==IKDropboxConnectStateWAIT_MKToolData) {
    [self notifyDelegate];
  }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error {
  qlinfo(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
  
  if(state==IKDropboxConnectStateWAIT_iKopterData){
    if ([error code] == 404) {
      qlinfo(@"The Dropbox path for iKopter is not there, create one");
      [self.restClient createFolder:kIKDropboxPath];
    }
    else {
      [IKDropboxController showError:error withTitle:NSLocalizedString(@"Getting iKopter data folder failed", @"Getting Data Folder Error Title")];
    }
  }
  else if (state==IKDropboxConnectStateWAIT_MKToolData) {
    self.metaDataMKTool = nil;
    [self notifyDelegate];
  }
}

#pragma mark - 

- (DBRestClient *)restClient {
  if (restClient == nil) {
    restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    restClient.delegate = self;
  }
  return restClient;
}


@end

