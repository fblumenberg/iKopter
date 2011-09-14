//
//  IKOutputSetting.m
//  InAppSettingsKitSampleApp
//
//  Created by mtg on 14.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IKOutputSetting.h"

@interface IKOutputSetting() 

-(void) initControl;

@end

@implementation IKOutputSetting

@synthesize insetColorOn;
@synthesize insetColorOff;
@synthesize frameColor;
@synthesize doDrawFrame;
@synthesize shining;
@synthesize cornerRoundness;
@synthesize value;
@synthesize key;

- (id)init
{
    self = [super init];
    if (self) {
        [self initControl];
    }
    
    return self;
}

- (void)dealloc {
    self.frameColor = nil;
    self.insetColorOn = nil;
    self.insetColorOff = nil;
    self.key = nil;
    [super dealloc];
}

-(void) awakeFromNib{
    [self initControl];
}

#pragma - mark NSCoding
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.frameColor forKey:@"frameColor"];
    [aCoder encodeBool:self.doDrawFrame forKey:@"doDrawFrame"];
    [aCoder encodeObject:self.insetColorOn forKey:@"insetColorOn"];
    [aCoder encodeObject:self.insetColorOff forKey:@"insetColorOff"];
    [aCoder encodeDouble:self.cornerRoundness forKey:@"cornerRoundness"];
    [aCoder encodeBool:self.shining forKey:@"shining"];
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        self.frameColor = [aDecoder decodeObjectForKey:@"frameColor"];
        self.doDrawFrame = [aDecoder decodeBoolForKey:@"doDrawFrame"];
        self.insetColorOn = [aDecoder decodeObjectForKey:@"insetColorOn"];
        self.insetColorOff = [aDecoder decodeObjectForKey:@"insetColorOff"];
        self.cornerRoundness = [aDecoder decodeDoubleForKey:@"cornerRoundness"];
        self.shining = [aDecoder decodeBoolForKey:@"shining"];
    }
    return self;
}

-(void) initControl {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]; 
    [self addGestureRecognizer:singleTap];
    [singleTap release];

    self.backgroundColor = [UIColor clearColor];
    self.frameColor = [UIColor whiteColor];
    self.doDrawFrame = YES;
    self.insetColorOn = [UIColor redColor];
    self.insetColorOff = [UIColor grayColor];
    self.cornerRoundness = 0.1;
    self.shining = YES;
}


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {  
    CGPoint loc=[gestureRecognizer locationInView:self];
    
    int delta = (int)(self.bounds.size.width/8);
    int index = 7-(int)(loc.x/delta);
    
    BOOL isOn = (self.value & (1<<index))!=0;
    if(isOn){
        self.value &=~(1<<index);
    }
    else{
        self.value |=(1<<index);
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [self setNeedsDisplay];
    
    NSLog(@"handleSingleTap %f,%f index=%d",loc.x,loc.y,index);
    
} 

// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect forIndex:(NSInteger)index
{
	CGContextSaveGState(context);
	
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
    
    BOOL isOn = (self.value & (1<<index))!=0;
    
    CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, isOn?[self.insetColorOn CGColor]:[self.insetColorOff CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextSetShadowWithColor(context, CGSizeMake(1.0,1.0), 3, [[UIColor blackColor] CGColor]);
	CGContextClosePath(context);

    CGContextFillPath(context);
    
	CGContextRestoreGState(context);
}

// Draws the Badge Shine with Quartz
-(void) drawShineWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGContextSaveGState(context);
    
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	CGContextBeginPath(context);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClip(context);
	CGContextClosePath(context);
	
	
	size_t num_locations = 2;
	CGFloat locations[2] = { 0.0, 0.4 };
	CGFloat components[8] = {  0.92, 0.92, 0.92, 1.0, 0.82, 0.82, 0.82, 0.4 };
    
	CGColorSpaceRef cspace;
	CGGradientRef gradient;
	cspace = CGColorSpaceCreateDeviceRGB();
	gradient = CGGradientCreateWithColorComponents (cspace, components, locations, num_locations);
	
	CGPoint sPoint, ePoint;
	sPoint.x = 0;
	sPoint.y = 0;
	ePoint.x = 0;
	ePoint.y = maxY;
	CGContextDrawLinearGradient (context, gradient, sPoint, ePoint, 0);
	
	CGColorSpaceRelease(cspace);
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);	
}


// Draws the Badge Frame with Quartz
-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect)*self.cornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	
	
    CGContextBeginPath(context);
	CGFloat lineSize = 2;
	CGContextSetLineWidth(context, lineSize);
	CGContextSetStrokeColorWithColor(context, [self.frameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}


- (void)drawRect:(CGRect)rect{
    
    CGContextRef context= UIGraphicsGetCurrentContext();
    
    int delta = (int)(self.bounds.size.width/8);
    
    CGRect segment=self.bounds;
    segment.size.width = delta;

    for(int i=7;i>=0;i--){
        [self drawRoundedRectWithContext:context withRect:segment forIndex:i];
        if(self.shining)
        [self drawShineWithContext:context withRect:segment];
        
        if(self.doDrawFrame)
            [self drawFrameWithContext:context withRect:segment];
        
        segment=CGRectOffset(segment, delta, 0);
    }
}

@end
