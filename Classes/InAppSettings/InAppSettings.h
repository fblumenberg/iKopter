//
//  InAppSettingsViewController.h
//  InAppSettings
//
//  Created by David Keegan on 11/21/09.
//  Copyright 2009 InScopeApps{+}. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppSettingsTableCell.h"
#import "InAppSettingsReader.h"
#import "InAppSettingsSpecifier.h"

@protocol InAppSettingsDelegate;

@protocol InAppSettingsDatasource < NSObject >
- (id) objectForKey:(id)aKey;
- (void) setObject:(id)anObject forKey:(id)aKey;
@end

@interface InAppSettings : NSObject {}

+ (void) registerDefaults;

@end

@interface InAppSettingsModalViewController : UIViewController {}

@end

@interface InAppSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, InAppSettingsSpecifierDelegate> {
  NSString * file;
  UITableView * settingsTableView;
  UIControl * firstResponder;
  InAppSettingsReader * settingsReader;
  id<InAppSettingsDelegate> delegate;
  id<InAppSettingsDatasource> dataSource;
}

@property (nonatomic, copy) NSString * file;
@property (nonatomic, retain) UITableView * settingsTableView;
@property (nonatomic, assign) UIControl * firstResponder;
@property (nonatomic, retain) InAppSettingsReader * settingsReader;
@property (assign) id<InAppSettingsDelegate> delegate;
@property (assign) id<InAppSettingsDatasource> dataSource;

- (id) initWithFile:(NSString *)inputFile;

// modal view
- (void) dismissModalView;
- (void) addDoneButton;

// keyboard notification
- (void) registerForKeyboardNotifications;
- (void) keyboardWillShow:(NSNotification *)notification;
- (void) keyboardWillHide:(NSNotification *)notification;

@end

@interface InAppSettingsLightningBolt : UIView {
  BOOL flip;
}

@property (nonatomic, assign) BOOL flip;

@end

@protocol InAppSettingsDelegate < NSObject >

@optional
- (void) InAppSettingsValue:(id)value forKey:(NSString *)key;

@end

@protocol InAppSettingsChildPane < NSObject >

@property (nonatomic, retain) InAppSettingsSpecifier * setting;

- (id) initWithSetting:(InAppSettingsSpecifier *)inputSetting;
- (id) getValue;
- (void) setValue:(id)newValue;

@end
