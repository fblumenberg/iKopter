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

#import "WPGenCircleView.h"
#import "Common.h"

@interface WPGenCircleView () {

  CGRect circleRect;
}

@end

@implementation WPGenCircleView

@synthesize noPoints, clockwise,closed;

-(CGPoint)poi{
  return CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];

    noPoints = 10;
    closed = NO;
    clockwise = NO;

    [self updatePoints];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

-(void) updatePoints{
  
  self.points = [NSMutableArray arrayWithCapacity:noPoints];
  for (int x = 0; x < noPoints; x++) {
    NSValue *v = [NSValue valueWithCGPoint:CGPointMake(0, 0)];
    [self.points addObject:v];
  }
  
  [self setNeedsLayout];
}

- (void)layoutSubviews {

  CGRect parentRect = self.bounds;
  
  CGFloat newSize = MIN(CGRectGetHeight(parentRect), CGRectGetWidth(parentRect));
  CGRect rect = CGRectMake((int)((CGRectGetWidth(parentRect) - newSize) / 2), 
                           (int)((CGRectGetHeight(parentRect) - newSize) / 2), newSize, newSize);
  
  circleRect = CGRectInset(rect, 10, 10);
  
  if( noPoints>1 ){
    
    
    CGFloat ddeg = 360.0 / noPoints;
    if(clockwise)
      ddeg*=-1;
    
    
    CGFloat radius = CGRectGetWidth(circleRect)/2;
    
    for (int n = 0; n < noPoints; n++) {
      CGFloat angle = ((n * ddeg+180)*M_PI)/180;
      
      CGFloat x  = radius * sin(angle) + CGRectGetMidX(circleRect);
      CGFloat y  = radius * cos(angle) + CGRectGetMidY(circleRect);
      
      CGPoint newPoint = CGPointMake(x,y);
      NSValue *v = [NSValue valueWithCGPoint:newPoint];
      [self.points replaceObjectAtIndex:n withObject:v];
    }
  }
  
}


- (void)drawBackgroundWithContext:(CGContextRef) context{

  CGContextSaveGState(context);

  [[UIColor whiteColor] set];
  CGContextStrokeEllipseInRect(context, circleRect);
  
  CGContextRestoreGState(context);
}


- (void)drawPOIAt:(CGPoint)p withContext:(CGContextRef) context{
  
  CGContextSaveGState(context);
  
  CGRect pointRect = CGRectMake(p.x - 7, p.y - 7, 14, 14);
  [[UIColor purpleColor] set];
  CGContextFillEllipseInRect(context, pointRect);
  
  [[UIColor whiteColor] set];
  CGContextAddEllipseInRect(context, pointRect);
  CGContextStrokePath(context);

  CGContextRestoreGState(context);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
  NSLog(@"DrawRect %@", NSStringFromCGRect(rect));
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  [self drawBackgroundWithContext:context];
  
  //-------------------------------------------------------------

  CGContextMoveToPoint(context, CGRectGetMidX(circleRect),CGRectGetMidY(circleRect));

  [self.points enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idxY, BOOL *stop) {
    CGPoint p = [obj CGPointValue];

    if (idxY == 0 )
      CGContextAddLineToPoint(context, p.x, p.y);

    [self drawWaypointAt:p index:idxY withContext:context];
  }];

  CGPoint center = CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
  [self drawPOIAt:center withContext:context];
  
  [[UIColor whiteColor] set];
  [@"POI" drawAtPoint:center withFont:self.wpTextFont];
  CGContextStrokePath(context);
}


@end
