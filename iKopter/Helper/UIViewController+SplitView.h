//
//  UIViewController+SplitView.h
//  iKopter
//
//  Created by mtg on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"

@interface UIViewController (UIViewController_SplitView)

@property(nonatomic,readonly) BOOL isPad;
@property(nonatomic,readonly) BOOL isRootForDetailViewController;
@property(nonatomic,readonly) MGSplitViewController* splitViewController;
@property(nonatomic,readonly) UINavigationController* detailViewController;
@property(nonatomic,readonly) UINavigationController* rootViewController;


@end
