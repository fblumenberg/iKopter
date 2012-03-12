//
//  CoolPatternView.m
//  CoolPattern
//
//  Created by Ray Wenderlich on 10/27/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "CoolPatternView.h"

static inline double radians(double degrees) {
  return degrees * M_PI / 180;
}

@implementation CoolPatternView

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGColorRef color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundSmall.png"]].CGColor;
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, color);
  CGContextFillRect(context, rect);
}

- (void)dealloc {
  [super dealloc];
}

@end
