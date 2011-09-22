//
//  IBAFormSection+MKParam.h
//  IBAFormsShowcase
//
//  Created by mtg on 22.09.11.
//  Copyright 2011 Itty Bitty Apps. All rights reserved.
//

#import <IBAForms/IBAForms.h>

@interface IBAFormSection (IBAFormSection_MKParam)

-(void)addNumberFieldForKeyPath:(NSString*)keyPath title:(NSString*)title;
-(void)addSwitchFieldForKeyPath:(NSString*)keyPath title:(NSString*)title;
-(void)addTextFieldForKeyPath:(NSString*)keyPath title:(NSString*)title;
-(void)addPotiFieldForKeyPath:(NSString*)keyPath title:(NSString*)title;

-(void)addChannelsForKeyPath:(NSString*)keyPath title:(NSString*)title;
-(void)addChannelsPlusForKeyPath:(NSString*)keyPath title:(NSString*)title;


@end
