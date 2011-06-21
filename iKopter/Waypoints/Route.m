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

#import "IKPoint.h"
#import "Route.h"

#import "TTGlobalCorePaths.h"
#import "TTCorePreprocessorMacros.h"

@implementation Route

@synthesize name;
@synthesize points;

- (id) init
{
  self = [super init];
  if (self != nil) {
    self.points = [NSMutableArray array];
  }
  return self;
}

- (void) dealloc
{
  self.name = nil;
  self.points = nil;
  [super dealloc];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma - mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)aCoder{
  [aCoder encodeObject:self.name forKey:@"name"];
  [aCoder encodeObject:self.points forKey:@"points"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
  if ((self = [super init])) {
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.points = [aDecoder decodeObjectForKey:@"points"];
  }
  return self;
}

-(NSString*) description{
  return [NSString stringWithFormat:@"Route:%@",self.name];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger) count {
  return [points count];
}

-(IKPoint*) pointAtIndexPath:(NSIndexPath *)indexPath {
  NSUInteger row = [indexPath row];
  return [points objectAtIndex:row];
}

-(NSIndexPath*) addPoint {
  IKPoint* h = [[IKPoint alloc]init];
  [points addObject:h];
  [h release];

  [points enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
    IKPoint* p=object;
    p.index=index+1;
  }];

  return [NSIndexPath indexPathForRow:[points count]-1 inSection:1]; 
}

-(void) movePointAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
  qltrace(@"movePointAtIndexPath %@ -> %@",fromIndexPath,toIndexPath);
  qltrace(@"%@",points);

  NSUInteger fromRow = [fromIndexPath row];
  NSUInteger toRow = [toIndexPath row];
  
  id object = [[points objectAtIndex:fromRow] retain]; 
  [points removeObjectAtIndex:fromRow]; 
  [points insertObject:object atIndex:toRow]; 
  [object release];
  
  [points enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
    IKPoint* p=object;
    p.index=index+1;
  }];
    
  qltrace(@"%@",points);
}

-(void) deletePointAtIndexPath:(NSIndexPath*)indexPath {
  [points removeObjectAtIndex:[indexPath row]]; 
  [points enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
    IKPoint* p=object;
    p.index=index+1;
  }];
}

@end

