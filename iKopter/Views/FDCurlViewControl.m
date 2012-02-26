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

#import "FDCurlViewControl.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const kCurlUpAndDownAnimationID = @"kCurlUpAndDownAnimationID";
static CGFloat const kCurlAnimationDuration = 1.2;
static CGFloat const kCurlAnimationShouldStopAfter = 0.67;

@interface FDCurlViewControl ()
@property(nonatomic, assign, readwrite) BOOL isTargetViewCurled;
@property(nonatomic, assign) BOOL isAnimating;
@property(nonatomic, retain) NSTimer *animationTimer;

@property(nonatomic, retain) NSTimer *timer;
@end

@implementation FDCurlViewControl

@synthesize targetView = targetView_;
@synthesize isTargetViewCurled = isTargetViewCurled_;
@synthesize isAnimating = isAnimating_;
@synthesize hidesWhenAnimating = hidesWhenAnimating_;
@synthesize hidesTargetViewWhileCurled = hidesTargetViewWhileCurled_;

@synthesize delegate = delegate_;

@synthesize animationTimer = animationTimer_;
@synthesize curlAnimationDuration = curlAnimationDuration_;
@synthesize curlAnimationShouldStopAfter = curlAnimationShouldStopAfter_;

@synthesize timer = timer_;

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  CAAnimation *animation = [self.targetView.layer animationForKey:kCurlUpAndDownAnimationID];
  [animation setDelegate:nil];
  [self setTargetView:nil];

  [self.animationTimer invalidate];
  [self setAnimationTimer:nil];

  [self.timer invalidate];
  [self setTimer:nil];

  [super dealloc];
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)item {

  self = [super initWithBarButtonSystemItem:item
                                     target:self
                                     action:@selector(touched)];
  if (self) {
    self.curlAnimationDuration = kCurlAnimationDuration;
    self.curlAnimationShouldStopAfter = kCurlAnimationShouldStopAfter;
    self.hidesWhenAnimating = YES;
    self.hidesTargetViewWhileCurled = YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(curlViewDown)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
  }
  return self;
}

- (void)setIsAnimating:(BOOL)yesOrNo {
  isAnimating_ = yesOrNo;
}

- (void)touched {
  if (!self.isTargetViewCurled) {
    [self curlViewUp];
  } else {
    [self curlViewDown];
  }

}

- (void)curlViewUp {
  if (!self.isAnimating && !self.isTargetViewCurled) {
    self.isAnimating = YES;

    [UIView beginAnimations:kCurlUpAndDownAnimationID context:nil];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.targetView cache:YES];
    [UIView setAnimationDuration:self.curlAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView commitAnimations];
  }
}

- (void)curlViewDown {
  if (!self.isAnimating && self.isTargetViewCurled) {
    self.isAnimating = YES;

    if ([self.delegate respondsToSelector:@selector(curlViewControlWillCurlViewDown:)]) {
      [self.delegate curlViewControlWillCurlViewDown:self];
    }

    CFTimeInterval pausedTime = [self.targetView.layer timeOffset];
    self.targetView.layer.speed = 1.0;
    self.targetView.layer.timeOffset = 0.0;
    self.targetView.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.targetView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.targetView.layer.beginTime = timeSincePause - 2 * (self.curlAnimationDuration - self.curlAnimationShouldStopAfter);

    if (self.hidesTargetViewWhileCurled) {
      // Necessary to avoid a flick during the removal of layer and setting the target view visible again
      self.timer = [NSTimer scheduledTimerWithTimeInterval:(self.curlAnimationDuration - self.curlAnimationShouldStopAfter - 0.05)
                                                    target:self
                                                  selector:@selector(setTargetViewVisible)
                                                  userInfo:nil repeats:NO];
    }
  }
}

- (void)setTargetViewVisible {
  [self.timer invalidate];
  [self setTimer:nil];

  [self.targetView setHidden:NO];
}

- (void)cancelCurlingAnimation {
  [self.targetView.layer removeAllAnimations];
  self.targetView.layer.speed = 1.0;
  self.targetView.layer.timeOffset = 0.0;
  self.targetView.layer.beginTime = 0.0;

  self.isTargetViewCurled = NO;
  self.isAnimating = NO;
}

- (void)animationWillStart:(NSString *)animationID context:(void *)context {
  if ([self.delegate respondsToSelector:@selector(curlViewControlWillCurlViewUp:)]) {
    [self.delegate curlViewControlWillCurlViewUp:self];
  }

  self.isAnimating = YES;
  if (self.hidesTargetViewWhileCurled) {
    [self.targetView setHidden:YES];
  }
  self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:self.curlAnimationShouldStopAfter
                                                         target:self
                                                       selector:@selector(stopCurl)
                                                       userInfo:nil repeats:NO];
  return;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
  if (self.hidesTargetViewWhileCurled) {
    [self.targetView setHidden:NO];
  }
  self.isTargetViewCurled = NO;
  self.isAnimating = NO;

  if ([self.delegate respondsToSelector:@selector(curlViewControlDidCurlViewDown:)]) {
    [self.delegate curlViewControlDidCurlViewDown:self];
  }
}

- (void)stopCurl {
  [self.animationTimer invalidate];
  [self setAnimationTimer:nil];

  CFTimeInterval pausedTime = [self.targetView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
  self.targetView.layer.speed = 0.0;
  self.targetView.layer.timeOffset = pausedTime;

  self.isTargetViewCurled = YES;
  self.isAnimating = NO;

  if ([self.delegate respondsToSelector:@selector(curlViewControlDidCurlViewUp:)]) {
    [self.delegate curlViewControlDidCurlViewUp:self];
  }
}

@end
