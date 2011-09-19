//
//  UIViewController+SplitView.m
//  iKopter
//
//  Created by mtg on 19.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+SplitView.h"

@implementation UIViewController (UIViewController_SplitView)

-(MGSplitViewController*)splitViewController{
  UIViewController* controller=[UIApplication sharedApplication].keyWindow.rootViewController;
  if( [controller isKindOfClass:[MGSplitViewController class]] ){
    return (MGSplitViewController*)controller;
  }
  return nil;
}

-(UINavigationController*)detailViewController{
  UIViewController* controller=[self splitViewController].detailViewController;
  if( [controller isKindOfClass:[UINavigationController class]] ){
    return (UINavigationController*)controller;
  }
  return nil;
}

-(UINavigationController*)rootViewController{
  UIViewController* controller=[self splitViewController].masterViewController;
  if( [controller isKindOfClass:[UINavigationController class]] ){
    return (UINavigationController*)controller;
  }
  return nil;
}

-(BOOL) isPad{
  
#ifdef UI_USER_INTERFACE_IDIOM
  static NSInteger isPad = -1;
  if (isPad < 0) {
    isPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
  }
  return isPad > 0;
#else
  return NO;
#endif
}

@end
