//
//  main.m
//  iKopter
//
//  Created by Frank Blumenberg on 12.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

int main(int argc, char *argv[])
{
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

# ifndef _LCL_NO_LOGGING

  BOOL logActive=NO;
  _lcl_level_t level=lcl_vCritical;
  
  NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingActive];
  if (testValue) {
    logActive = [[NSUserDefaults standardUserDefaults] boolForKey:kIKLoggingActive];
  }
  
  testValue = nil;
  testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingLevel];
  if (testValue) {
    level = [[NSUserDefaults standardUserDefaults] integerForKey:kIKLoggingLevel];
  }

  if(!logActive)  
    level=lcl_vOff;
  
  lcl_configure_by_identifier("*", level);

# endif
  
  qlinfo(@"Logging initialized, path ist %@",[LCLLogFile path])
  
  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  return retVal;
}
