//
//  MIxerViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 03.07.10.
//  Copyright 2010 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MixerTableViewCell;

@interface MixerViewController : UITableViewController {

  MixerTableViewCell* loadCell;
}

@property (nonatomic, retain) IBOutlet MixerTableViewCell *loadCell;

@end
