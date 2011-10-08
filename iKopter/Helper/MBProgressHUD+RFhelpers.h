//
//  MBProgressHUD+RFhelpers.h
//
//  Created by Eric Chamberlain on 5/6/10.
//  Copyright 2010 RF.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MBProgressHUD.h"

@interface MBProgressHUD(RFhelpers)

// a shared progress HUD tied to the window
+ (MBProgressHUD *)sharedProgressHUD;

+ (MBProgressHUD *)sharedNotificationHUD;

// show HUD without background process, used for async calls
- (void)showAnimated:(BOOL)animated;
- (void)showWithLabelText:(NSString *)text animated:(BOOL)animated;
- (void)hideAnimated:(BOOL)animated;

@end
