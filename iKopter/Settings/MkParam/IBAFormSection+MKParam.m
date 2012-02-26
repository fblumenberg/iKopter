//
//  IBAFormSection+MKParam.m
//  IBAFormsShowcase
//
//  Created by mtg on 22.09.11.
//  Copyright 2011 Itty Bitty Apps. All rights reserved.
//

#import "IBAFormSection+MKParam.h"
#import "StringToNumberTransformer.h"
#import "MKParamPotiValueTransformer.h"

@implementation IBAFormSection (IBAFormSection_MKParam)

- (void)addNumberFieldForKeyPath:(NSString *)keyPath title:(NSString *)title {

  IBATextFormField *numberField;
  numberField = [[IBATextFormField alloc] initWithKeyPath:keyPath
                                                    title:title
                                         valueTransformer:[StringToNumberTransformer instance]];
  [self addFormField:[numberField autorelease]];
  numberField.textFormFieldCell.textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)addSwitchFieldForKeyPath:(NSString *)keyPath title:(NSString *)title {
  [self addSwitchFieldForKeyPath:keyPath title:title style:nil];
}

- (void)addSwitchFieldForKeyPath:(NSString *)keyPath title:(NSString *)title style:(IBAFormFieldStyle *)style {
  IBABooleanFormField *f = [[[IBABooleanFormField alloc] initWithKeyPath:keyPath title:title] autorelease];
  if (style) {
    f.formFieldStyle = style;
  }
  [self addFormField:f];
}

- (void)addTextFieldForKeyPath:(NSString *)keyPath title:(NSString *)title {

  [self addFormField:[[[IBATextFormField alloc] initWithKeyPath:keyPath title:title] autorelease]];
}

- (void)addPotiFieldForKeyPath:(NSString *)keyPath title:(NSString *)title {

  MKParamPotiValueTransformer *potiTransformer = nil;
  potiTransformer = [MKParamPotiValueTransformer transformer];
  [self addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:keyPath
                                                              title:title
                                                   valueTransformer:potiTransformer
                                                      selectionMode:IBAPickListSelectionModeSingle
                                                            options:potiTransformer.pickListOptions] autorelease]];

}


- (void)addChannelsForKeyPath:(NSString *)keyPath title:(NSString *)title {

  NSMutableArray *values = [NSMutableArray arrayWithCapacity:12];
  [values addObject:NSLocalizedString(@"Off", @"RC-Channel")];
  for (int i = 0; i < 12; i++)
    [values addObject:[NSString stringWithFormat:NSLocalizedString(@"RC Channel %d", @"RC-Channel"), i + 1]];

  NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:values];

  IBASingleIndexTransformer *transformer = [[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptions] autorelease];

  [self addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:keyPath
                                                              title:title
                                                   valueTransformer:transformer
                                                      selectionMode:IBAPickListSelectionModeSingle
                                                            options:pickListOptions] autorelease]];
}

- (void)addChannelsPlusForKeyPath:(NSString *)keyPath title:(NSString *)title {

  NSMutableArray *values = [NSMutableArray arrayWithCapacity:25];
  [values addObject:NSLocalizedString(@"Off", @"RC-Channel")];
  for (int i = 0; i < 12; i++)
    [values addObject:[NSString stringWithFormat:NSLocalizedString(@"RC Channel %d", @"RC-Channel"), i + 1]];

  for (int i = 0; i < 12; i++)
    [values addObject:[NSString stringWithFormat:NSLocalizedString(@"Serial Channel %d", @"RC-Channel"), i + 1]];

  [values addObject:NSLocalizedString(@"WP Event Channel", @"RC-Channel")];

  NSArray *pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:values];

  IBASingleIndexTransformer *transformer = [[[IBASingleIndexTransformer alloc] initWithPickListOptions:pickListOptions] autorelease];

  [self addFormField:[[[IBAPickListFormField alloc] initWithKeyPath:keyPath
                                                              title:title
                                                   valueTransformer:transformer
                                                      selectionMode:IBAPickListSelectionModeSingle
                                                            options:pickListOptions] autorelease]];
}

@end
