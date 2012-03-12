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


#import "HeadingOverlayView.h"
#import "HeadingOverlay.h"
#import "Common.h"


@implementation HeadingOverlayView

@synthesize overlay;

- (id)initWithHeadingOverlay:(HeadingOverlay *)theOverlay {
  self = [super initWithCircle:overlay.circle];
  if (self) {
    overlay = [theOverlay retain];
  }
  return self;
}

- (void)dealloc
{
  [overlay release];
  [super dealloc];
}

- (void)createPath {

  CGMutablePathRef path = CGPathCreateMutable();

  CGFloat arcRadius = MIN(self.bounds.size.width, self.bounds.size.height);

  CGFloat angle = radians(self.overlay.angle);
  CGFloat startAngle = angle - radians(15);
  CGFloat endAngle = angle + radians(15);

  CGPoint center = [self pointForMapPoint:MKMapPointForCoordinate(self.overlay.coordinate)];

  CGPathMoveToPoint(path, NULL, center.x, center.y);

  CGPathAddArc(path, NULL, center.x, center.y, arcRadius,
          startAngle, endAngle, 0);

  CGPathCloseSubpath(path);

  self.path = path;

  CFRelease(path);
}

@end
