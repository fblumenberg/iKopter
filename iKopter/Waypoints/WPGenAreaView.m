// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////

#import "WPGenAreaView.h"

@implementation WPGenAreaView

@synthesize noPointsX, noPointsY;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    noPointsX = 2;
    noPointsY = 2;

    [self updatePoints];
  }
  return self;
}

- (void)updatePoints {

  self.points = [NSMutableArray arrayWithCapacity:noPointsY];
  for (int y = 0; y < noPointsY; y++) {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:noPointsX];
    for (int x = 0; x < noPointsX; x++) {
      NSValue *v = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
      [array addObject:v];
    }
    [self.points addObject:array];
  }

  [self setNeedsLayout];
}

- (void)layoutSubviews {

  CGRect rect = CGRectInset(self.bounds, 10, 10);

  CGFloat dx = noPointsX == 1 ? CGRectGetWidth(rect) : CGRectGetWidth(rect) / (noPointsX - 1);
  CGFloat dy = noPointsY == 1 ? CGRectGetHeight(rect) : CGRectGetHeight(rect) / (noPointsY - 1);

  for (NSUInteger y = 0; y < noPointsY; y++) {
    NSMutableArray *array = [self.points objectAtIndex:y];
    for (NSUInteger x = 0; x < noPointsX; x++) {
      NSValue *v = [NSValue valueWithCGPoint:CGPointMake(rect.origin.x + x * dx, rect.origin.y + y * dy)];
      [array replaceObjectAtIndex:x withObject:v];
    }
  }

}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  NSLog(@"DrawRect %@", NSStringFromCGRect(rect));

  CGContextRef context = UIGraphicsGetCurrentContext();

  NSMutableArray *points = [NSMutableArray arrayWithCapacity:self.noPointsX * self.noPointsY];

  [[UIColor whiteColor] set];

  [self.points enumerateObjectsUsingBlock:^(id obj, NSUInteger idxY, BOOL *stop) {
    NSArray *x = obj;

    if (idxY % 2)
      x = [[x reverseObjectEnumerator] allObjects];

    [x enumerateObjectsUsingBlock:^(id objx, NSUInteger idxX, BOOL *stopx) {

      [points addObject:objx];

      CGPoint p = [[x objectAtIndex:idxX] CGPointValue];

      if (idxY == 0 && idxX == 0)
        CGContextMoveToPoint(context, p.x, p.y);
      else
        CGContextAddLineToPoint(context, p.x, p.y);
    }];
  }];

  CGContextStrokePath(context);

  [points enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idxY, BOOL *stop) {
    CGPoint p = [obj CGPointValue];
    [self drawWaypointAt:p index:idxY withContext:context];
  }];

}


@end
