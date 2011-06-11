//
//  NCLogSession.h
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kIKNCLoggingInterval @"IKNCLoggingInterval"
#define kIKNCLoggingActive @"IKNCLoggingActive"


@class NCLogRecord;

@interface NCLogSession : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * timeStampStart;
@property (nonatomic, retain) NSDate * timeStampEnd;
@property (nonatomic, retain) NSSet* records;

@end
