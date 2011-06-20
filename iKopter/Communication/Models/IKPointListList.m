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

#import "IKPointList.h"
#import "IKPointListList.h"

#import "TTGlobalCorePaths.h"
#import "TTCorePreprocessorMacros.h"

@interface IKPointListList (Private)
-(void) load;
-(void) save;
@end

@implementation IKPointListList

- (id) init
{
  self = [super init];
  if (self != nil) {
    [self load];
    
    if(!points) {
      points = [[NSMutableArray alloc]init];
      [self save];
    }
  }
  return self;
}

- (void) dealloc
{
  [points release];
  [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#define kFilename        @"mkpointlists"
#define kDataKey         @"Data"
#define kNameKey         @"Name"

-(void) load {
  
  NSString *filePath = TTPathForDocumentsResource(kFilename);
  
  if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    
    qlinfo(@"Load the point lists from %@",filePath);
    
    NSData *data = [[NSMutableData alloc]
                    initWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    TT_RELEASE_SAFELY(points);
    points = [unarchiver decodeObjectForKey:kDataKey];
    [points retain];
    
    [unarchiver finishDecoding];
    
    [unarchiver release];
    [data release];        

    qldebug(@"Loaded the point lists %@",points);

  }
}

-(void) save {

  qldebug(@"Save the point lists %@",points);
  
  NSString *filePath = TTPathForDocumentsResource(kFilename);
  NSMutableData *data = [[NSMutableData alloc] init];
  NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];

  [archiver encodeObject:points forKey:kDataKey];
  [archiver finishEncoding];
  if(![data writeToFile:filePath atomically:YES]){
    qlerror(@"Failed to save the point lists to %@",filePath);
  }

  [archiver release];
  [data release];    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger) count {
  return [points count];
}

-(IKPointList*) pointListAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger row = [indexPath row];
  return [points objectAtIndex:row];
}

-(NSIndexPath*) addPointList {
  IKPointList* h = [[IKPointList alloc]init];
  [points addObject:h];
  [h release];

  [self save];
  return [NSIndexPath indexPathForRow:[points count]-1 inSection:0]; 
}

-(void) movePointListAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  qltrace(@"movePointAtIndexPath %@ -> %@",fromIndexPath,toIndexPath);
  qltrace(@"%@",points);

  NSUInteger fromRow = [fromIndexPath row];
  NSUInteger toRow = [toIndexPath row];
  
  id object = [[points objectAtIndex:fromRow] retain]; 
  [points removeObjectAtIndex:fromRow]; 
  [points insertObject:object atIndex:toRow]; 
  [object release];
    
  qltrace(@"%@",points);
  [self save];
}

-(void) deletePointListAtIndexPath:(NSIndexPath*)indexPath {
  [points removeObjectAtIndex:[indexPath row]]; 
  [self save];
}

@end

