//
//  RootViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 20.06.10.
//  Copyright de.frankblumenberg 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKHosts;

@interface RootViewController : UITableViewController {

  MKHosts* hosts;
  NSIndexPath* editingHost;
}

- (void)addHost;
@end
