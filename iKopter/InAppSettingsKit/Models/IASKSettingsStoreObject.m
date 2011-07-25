//
//  IASKSettingsStoreFile.m
//  http://www.inappsettingskit.com
//
//  Copyright (c) 2010:
//  Luc Vandal, Edovia Inc., http://www.edovia.com
//  Ortwin Gentz, FutureTap GmbH, http://www.futuretap.com
//  Marc-Etienne M.Léveillé, Edovia Inc., http://www.edovia.com
//  All rights reserved.
// 
//  It is appreciated but not required that you give credit to Luc Vandal and Ortwin Gentz, 
//  as the original authors of this code. You can give credit in a blog post, a tweet or on 
//  a info page of your app. Also, the original authors appreciate letting them know if you use this code.
//
//  This code is licensed under the BSD license that is available at: http://www.opensource.org/licenses/bsd-license.php
//

#import "IASKSettingsStoreObject.h"


@implementation IASKSettingsStoreObject

@synthesize object=_object;

- (id)initWithObject:(id)theObject {
  self=[super init];
  if(self) {
    _object = [theObject retain];
  }
  return self;
}

- (void)dealloc {
  [_object release];
  [super dealloc];
}


- (void)setObject:(id)value forKey:(NSString *)key {
  NSLog(@"Set object %@ (%@) for key %@",value,[value class],key);
  [_object setValue:value forKeyPath:key];
}

- (id)objectForKey:(NSString *)key {
  NSLog(@"Get object for key %@",key);
  return [_object valueForKeyPath:key];
}

- (BOOL)synchronize {
  return YES;
}

@end
