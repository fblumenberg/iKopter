//
//  RawOsdViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 07.02.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OsdValue.h"


@interface RawOsdViewController : UIViewController<OsdValueDelegate> {
  UITextView* osdText;
}

@property(retain) IBOutlet UITextView* osdText;

@end
