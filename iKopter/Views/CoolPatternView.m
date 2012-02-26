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

void MyDrawColoredPattern(void *info, CGContextRef context) {

  CGColorRef dotColor = [UIColor colorWithHue:0 saturation:0 brightness:0.07 alpha:1.0].CGColor;
  CGColorRef shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;

  CGContextSetFillColorWithColor(context, dotColor);
  CGContextSetShadowWithColor(context, CGSizeMake(0, 1), 1, shadowColor);

  CGContextAddArc(context, 3, 3, 4, 0, radians(360), 0);
  CGContextFillPath(context);
  CGContextAddArc(context, 16, 16, 4, 0, radians(360), 0);
  CGContextFillPath(context);
}

- (void)drawRectCG:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGColorRef bgColor = [UIColor colorWithHue:0 saturation:0 brightness:0.15 alpha:1.0].CGColor;
  CGContextSetFillColorWithColor(context, bgColor);
  CGContextFillRect(context, rect);

  static const CGPatternCallbacks callbacks = {0, &MyDrawColoredPattern, NULL};

  CGContextSaveGState(context);
  CGColorSpaceRef patternSpace = CGColorSpaceCreatePattern(NULL);
  CGContextSetFillColorSpace(context, patternSpace);
  CGColorSpaceRelease(patternSpace);

  CGPatternRef pattern = CGPatternCreate(NULL,
          CGRectMake(0, 0, 24, 24),
          CGAffineTransformIdentity,
          24,
          24,
          kCGPatternTilingConstantSpacing,
          true,
          &callbacks);
  CGFloat alpha = 1.0;
  CGContextSetFillPattern(context, pattern, &alpha);
  CGPatternRelease(pattern);
  CGContextFillRect(context, self.bounds);
  CGContextRestoreGState(context);
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
