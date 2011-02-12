/*
 CustomBadge.m
 
 *** Description: ***
 With this class you can draw a typical iOS badge indicator with a custom text on any view.
 Please use the allocator customBadgeWithString the create a new badge.
 In this version you can modfiy the color inside the badge (insetColor),
 the color of the frame (frameColor), the color of the text and you can
 tell the class if you want a frame around the badge.
 
 *** License & Copyright ***
 Created by Sascha Marc Paulus www.spaulus.com on 08/2010. Version 1.0
 This tiny class can be used for free in private and commercial applications.
 Please feel free to modify, extend or distribution this class. 
 If you modify it: Please send me your modified version of the class.
 A commercial distribution of this class is not allowed.
 
 If you have any questions please feel free to contact me (open@spaulus.com).
 */


#import "CustomBadge.h"

@interface CustomBadge()
- (id) initWithString:(NSString *)badgeString;
- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor;
- (void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect;
- (void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect;
@end

@implementation CustomBadge

@synthesize badgeText;
@synthesize badgeTextColor;
@synthesize badgeInsetColor;
@synthesize badgeFrameColor;
@synthesize badgeFrame;
@synthesize badgeCornerRoundness;


// Use this method if you want to change the badge text after the first rendering 
- (void) autoBadgeSizeWithString:(NSString *)badgeString
{
	CGSize retValue = CGSizeMake(25, 25);
	CGFloat rectWidth, rectHeight;
	CGSize stringSize = [badgeString sizeWithFont:[UIFont boldSystemFontOfSize:12]];
	CGFloat flexSpace;
	if ([badgeString length]>=2) 
	{
		flexSpace = [badgeString length]*1;
		rectWidth = 25 + (stringSize.width + flexSpace); rectHeight = 25;
		retValue = CGSizeMake(rectWidth, rectHeight);
	}
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, retValue.width, retValue.height);
	self.badgeText = badgeString;
}

// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString
{
	self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
	[self autoBadgeSizeWithString:badgeString];
	if(self!=nil)
	{
		self.backgroundColor = [UIColor clearColor];
		self.badgeText = badgeString;
		self.badgeTextColor = [UIColor whiteColor];
		self.badgeFrame = YES;
		self.badgeFrameColor = [UIColor whiteColor];
		self.badgeInsetColor = [UIColor redColor];
		self.badgeCornerRoundness = 0.40;		
	}
	return self;
}


- (void) awakeFromNib {
	[self autoBadgeSizeWithString:@""];
  self.backgroundColor = [UIColor clearColor];
  self.badgeText = @"";
  self.badgeTextColor = [UIColor whiteColor];
  self.badgeFrame = YES;
  self.badgeFrameColor = [UIColor whiteColor];
  self.badgeInsetColor = [UIColor redColor];
  self.badgeCornerRoundness = 0.40;		
}


// I recommend to use the allocator customBadgeWithString
- (id) initWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor
{
	self = [super initWithFrame:CGRectMake(0, 0, 25, 25)];
	[self autoBadgeSizeWithString:badgeString];
	if(self!=nil)
	{
		self.backgroundColor = [UIColor clearColor];
		self.badgeText = badgeString;
		self.badgeTextColor = stringColor;
		self.badgeFrame = badgeFrameYesNo;
		self.badgeFrameColor = frameColor;
		self.badgeInsetColor = insetColor;
		self.badgeCornerRoundness = 0.40;		
	}
	return self;
}

// Creates a Badge with a given Text 
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString
{
	return [[[self alloc] initWithString:badgeString] autorelease];
}

// Creates a Badge with a given Text, Text Color, Inset Color, Frame (YES/NO) and Frame Color 
+ (CustomBadge*) customBadgeWithString:(NSString *)badgeString withStringColor:(UIColor*)stringColor withInsetColor:(UIColor*)insetColor withBadgeFrame:(BOOL)badgeFrameYesNo withBadgeFrameColor:(UIColor*)frameColor
{
	return [[[self alloc] initWithString:badgeString withStringColor:stringColor withInsetColor:insetColor withBadgeFrame:badgeFrameYesNo withBadgeFrameColor:frameColor] autorelease];
}


// Draws the Badge with Quartz
-(void) drawRoundedRectWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	
    CGContextBeginPath(context);
	CGContextSetFillColorWithColor(context, [self.badgeInsetColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextSetShadowWithColor(context, CGSizeMake(2,2), 3, [[UIColor blackColor] CGColor]);
	CGContextClosePath(context);
    CGContextFillPath(context);
	
}

// Draws the Badge Frame with Quartz
-(void) drawFrameWithContext:(CGContextRef)context withRect:(CGRect)rect
{
	CGFloat radius = CGRectGetMaxY(rect)*self.badgeCornerRoundness;
	CGFloat puffer = CGRectGetMaxY(rect)*0.10;
	
	CGFloat maxX = CGRectGetMaxX(rect) - puffer;
	CGFloat maxY = CGRectGetMaxY(rect) - puffer;
	CGFloat minX = CGRectGetMinX(rect) + puffer;
	CGFloat minY = CGRectGetMinY(rect) + puffer;
	
	
    CGContextBeginPath(context);
	CGContextSetLineWidth(context, 2);
	CGContextSetStrokeColorWithColor(context, [self.badgeFrameColor CGColor]);
	CGContextAddArc(context, maxX-radius, minY+radius, radius, M_PI+(M_PI/2), 0, 0);
	CGContextAddArc(context, maxX-radius, maxY-radius, radius, 0, M_PI/2, 0);
	CGContextAddArc(context, minX+radius, maxY-radius, radius, M_PI/2, M_PI, 0);
	CGContextAddArc(context, minX+radius, minY+radius, radius, M_PI, M_PI+M_PI/2, 0);
	CGContextClosePath(context);
	CGContextStrokePath(context);
}


// Draws Method
- (void)drawRect:(CGRect)rect {

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetShouldAntialias(context, YES);
	
	CGLayerRef buttonLayer = CGLayerCreateWithContext(context, rect.size, NULL);
	CGContextRef buttonLayer_Context = CGLayerGetContext(buttonLayer);
	[self drawRoundedRectWithContext:buttonLayer_Context withRect:rect];
	CGContextDrawLayerInRect(context, rect, buttonLayer);
	CGLayerRelease(buttonLayer);

	if (self.badgeFrame) 
	{
		CGLayerRef frameLayer = CGLayerCreateWithContext(context, rect.size, NULL);
		CGContextRef frameLayer_Context = CGLayerGetContext(frameLayer);
		[self drawFrameWithContext:frameLayer_Context withRect:rect];
		CGContextDrawLayerInRect(context, rect, frameLayer);
		CGLayerRelease(frameLayer);		
	}
	
	if ([self.badgeText length]>0) 
	{
		[badgeTextColor set];
		UIFont *textFont = [UIFont boldSystemFontOfSize:13];
		CGSize textSize = [self.badgeText sizeWithFont:textFont];
		[self.badgeText drawAtPoint:CGPointMake((rect.size.width/2-textSize.width/2), (rect.size.height/2-textSize.height/2)) withFont:textFont];
		
	}
	
	

}


- (void)dealloc {
	
	[badgeText release];
	[badgeTextColor release];
	[badgeInsetColor release];
	[badgeFrameColor release];
	 
    [super dealloc];
}


@end
