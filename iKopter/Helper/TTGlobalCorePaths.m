//
// Copyright 2009-2010 Facebook
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "TTGlobalCorePaths.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsBundleURL(NSString* URL) {
  return [URL hasPrefix:@"bundle://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL TTIsDocumentsURL(NSString* URL) {
  return [URL hasPrefix:@"documents://"];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* TTPathForBundleResource(NSString* relativePath) {
  NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
  return [resourcePath stringByAppendingPathComponent:relativePath];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* TTPathForDocumentsResource(NSString* relativePath) {
  static NSString* documentsPath = nil;
  if (!documentsPath) {
#ifdef FOR_CYDIA
    documentsPath = @"/var/mobile/Library/de.frankblumenberg.ikopter";
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attr = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0755] forKey:NSFilePosixPermissions];
    if (![fm fileExistsAtPath:documentsPath]){
      BOOL v=[fm createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes: attr error:nil];
    }
    else{
      BOOL v=[fm setAttributes:attr ofItemAtPath:documentsPath error:nil];
    }
#else    
    NSArray* dirs = NSSearchPathForDirectoriesInDomains(
      NSDocumentDirectory, NSUserDomainMask, YES);
    documentsPath = [[dirs objectAtIndex:0] retain];
#endif
  }
  return [documentsPath stringByAppendingPathComponent:relativePath];
}
