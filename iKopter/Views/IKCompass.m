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
#import "IKCompass.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "Common.h"

#define  kDegreeMarksLayerName @"DegreeMarksLayerName"
#define  kWingsLayerName @"WingsLayerName"
#define  kTargetLayerName @"TargetLayerName"
#define  kHomeLayerName @"HomeLayerName"


@interface IKCompass (private)

- (void)initLayers;
//- (void)drawHorizonLayer:(CGContextRef)ctx; 

- (void)drawDegreeText:(CGContextRef)ctx text:(NSString *)text withColor:(CGColorRef)color atY:(CGFloat)y;
- (void)drawDegreeMarksLayer:(CGContextRef)ctx;

- (void)drawTargetLayer:(CGContextRef)ctx;
- (void)drawHomeLayer:(CGContextRef)ctx;
- (void)drawWingsLayer:(CGContextRef)ctx;
- (void)layoutLayers;
@end


@implementation IKCompass

@synthesize targetDeviation;
@synthesize homeDeviation;
@synthesize heading;

- (void)setHeading:(float)value {
  if (heading != value) {
    heading = value;
  }
  [self layoutLayers];
}

- (void)setTargetDeviation:(float)value {
  if (targetDeviation != value) {
    targetDeviation = value;
  }
  [self layoutLayers];
}

- (void)setHomeDeviation:(float)value {
  if (homeDeviation != value) {
    homeDeviation = value;
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


- (void)dealloc {
  [_targetDeviationLayer release];
  [_homeDeviationLayer release];
  [_degreeMarksLayer release];
  [_wingsLayer release];
  [_layerProxy release];

  [super dealloc];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {

  NSLog(@"drawLayer %@", layer.name);
  if ([layer.name isEqualToString:kTargetLayerName]) {
    [self drawTargetLayer:ctx];
  }
  else if ([layer.name isEqualToString:kHomeLayerName]) {
    [self drawHomeLayer:ctx];
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

@implementation IKCompass (private)

- (void)initLayers {

  _layerProxy = [[[IKLayerDelegateProxy alloc] initWithDelegate:self] retain];

  self.layer.backgroundColor = [UIColor darkGrayColor].CGColor;
  self.layer.shadowOffset = CGSizeMake(0, 3);
  self.layer.shadowRadius = 5.0;
  self.layer.shadowColor = [UIColor blackColor].CGColor;
  self.layer.shadowOpacity = 0.8;
  self.layer.borderColor = [UIColor blackColor].CGColor;
  self.layer.borderWidth = 2.0;
  self.layer.cornerRadius = 10.0;
  self.layer.masksToBounds = YES;

  _degreeMarksLayer = [[CALayer layer] retain];
  _degreeMarksLayer.name = kDegreeMarksLayerName;
  _degreeMarksLayer.frame = self.layer.bounds;
  _degreeMarksLayer.delegate = _layerProxy;
  _degreeMarksLayer.contentsScale = [UIScreen mainScreen].scale;
  [self.layer addSublayer:_degreeMarksLayer];

  _targetDeviationLayer = [[CALayer layer] retain];
  _targetDeviationLayer.name = kTargetLayerName;
  _targetDeviationLayer.frame = self.layer.bounds;
  _targetDeviationLayer.delegate = _layerProxy;
  _targetDeviationLayer.contentsScale = [UIScreen mainScreen].scale;
  [self.layer addSublayer:_targetDeviationLayer];

  _homeDeviationLayer = [[CALayer layer] retain];
  _homeDeviationLayer.name = kHomeLayerName;
  _homeDeviationLayer.frame = self.layer.bounds;
  _homeDeviationLayer.delegate = _layerProxy;
  _homeDeviationLayer.contentsScale = [UIScreen mainScreen].scale;
  [self.layer addSublayer:_homeDeviationLayer];

  _wingsLayer = [[CALayer layer] retain];
  _wingsLayer.name = kWingsLayerName;
  _wingsLayer.frame = self.layer.bounds;
  _wingsLayer.delegate = _layerProxy;
  _wingsLayer.contentsScale = [UIScreen mainScreen].scale;
  [self.layer addSublayer:_wingsLayer];

  [_homeDeviationLayer setNeedsDisplay];
  [_targetDeviationLayer setNeedsDisplay];
  [_degreeMarksLayer setNeedsDisplay];
  [_wingsLayer setNeedsDisplay];

}

////////////////////////////////////////////////////////////////
#pragma mark Layer drawing 

//////////////////////////////////////////////////////////////////////////////////////////

- (void)drawDegreeText:(CGContextRef)context text:(NSString *)text withColor:(CGColorRef)color atY:(CGFloat)y; {

  CTFontRef sysUIFont = CTFontCreateUIFontForLanguage(kCTFontSystemFontType,
          14.0, NULL);

  // pack it into attributes dictionary
  NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
          (id) sysUIFont, (id) kCTFontAttributeName,
          color, (id) kCTForegroundColorAttributeName, nil];

  // make the attributed string
  NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:attributesDict];

  // flip the coordinate system
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  CGContextScaleCTM(context, 1.0, -1.0);

  // draw
  CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef) stringToDraw);
  CGRect lineBounds = CTLineGetImageBounds(line, context);

  CGContextSetTextPosition(context, -(lineBounds.size.width / 2), y);
  CTLineDraw(line, context);

  // clean up
  CFRelease(line);
  CFRelease(sysUIFont);
  [stringToDraw release];
}


//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawDegreeMarksLayer:(CGContextRef)context {

  CGFloat arcRadius = MIN(_degreeMarksLayer.bounds.size.width, _degreeMarksLayer.bounds.size.height);
  arcRadius = floor((arcRadius / 2) * 0.7);

  //--------------------------------------------------------------------
  for (int d = 0; d < 360; d += 10) {

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(_degreeMarksLayer.bounds),
            CGRectGetMidY(_degreeMarksLayer.bounds));
    CGContextRotateCTM(context, radians(d));
    CGPoint startPoint = CGPointMake(0.0, -(arcRadius + 2));
    CGPoint endPoint = CGPointMake(0.0, -(arcRadius + 4));

    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 1.0);

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);

    if (d % 90 > 0 && d % 3 == 0) {
      NSString *text = [NSString stringWithFormat:@"%d", d / 10];
      [self drawDegreeText:context text:text withColor:[UIColor whiteColor].CGColor atY:(arcRadius + 5)];
    }

    CGContextRestoreGState(context);
  }
  //--------------------------------------------------------------------
  NSString *DIRECTION_NAMES[] = {@"N", @"E", @"S", @"W"};

  for (int d = 0; d < 4; d += 1) {

    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(_degreeMarksLayer.bounds),
            CGRectGetMidY(_degreeMarksLayer.bounds));
    CGContextRotateCTM(context, radians(d * 90));
    CGPoint startPoint = CGPointMake(0.0, -(arcRadius + 1));
    CGPoint endPoint = CGPointMake(0.0, -(arcRadius + 5));

    CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
    CGContextSetLineWidth(context, 2.0);

    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);

    [self drawDegreeText:context text:DIRECTION_NAMES[d] withColor:[UIColor yellowColor].CGColor atY:(arcRadius + 6)];

    CGContextRestoreGState(context);
  }
  //--------------------------------------------------------------------
}

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (void)drawWingsLayer:(CGContextRef)context {

  CGColorRef color = [UIColor yellowColor].CGColor;

  CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2
                                            blue:0.2 alpha:0.5].CGColor;

  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMidX(_wingsLayer.bounds),
          CGRectGetMidY(_wingsLayer.bounds));

  CGFloat arcRadius = MIN(_degreeMarksLayer.bounds.size.width, _degreeMarksLayer.bounds.size.height);
  arcRadius = floor((arcRadius / 2) * 0.6);

  CGPoint startPoint = CGPointMake(0.0, arcRadius);
  CGPoint endPoint = CGPointMake(0.0, -arcRadius);

  draw1PxStroke(context, startPoint, endPoint, color);

  CGContextMoveToPoint(context, -10.0, 20.0);
  CGContextAddLineToPoint(context, 10.0, 20.0);
  CGContextAddLineToPoint(context, 0.0, -20.0);


  CGContextSetFillColorWithColor(context, color);
  CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);

  CGContextFillPath(context);

  CGContextRestoreGState(context);
}

- (void)drawTargetLayer:(CGContextRef)context {
  CGColorRef color = [UIColor orangeColor].CGColor;

  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMidX(_wingsLayer.bounds),
          CGRectGetMidY(_wingsLayer.bounds));

  CGFloat arcRadius = MIN(_degreeMarksLayer.bounds.size.width, _degreeMarksLayer.bounds.size.height);
  arcRadius = floor((arcRadius / 2) * 0.6);

  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 2.0);

  CGContextMoveToPoint(context, 0.0, 0.0);
  CGContextAddLineToPoint(context, 0.0, -arcRadius);
  CGContextStrokePath(context);

  CGContextMoveToPoint(context, 0.0, -arcRadius);
  CGContextAddLineToPoint(context, 5.0, -arcRadius + 10);
  CGContextAddLineToPoint(context, -5.0, -arcRadius + 10);
  CGContextAddLineToPoint(context, 0.0, -arcRadius);
  CGContextSetFillColorWithColor(context, color);
  CGContextFillPath(context);

  CGContextRestoreGState(context);
}

- (void)drawHomeLayer:(CGContextRef)context {
  CGColorRef color = [UIColor cyanColor].CGColor;

  CGContextSaveGState(context);
  CGContextTranslateCTM(context, CGRectGetMidX(_wingsLayer.bounds),
          CGRectGetMidY(_wingsLayer.bounds));

  CGFloat arcRadius = MIN(_degreeMarksLayer.bounds.size.width, _degreeMarksLayer.bounds.size.height);
  arcRadius = floor((arcRadius / 2) * 0.6);

  CGContextSetStrokeColorWithColor(context, color);
  CGContextSetLineWidth(context, 2.0);

  CGContextMoveToPoint(context, 0.0, 0.0);
  CGContextAddLineToPoint(context, 0.0, -arcRadius);
  CGContextStrokePath(context);

  CGContextMoveToPoint(context, 0.0, -arcRadius);
  CGContextAddLineToPoint(context, 5.0, -arcRadius + 10);
  CGContextAddLineToPoint(context, -5.0, -arcRadius + 10);
  CGContextAddLineToPoint(context, 0.0, -arcRadius);
  CGContextSetFillColorWithColor(context, color);
  CGContextFillPath(context);

  CGContextRestoreGState(context);

}


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutLayers {

  NSLog(@"layoutLayers 1:%f 2:%f 3:%f", heading, targetDeviation, homeDeviation);

  _degreeMarksLayer.transform = CATransform3DMakeRotation(-radians(heading), 0, 0, 1.0);
  _targetDeviationLayer.transform = CATransform3DMakeRotation(-radians(targetDeviation), 0, 0, 1.0);
  _homeDeviationLayer.transform = CATransform3DMakeRotation(-radians(homeDeviation), 0, 0, 1.0);
}

@end

//////////////////////////////////////////////////////////////////////////////////////////


