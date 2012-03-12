//
//  StringToNumberCamAngelTransformer.m
//  iKopter
//
//  Created by Frank Blumenberg on 10.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WPCamAngleTransformer.h"

@implementation WPCamAngleTransformer

+ (id)instance {
  return [[[[self class] alloc] init] autorelease];
}

+ (BOOL)allowsReverseTransformation {
  return NO;
}

+ (Class)transformedValueClass {
  return [NSString class];
}

- (NSString *)transformedValue:(NSNumber *)value {

  if ([value integerValue] < 0)
    return NSLocalizedString(@"AUTO", @"WP CamAngle auto mode");

  return [value stringValue];
}

@end
