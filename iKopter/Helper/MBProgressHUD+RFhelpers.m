//
//  MBProgressHUD+RFhelpers.m
//
//  Created by Eric Chamberlain on 5/6/10.
//  Copyright 2010 RF.com. All rights reserved.
//

#import "MBProgressHUD+RFhelpers.h"



@implementation MBProgressHUD(RFhelpers)

+ (MBProgressHUD *)sharedProgressHUD {

  static dispatch_once_t once;
	static MBProgressHUD *sharedPogressHUD__ = nil;

  dispatch_once(&once, ^ { 
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		sharedPogressHUD__ = [[[MBProgressHUD alloc] initWithWindow:window] retain];
		
		// Add HUD to screen
		[window addSubview:sharedPogressHUD__];
  });

	return sharedPogressHUD__;
}

+ (MBProgressHUD *)sharedNotificationHUD{
  static dispatch_once_t once;
  static  MBProgressHUD *sharedNotificationHUD__ = nil;;
  
  dispatch_once(&once, ^ { 
		UIWindow *window = [UIApplication sharedApplication].keyWindow;
		sharedNotificationHUD__ = [[[MBProgressHUD alloc] initWithWindow:window] retain];
		
		// Add HUD to screen
		[window addSubview:sharedNotificationHUD__];
  });

  return sharedNotificationHUD__;
}


- (void)showWithLabelText:(NSString *)text animated:(BOOL)animated {
	[self setLabelText:text];
	[self showAnimated:animated];
}

- (void)showAnimated:(BOOL)animated {
	[self layoutSubviews];
	[self setNeedsDisplay];
	
	useAnimation = animated;
	
	// Show HUD view
	SEL theSelector = @selector(showUsingAnimation:);
	NSInvocation *anInvocation = [NSInvocation
								  invocationWithMethodSignature:
								  [[self class] instanceMethodSignatureForSelector:theSelector]];
	
	[anInvocation setSelector:theSelector];
	[anInvocation setTarget:self];
	[anInvocation setArgument:&useAnimation atIndex:2];
	
	[anInvocation invoke];
}

- (void)hideAnimated:(BOOL)animated {
	// stops the animation
	[self performSelector:@selector(cleanUp)];
}

@end
