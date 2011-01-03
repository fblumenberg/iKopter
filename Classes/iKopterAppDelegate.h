//
//  iKopterAppDelegate.h
//  iKopter
//
//  Created by Frank Blumenberg on 01.01.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKopterAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

