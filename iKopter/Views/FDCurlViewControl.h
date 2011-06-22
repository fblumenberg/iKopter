//
//  Copyright (c) 2011, Fairfax Media Publications Pty Limited
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//		* Redistributions of source code must retain the above copyright
//		  notice, this list of conditions and the following disclaimer.
//		* Redistributions in binary form must reproduce the above copyright
//		  notice, this list of conditions and the following disclaimer in the
//		  documentation and/or other materials provided with the distribution.
//		* Neither the name of the Fairfax Media nor the
//		  names of its contributors may be used to endorse or promote products
//		  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
//  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
//  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
//  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
//  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
//  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
//  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
//  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
//  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
//  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

//	Inspirational source: http://developer.apple.com/library/ios/#qa/qa2009/qa1673.html

#import <UIKit/UIKit.h>

@protocol FDCurlViewControlDelegate;

@interface FDCurlViewControl : UIBarButtonItem {
@private
	UIView *targetView_;
	BOOL isTargetViewCurled_;
	BOOL isAnimating_;
	BOOL hidesWhenAnimating_; // Default to YES
	BOOL hidesTargetViewWhileCurled_; // Default to YES
	
	id <FDCurlViewControlDelegate> delegate_;
	
	NSTimer *animationTimer_;
	NSTimeInterval curlAnimationDuration_;
	NSTimeInterval curlAnimationShouldStopAfter_;
	
	NSTimer *timer_;
}

@property (nonatomic, retain) UIView *targetView;
@property (nonatomic, assign, readonly) BOOL isTargetViewCurled;
@property (nonatomic, assign) BOOL hidesWhenAnimating;
@property (nonatomic, assign) BOOL hidesTargetViewWhileCurled;

@property (nonatomic, assign) id <FDCurlViewControlDelegate> delegate;

@property (nonatomic, assign) NSTimeInterval curlAnimationDuration;
@property (nonatomic, assign) NSTimeInterval curlAnimationShouldStopAfter;

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item;
- (void)curlViewUp;
- (void)curlViewDown;
- (void)cancelCurlingAnimation;
- (void)touched;


@end

@protocol FDCurlViewControlDelegate <NSObject>
@optional
- (void)curlViewControlWillCurlViewUp:(FDCurlViewControl *)control;
- (void)curlViewControlDidCurlViewUp:(FDCurlViewControl *)control;
- (void)curlViewControlWillCurlViewDown:(FDCurlViewControl *)control;
- (void)curlViewControlDidCurlViewDown:(FDCurlViewControl *)control;
@end
