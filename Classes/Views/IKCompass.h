//
//  IKAttitudeIndicator.h
//  LayerFun
//
//  Created by Frank Blumenberg on 17.01.11.
//  Copyright 2011 de.frankblumenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKLayerDelegateProxy;

@interface IKCompass : UIView {

  float heading;
  float targetDeviation;
  float homeDeviation;
  
  CALayer* _degreeMarksLayer;
  CALayer* _wingsLayer;
  CALayer* _targetDeviationLayer;
  CALayer* _homeDeviationLayer;
  
  IKLayerDelegateProxy* _layerProxy;
}

@property(nonatomic,assign) float heading;
@property(nonatomic,assign) float targetDeviation;
@property(nonatomic,assign) float homeDeviation;


@end
