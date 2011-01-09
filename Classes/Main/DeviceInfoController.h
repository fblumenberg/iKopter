//
//  DeviceInfoController.h
//  iKopter
//
//  Created by Frank Blumenberg on 09.01.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeviceInfoControllerDelegate;

@interface DeviceInfoController : UIViewController {
	id <DeviceInfoControllerDelegate> delegate;
}

@property (nonatomic, assign) id <DeviceInfoControllerDelegate> delegate;
- (IBAction)done:(id)sender;

@end

@protocol DeviceInfoControllerDelegate
- (void)deviceInfoControllerDidFinish:(DeviceInfoController *)controller;
@end

