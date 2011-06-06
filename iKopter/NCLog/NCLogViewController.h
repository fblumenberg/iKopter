//
//  OsdLogViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 06.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NCLogViewController : UITableViewController<NSFetchedResultsControllerDelegate> {
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
