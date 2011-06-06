//
//  NCLogSession.h
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NCLogRecord;

@interface NCLogSession : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSSet* records;

@end
