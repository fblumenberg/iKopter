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

#import "InnerShadowView.h"
#import "Common.h"
#import "InnerShadowDrawing.h"

@interface InnerShadowView ()

- (void)initLayers;

@end

@implementation InnerShadowView

@synthesize innerBackgroundColor;


- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
    [self initLayers];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)decoder {

  self = [super initWithCoder:decoder];
  if (self) {
    [self initLayers];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  CGSize shadowSize = {3.0, 3.0};


  CGRect rectInner = CGRectInset(rect, 3, 3);
  drawWithInnerShadow(rect, shadowSize, 2.0,
          [[UIColor blackColor] colorWithAlphaComponent:0.5],
          ^{
            CGContextRef currContext = UIGraphicsGetCurrentContext();
            CGMutablePathRef path = createRoundedRectForRect(rectInner, 10);
            CGContextAddPath(currContext, path);
            CGContextFillPath(currContext);
            CFRelease(path);
          },
          ^{
            CGContextRef context = UIGraphicsGetCurrentContext();
            [self.innerBackgroundColor setFill];
            CGMutablePathRef path = createRoundedRectForRect(rectInner, 10);
            CGContextAddPath(context, path);
            CGContextFillPath(context);
            CFRelease(path);
          });
}

- (void)initLayers {

  self.backgroundColor = [UIColor clearColor];
  self.innerBackgroundColor = [UIColor whiteColor];

  [self addObserver:self forKeyPath:@"innerBackgroundColor" options:0 context:NULL];

//  CGRect rectInner = CGRectInset(self.bounds, 3, 3);
//  CAShapeLayer* shapeLayer=[CAShapeLayer new];
//  shapeLayer.path=createRoundedRectForRect(rectInner,10);
//
//  self.layer.mask = shapeLayer;
//  
//  [shapeLayer release];
}

- (void)dealloc {
  [self removeObserver:self forKeyPath:@"innerBackgroundColor"];
  self.innerBackgroundColor = nil;
  [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self setNeedsDisplay];
}


@end
