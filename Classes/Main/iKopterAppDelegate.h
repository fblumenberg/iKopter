//
//  iKopterAppDelegate.h
//  iKopter
//
//  Created by Frank Blumenberg on 20.06.10.
//  Copyright de.frankblumenberg 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iKopterAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

