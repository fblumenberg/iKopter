//
//  BFStepper.h
//  WaveRecorder
//
//  Created by Алексеев Владислав on 11.09.11.
//  Copyright 2011 beefon software. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This control has fixed size that you can always get from this const.
 */
UIKIT_EXTERN const CGSize BFStepperFrame;

typedef enum {
    BFStepperChangeKindNegative = -1, // event means one step down
    BFStepperChangeKindPositive = 1 // event means one step up
} BFStepperChangeKind;

@interface BFStepper : UIControl 

@property(nonatomic,getter=isContinuous) BOOL continuous; // if YES, value change events are sent any time the value changes during interaction. default = YES
@property(nonatomic) double value;                        // default is 0. sends UIControlEventValueChanged. clamped to min/max
@property(nonatomic) double minimumValue;                 // default 0. must be less than maximumValue
@property(nonatomic) double maximumValue;                 // default 100. must be greater than minimumValue
@property(nonatomic) double stepValue;                    // default 1. must be greater than 0
@property(nonatomic) BOOL autorepeat;                     // if YES, press & hold repeatedly alters value. default = YES
@property(nonatomic) BOOL wraps;                          // if YES, value wraps from min <-> max. default = NO


/** 
 Describes kind of change.
 If value is BFStepperChangeKindNegative - "minus" button was pressed.
 If value is BFStepperChangeKindPositive - "plus" button was pressed.
 */
@property (nonatomic, assign, readonly) BFStepperChangeKind changeValue;

@end
