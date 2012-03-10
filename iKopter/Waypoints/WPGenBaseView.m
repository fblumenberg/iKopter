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


#import "WPGenBaseView.h"

@interface WPGenBaseView()

@end

@implementation WPGenBaseView

@synthesize points = _points;
@synthesize wpTextFont = _wpTextFont;
@synthesize wpColor = _wpColor;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.wpTextFont = [UIFont boldSystemFontOfSize:10];
    self.wpColor = [UIColor colorWithRed:0.0 green:0.5 blue:0.25 alpha:1.0];
  }
  return self;
}

- (void)dealloc
{
  self.wpColor = nil;
  self.wpTextFont = nil;
  self.points = nil;

  [super dealloc];
}

- (void)drawWaypointAt:(CGPoint)p index:(NSUInteger)idx withContext:(CGContextRef) context{
  
  CGContextSaveGState(context);
  
  CGRect pointRect = CGRectMake(p.x - 7, p.y - 7, 14, 14);
  if(idx==0)
    [[UIColor redColor] set];
  else
    [self.wpColor set];
  
  CGContextFillEllipseInRect(context, pointRect);

  [[UIColor whiteColor] set];
  CGContextAddEllipseInRect(context, pointRect);
  CGContextStrokePath(context);
  NSString* text = [NSString stringWithFormat:@"%d",idx+1];

  CGSize textSize = [text sizeWithFont:self.wpTextFont];
  CGRect textRect  = CGRectMake(p.x, p.y, textSize.width, textSize.height);
  
  textRect  = CGRectOffset(textRect, -textSize.width / 2, -textSize.height / 2);
  
  [text drawAtPoint:textRect.origin withFont:self.wpTextFont];

  CGContextRestoreGState(context);
}

@end
