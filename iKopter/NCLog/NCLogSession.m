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

#import "NCLogSession.h"
#import "NCLogRecord.h"


@implementation NCLogSession
@dynamic timeStampStart;
@dynamic timeStampEnd;
@dynamic records;

- (void)addRecordsObject:(NCLogRecord *)value {
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"records" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"records"] addObject:value];
  [self didChangeValueForKey:@"records" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)removeRecordsObject:(NCLogRecord *)value {
  NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
  [self willChangeValueForKey:@"records" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [[self primitiveValueForKey:@"records"] removeObject:value];
  [self didChangeValueForKey:@"records" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
  [changedObjects release];
}

- (void)addRecords:(NSSet *)value {
  [self willChangeValueForKey:@"records" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"records"] unionSet:value];
  [self didChangeValueForKey:@"records" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRecords:(NSSet *)value {
  [self willChangeValueForKey:@"records" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
  [[self primitiveValueForKey:@"records"] minusSet:value];
  [self didChangeValueForKey:@"records" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
