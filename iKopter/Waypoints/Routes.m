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

#import "Route.h"
#import "Routes.h"

#import "TTGlobalCorePaths.h"
#import "TTCorePreprocessorMacros.h"

@interface Routes (Private)

@end

@implementation Routes

@synthesize routesFile;

- (id) init
{
  self = [super init];
  if (self != nil) {
    [self load];
    
    if(!routes) {
      routes = [[NSMutableArray alloc]init];
      [self save];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(save) name:UIApplicationWillResignActiveNotification object:[UIApplication sharedApplication]];
  }
  return self;
}

- (void) dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

  [routesFile release];
  [routes release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#define kFilename        @"mkroutes.plist"
#define kDataKey         @"Data"
#define kNameKey         @"Name"

-(void) load {
  
  [routesFile release];
  routesFile = [TTPathForDocumentsResource(kFilename) retain];
  
  NSString* oldRoutesFile = [routesFile stringByDeletingPathExtension];
  if ([[NSFileManager defaultManager] fileExistsAtPath:oldRoutesFile]) {
    NSError * err = NULL;
    [[NSFileManager defaultManager] moveItemAtPath:oldRoutesFile toPath:routesFile error:&err];
    qlinfo(@"Move route file form %@ to %@ : %@",oldRoutesFile,routesFile,err);
  }  
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:routesFile]) {
    
    qlinfo(@"Load the point lists from %@",routesFile);
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:routesFile];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    TT_RELEASE_SAFELY(routes);
    routes = [unarchiver decodeObjectForKey:kDataKey];
    [routes retain];
    
    [unarchiver finishDecoding];
    [unarchiver release];
    [data release];        

    [routes enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
      Route* r=object;
      r.routes=self;
    }];

    qldebug(@"Loaded the routes %@",routes);

  }
}

-(void) save {

  qldebug(@"Save the routes %@",routes);
  
  NSString *filePath = TTPathForDocumentsResource(kFilename);
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

  [archiver encodeObject:routes forKey:kDataKey];
  [archiver finishEncoding];
  if(![data writeToFile:filePath atomically:YES]){
    qlerror(@"Failed to save the routes to %@",filePath);
  }

  [archiver release];
  [data release];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger) count {
  return [routes count];
}

-(Route*) routeAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger row = [indexPath row];
  return [routes objectAtIndex:row];
}

-(NSIndexPath*) addRoute {
  Route* h = [[Route alloc]init];
  [routes addObject:h];
  [h release];

  [self save];
  return [NSIndexPath indexPathForRow:[routes count]-1 inSection:0]; 
}

-(void) moveRouteAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  qltrace(@"moveRouteAtIndexPath %@ -> %@",fromIndexPath,toIndexPath);
  qltrace(@"%@",routes);

  NSUInteger fromRow = [fromIndexPath row];
  NSUInteger toRow = [toIndexPath row];
  
  id object = [[routes objectAtIndex:fromRow] retain]; 
  [routes removeObjectAtIndex:fromRow]; 
  [routes insertObject:object atIndex:toRow]; 
  [object release];
    
  qltrace(@"%@",routes);
  [self save];
}

-(void) deleteRouteAtIndexPath:(NSIndexPath*)indexPath {
  [routes removeObjectAtIndex:[indexPath row]]; 
  [self save];
}

@end

