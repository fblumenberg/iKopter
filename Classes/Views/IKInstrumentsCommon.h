/*
 *  IKInstrumentsCommon.h
 *  LayerFun
 *
 *  Created by Frank Blumenberg on 04.02.11.
 *  Copyright 2011 de.frankblumenberg. All rights reserved.
 *
 */

@interface IKLayerDelegateProxy : NSObject 
{
  id _delegate;
}

- (id)initWithDelegate:(id)delegate;

@end
