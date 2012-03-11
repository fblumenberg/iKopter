//
//  BFStepper.m
//  WaveRecorder
//
//  Created by Алексеев Владислав on 11.09.11.
//  Copyright 2011 beefon software. All rights reserved.
//

#import "BFStepper.h"

const CGSize BFStepperFrame = {94.0, 27.0};

@interface BFStepper () {
  UIButton *_minusButton;
  UIButton *_plusButton;
  UIImageView *_plusImage;
  UIImageView *_minusImage;
  UIImageView *_middleImage;
  BFStepperChangeKind _changeValue;
  BFStepperChangeKind _longTapLoopValue;

  NSUInteger _stepsForLongTap;
}
@property(nonatomic, retain, readonly) UIButton *plusButton;
@property(nonatomic, retain, readonly) UIButton *minusButton;
@property(nonatomic, retain, readonly) UIImageView *plusImage;
@property(nonatomic, retain, readonly) UIImageView *minusImage;
@property(nonatomic, retain, readonly) UIImageView *middleImage;

- (void)commonInit;
- (void)updateValue;
@end

@implementation BFStepper

@synthesize plusButton = _plusButton;
@synthesize minusButton = _minusButton;
@synthesize plusImage = _plusImage;
@synthesize minusImage = _minusImage;
@synthesize middleImage = _middleImage;
@synthesize changeValue = _changeValue;

@synthesize value = _value;
@synthesize maximumValue = _maximumValue, minimumValue = _minimumValue, stepValue = _stepValue;
@synthesize autorepeat = _autorepeat;
@synthesize wraps = _wraps;
@synthesize continuous;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)awakeFromNib {
  [self commonInit];
}

- (void)dealloc {
  [_minusButton release];
  [_plusButton release];
  [_plusImage release];
  [_minusImage release];
  [_middleImage release];

  [super dealloc];
}

- (void)commonInit {
  self.backgroundColor = [UIColor clearColor];
  self.multipleTouchEnabled = NO;
  self.clipsToBounds = YES;

  _stepsForLongTap = 0;
  _value = 0;
  _maximumValue = 100;
  _minimumValue = 0;
  _stepValue = 1;
  _autorepeat = YES;
  _wraps = NO;

  _middleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIStepperMiddle.png"]];
  _middleImage.frame = CGRectMake(45.0, 0, 4.0, BFStepperFrame.height);
  [self addSubview:_middleImage];

  _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_minusButton retain];
  _minusButton.frame = CGRectMake(0.0, 0.0, 48.0, BFStepperFrame.height);
  [_minusButton setAdjustsImageWhenHighlighted:NO];
  [_minusButton setImage:[UIImage imageNamed:@"UIStepperLeft.png"] forState:UIControlStateNormal];
  [_minusButton setImage:[UIImage imageNamed:@"UIStepperLeftDisabled.png"] forState:UIControlStateDisabled];
  [_minusButton setImage:[UIImage imageNamed:@"UIStepperLeftPressed.png"] forState:UIControlStateHighlighted];
  [_minusButton addTarget:self
                   action:@selector(didPressMinusButton)
         forControlEvents:UIControlEventTouchUpInside];
  [_minusButton addTarget:self
                   action:@selector(didBeginMinusLongTap)
         forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
  [_minusButton addTarget:self
                   action:@selector(didEndLongTap)
         forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
  [self addSubview:_minusButton];

  _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_plusButton retain];
  _plusButton.frame = CGRectMake(46.0, 0.0, 48.0, BFStepperFrame.height);
  [_plusButton setAdjustsImageWhenHighlighted:NO];
  [_plusButton setImage:[UIImage imageNamed:@"UIStepperRight.png"] forState:UIControlStateNormal];
  [_plusButton setImage:[UIImage imageNamed:@"UIStepperRightDisabled.png"] forState:UIControlStateDisabled];
  [_plusButton setImage:[UIImage imageNamed:@"UIStepperRightPressed.png"] forState:UIControlStateHighlighted];
  [_plusButton addTarget:self
                  action:@selector(didPressPlusButton)
        forControlEvents:UIControlEventTouchUpInside];
  [_plusButton addTarget:self
                  action:@selector(didBeginPlusLongTap)
        forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
  [_plusButton addTarget:self
                  action:@selector(didEndLongTap)
        forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
  [self addSubview:_plusButton];

  _plusImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIStepperPlus.png"]];
  _plusImage.contentMode = UIViewContentModeCenter;
  _plusImage.frame = CGRectMake(46.0, 1.0, 47.0, 26.0);
  [self addSubview:_plusImage];

  _minusImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UIStepperMinus.png"]];
  _minusImage.contentMode = UIViewContentModeCenter;
  _minusImage.frame = CGRectMake(0.0, 1.0, 47.0, 26.0);
  [self addSubview:_minusImage];
}

- (void)setFrame:(CGRect)frame {
  frame.size = BFStepperFrame;
  [super setFrame:frame];
}

#pragma mark -
#pragma mark Button Events

#pragma mark Plus Button Events

- (void)didPressPlusButton {
  _changeValue = BFStepperChangeKindPositive;
  [self updateValue];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didBeginPlusLongTap {
  if (_autorepeat) {

    _longTapLoopValue = BFStepperChangeKindPositive;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(backgroundLongTapLoop)
                                               object:nil];
    _stepsForLongTap = 0;
    [self performSelector:@selector(backgroundLongTapLoop) withObject:nil afterDelay:0.5];
  }
}

#pragma mark Minus Button Events

- (void)didPressMinusButton {
  _changeValue = BFStepperChangeKindNegative;
  [self updateValue];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didBeginMinusLongTap {
  if (_autorepeat) {
    _longTapLoopValue = BFStepperChangeKindNegative;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(backgroundLongTapLoop)
                                               object:nil];
    _stepsForLongTap = 0;
    [self performSelector:@selector(backgroundLongTapLoop) withObject:nil afterDelay:0.5];
  }
}

#pragma mark Long Tap Loop

- (void)didEndLongTap {
  [NSObject cancelPreviousPerformRequestsWithTarget:self
                                           selector:@selector(backgroundLongTapLoop)
                                             object:nil];
}

- (void)backgroundLongTapLoop {
  [self performSelectorOnMainThread:@selector(longTapLoop)
                         withObject:nil waitUntilDone:YES];

  NSTimeInterval interval = ++_stepsForLongTap >= 5 ? 0.1 : 0.5;

  if (_stepsForLongTap >= 30)
    interval = 0.05;

  [self performSelector:@selector(backgroundLongTapLoop)
             withObject:nil afterDelay:interval];
}

- (void)longTapLoop {
  _changeValue = _longTapLoopValue;
  [self updateValue];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)updateValue {
  if (_changeValue == BFStepperChangeKindPositive) {
    if ((_value + _stepValue) <= _maximumValue)
      self.value = _value + _stepValue;
    else if (_wraps) {
      self.value = _value + _stepValue - _maximumValue;
    }
  }
  else {
    NSLog(@"_value %f - _stepValue %f  %f >= %f", _value, _stepValue, _value - _stepValue, _minimumValue);

    if ((_value - _stepValue) >= _minimumValue)
      self.value = _value - _stepValue;
    else if (_wraps) {
      self.value = _value - _stepValue + _maximumValue;
    }
  }

  self.plusButton.enabled = (_value != _maximumValue);
  self.minusButton.enabled = (_value != _minimumValue);
  NSLog(@"self.minusButton.enabled %d", self.minusButton.enabled);
  NSLog(@"self.plusButton.enabled %d", self.plusButton.enabled);
}

@end
