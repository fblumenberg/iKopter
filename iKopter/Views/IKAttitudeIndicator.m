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


#import "IKInstrumentsCommon.h"
#import "IKAttitudeIndicator.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"

#define  kHorizonLayerName @"HorizonLayerName"
#define  kDegreeMarksLayerName @"DegreeMarksLayerName"
#define  kWingsLayerName @"WingsLayerName"


@interface IKAttitudeIndicator (private)

- (void)initLayers;
- (void)drawHorizonLayer:(CGContextRef)ctx;
- (void)drawDegreeMarksLayer:(CGContextRef)ctx;
- (void)drawWingsLayer:(CGContextRef)ctx;
- (void)layoutLayers;
@end


@implementation IKAttitudeIndicator

@synthesize pitch = _pitch;
@synthesize roll = _roll;

- (void)setPitch:(float)value {
  if (_pitch != value) {
    _pitch = value;
  }
  [self layoutLayers];
}

- (void)setRoll:(float)value {
  if (_roll != value) {
    _roll = value;
  }
  [self layoutLayers];
}


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

//- (void)drawRect:(CGRect)rect {
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  
//  CGColorRef redColor = 
//  [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0].CGColor;
//  
//  CGContextSetFillColorWithColor(context, redColor);
//  CGContextFillRect(context, self.bounds);
//}

- (void)dealloc {
  [_horizonLayer release];
  [_degreeMarksLayer release];
  [_wingsLayer release];
  [_layerProxy release];

  [super dealloc];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

  NSLog(@"drawLayer %@", layer.name);
  if ([layer.name isEqualToString:kHorizonLayerName]) {
    [self drawHorizonLayer:ctx];
  }
  else if ([layer.name isEqualToString:kDegreeMarksLayerName]) {
    [self drawDegreeMarksLayer:ctx];
  }
  else if ([layer.name isEqualToString:kWingsLayerName]) {
    [self drawWingsLayer:ctx];
  }

}

@end

#pragma mark -

@implementation IKAttitudeIndicator (private)

- (void)initLayers {

  _layerProxy = [[[IKLayerDelegateProxy alloc] initWithDelegate:self] retain];

  self.layer.backgroundColor = [UIColor yellowColor].CGColor;
  self.layer.backgroundColor = [UIColor blueColor].CGColor;
  self.layer.shadowOffset = CGSizeMake(0, 3);
  self.layer.shadowRadius = 5.0;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.8;
  self.layer.borderColor = [UIColor blackColor].CGColor;
  self.layer.borderWidth = 2.0;
  self.layer.cornerRadius = 10.0;
  self.layer.masksToBounds = YES;

  CGPoint selfCenter = CGPointMake(CGRectGetWidth(self.layer.bounds) / 2, CGRectGetHeight(self.layer.bounds) / 2);

  //-----------------------------------------------------------------
  _horizonLayer = [[CALayer layer] retain];
  _horizonLayer.name = kHorizonLayerName;

  _horizonLayer.borderColor = [UIColor blackColor].CGColor;
  _horizonLayer.borderWidth = 2.0;

  float horizonSize = floor(sqrtf(powf(CGRectGetWidth(self.layer.bounds), 2.0) +
          powf(CGRectGetHeight(self.layer.bounds), 2.0)));
  _horizonLayer.frame = CGRectMake(0.0, 0.0, horizonSize, horizonSize * 2.0);
  _horizonLayer.position = selfCenter;
  _horizonLayer.contentsScale = [UIScreen mainScreen].scale;

  _horizonLayer.delegate = _layerProxy;
  [self.layer addSublayer:_horizonLayer];

  _degreeMarksLayer = [[CALayer layer] retain];
  _degreeMarksLayer.name = kDegreeMarksLayerName;
  _degreeMarksLayer.frame = self.layer.bounds;
  _degreeMarksLayer.delegate = _layerProxy;
  _degreeMarksLayer.contentsScale = [UIScreen mainScreen].scale;
  [self.layer addSublayer:_degreeMarksLayer];

  _wingsLayer = [[CALayer layer] retain];
  _wingsLayer.name = kWingsLayerName;
  _wingsLayer.frame = self.layer.bounds;
  _wingsLayer.delegate = _layerProxy;
  _wingsLayer.contentsScale = [UIScreen mainScreen].scale;

  [self.layer addSublayer:_wingsLayer];

  [_horizonLayer setNeedsDisplay];
  [_degreeMarksLayer setNeedsDisplay];
  [_wingsLayer setNeedsDisplay];
}

////////////////////////////////////////////////////////////////
#pragma mark Layer drawing 


//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawSkyBackground:(CGContextRef)context {

  CGColorRef lightColor = [UIColor colorWithRed:0.0 green:0.502 blue:1.0 alpha:1.0].CGColor;
  CGColorRef darkColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.502 alpha:1.0].CGColor;

  CGRect drawRect = CGRectMake(0.0, 0.0, CGRectGetWidth(_horizonLayer.frame), CGRectGetHeight(_horizonLayer.frame) / 2);

  drawLinearGradient(context, drawRect, darkColor, lightColor);
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawEarthBackground:(CGContextRef)context {

  CGColorRef lightColor = [UIColor colorWithRed:0.502 green:0.251 blue:0.0 alpha:1.0].CGColor;
  CGColorRef darkColor = [UIColor colorWithRed:1.0 green:0.502 blue:0.0 alpha:1.0].CGColor;

  CGRect drawRect = CGRectMake(0.0, CGRectGetHeight(_horizonLayer.frame) / 2,
          CGRectGetWidth(_horizonLayer.frame), CGRectGetHeight(_horizonLayer.frame) / 2);

  drawLinearGradient(context, drawRect, darkColor, lightColor);
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawHorizont:(CGContextRef)context {

  CGColorRef color = [UIColor whiteColor].CGColor;
  CGPoint startPoint = CGPointMake(0.0, CGRectGetMidY(_horizonLayer.bounds));
  CGPoint endPoint = CGPointMake(CGRectGetMaxX(_horizonLayer.bounds), CGRectGetMidY(_horizonLayer.bounds));

  CGContextSaveGState(context);
  CGContextSetLineCap(context, kCGLineCapSquare);
  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 2.0);
  CGContextMoveToPoint(context, startPoint.x, startPoint.y);
  CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  CGContextStrokePath(context);
  CGContextRestoreGState(context);
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawCalibrationLines:(CGContextRef)context {

  CGColorRef color = [UIColor whiteColor].CGColor;

  float fiveDeg = (5.0 / 60.0) * CGRectGetHeight(self.layer.bounds);

  for (int i = 1; i <= 6; i++) {
    float y = ceilf(CGRectGetMidY(_horizonLayer.bounds) + (i * fiveDeg));

    CGPoint startPoint = CGPointMake(CGRectGetMidX(_horizonLayer.bounds) - 20.0, y);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(_horizonLayer.bounds) + 20.0, y);

    draw1PxStroke(context, startPoint, endPoint, color);
  }
  for (int i = 1; i <= 6; i++) {
    float y = floorf(CGRectGetMidY(_horizonLayer.bounds) - (i * fiveDeg));

    CGPoint startPoint = CGPointMake(CGRectGetMidX(_horizonLayer.bounds) - 20.0, y);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(_horizonLayer.bounds) + 20.0, y);

    draw1PxStroke(context, startPoint, endPoint, color);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawHorizonLayer:(CGContextRef)context {
  [self drawSkyBackground:context];
  [self drawEarthBackground:context];
  [self drawHorizont:context];
  [self drawCalibrationLines:context];
}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawDegreeMarksLayer:(CGContextRef)context {
  CGColorRef whiteColor = [UIColor whiteColor].CGColor;

  CGContextSaveGState(context);

  CGFloat arcRadius = floor((_degreeMarksLayer.bounds.size.height / 2) * 0.9);

  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddArc(path, NULL,
          CGRectGetMidX(_degreeMarksLayer.bounds),
          CGRectGetMidY(_degreeMarksLayer.bounds),
          arcRadius, radians(180), radians(360), 0);

  CGContextAddPath(context, path);

  for (int d = -90; d <= 90; d += 30) {

    float x1 = floorf(arcRadius * sin(radians(d)));
    float y1 = floorf(arcRadius * cos(radians(d)));
    float x2 = floorf((arcRadius + 10) * sin(radians(d)));
    float y2 = floorf((arcRadius + 10) * cos(radians(d)));

    CGPoint startPoint = CGPointMake(CGRectGetMidX(_degreeMarksLayer.bounds) - x1,
            CGRectGetMidY(_degreeMarksLayer.bounds) - y1);

    CGPoint endPoint = CGPointMake(CGRectGetMidX(_degreeMarksLayer.bounds) - x2,
            CGRectGetMidY(_degreeMarksLayer.bounds) - y2);

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  }

  for (int d = -20; d <= 20; d += 10) {

    float x1 = floorf(arcRadius * sin(radians(d)));
    float y1 = floorf(arcRadius * cos(radians(d)));
    float x2 = floorf((arcRadius + 5) * sin(radians(d)));
    float y2 = floorf((arcRadius + 5) * cos(radians(d)));

    CGPoint startPoint = CGPointMake(CGRectGetMidX(_degreeMarksLayer.bounds) - x1,
            CGRectGetMidY(_degreeMarksLayer.bounds) - y1);

    CGPoint endPoint = CGPointMake(CGRectGetMidX(_degreeMarksLayer.bounds) - x2,
            CGRectGetMidY(_degreeMarksLayer.bounds) - y2);

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
  }

  CGContextSetStrokeColorWithColor(context, whiteColor);
  CGContextSetLineWidth(context, 1.0);
  CGContextStrokePath(context);

  CGContextRestoreGState(context);

}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawWingsLayer:(CGContextRef)context {

  CGColorRef color = [UIColor yellowColor].CGColor;

  CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2
                                            blue:0.2 alpha:0.5].CGColor;


  CGContextSaveGState(context);

  CGFloat arcRadius = floor((_degreeMarksLayer.bounds.size.height / 2) * 0.9) - 2.0;

  CGContextMoveToPoint(context, CGRectGetMidX(_wingsLayer.bounds),
          CGRectGetMidY(_degreeMarksLayer.bounds) - arcRadius);

  CGContextAddLineToPoint(context, CGRectGetMidX(_wingsLayer.bounds) - 5,
          CGRectGetMidY(_degreeMarksLayer.bounds) - arcRadius + 15);

  CGContextAddLineToPoint(context, CGRectGetMidX(_wingsLayer.bounds) + 5,
          CGRectGetMidY(_degreeMarksLayer.bounds) - arcRadius + 15);

  CGContextAddLineToPoint(context, CGRectGetMidX(_wingsLayer.bounds),
          CGRectGetMidY(_degreeMarksLayer.bounds) - arcRadius);


//  CGContextClosePath(context);
  CGContextSetStrokeColorWithColor(context, color);
//  CGContextSetLineWidth(context, 1.0);
//  CGContextStrokePath(context);

  CGContextSetFillColorWithColor(context, color);
  CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);

  CGContextFillPath(context);

  CGRect rect = CGRectMake(CGRectGetMidX(_wingsLayer.bounds) - 5.0, CGRectGetMidY(_wingsLayer.bounds) - 5.0, 10.0, 10.0);
  CGContextFillEllipseInRect(context, rect);

  CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);

  rect = CGRectMake(CGRectGetMidX(_wingsLayer.bounds) - 50.0, CGRectGetMidY(_wingsLayer.bounds) - 1.0, 20.0, 2.0);
  CGContextFillRect(context, rect);
  CGContextStrokeRect(context, rect);

  rect = CGRectMake(CGRectGetMidX(_wingsLayer.bounds) + 30.0, CGRectGetMidY(_wingsLayer.bounds) - 1.0, 20.0, 2.0);
  CGContextFillRect(context, rect);
  CGContextStrokeRect(context, rect);


  CGContextRestoreGState(context);
}


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutLayers {


  CATransform3D current;

  current = CATransform3DMakeRotation(radians(_roll), 0, 0, 1.0);
  _degreeMarksLayer.transform = current;
  current = CATransform3DTranslate(current, 0, (_pitch / 60.0) * CGRectGetHeight(self.layer.bounds), 0);
  _horizonLayer.transform = current;
}

@end

