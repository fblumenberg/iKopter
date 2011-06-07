//
//  NCLogSession.m
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

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
