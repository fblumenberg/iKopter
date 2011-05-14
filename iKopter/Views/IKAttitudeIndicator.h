//
//  IKAttitudeIndicator.h
//  LayerFun
//
//  Created by Frank Blumenberg on 17.01.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKLayerDelegateProxy;

@interface IKAttitudeIndicator : UIView {

  float _pitch;
  float _roll;
  
  CALayer* _horizonLayer;
  CALayer* _degreeMarksLayer;
  CALayer* _wingsLayer;

  IKLayerDelegateProxy* _layerProxy;
}

@property(assign) float pitch;
@property(assign) float roll;


@end
