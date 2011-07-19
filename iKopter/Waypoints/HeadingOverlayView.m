//
//  HeadingOverlayView.m
//  iKopter
//
//  Created by Frank Blumenberg on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HeadingOverlayView.h"
#import "HeadingOverlay.h"
#import "Common.h"


@implementation HeadingOverlayView

@synthesize overlay;

-(id)initWithHeadingOverlay:(HeadingOverlay*)theOverlay{
  self=[super initWithCircle:overlay.circle];
  if(self){
    overlay=[theOverlay retain];
  }
  return self;
}

-(void)createPath{
  
  CGMutablePathRef path = CGPathCreateMutable();

  CGFloat arcRadius=MIN(self.bounds.size.width,self.bounds.size.height);
 
  CGFloat angle = radians(self.overlay.angle);
  CGFloat startAngle = angle - radians(15);
  CGFloat endAngle = angle + radians(15);

  CGPoint center=[self pointForMapPoint:MKMapPointForCoordinate(self.overlay.coordinate)];
  
  CGPathMoveToPoint(path, NULL,center.x,center.y);
  
  CGPathAddArc(path, NULL, center.x,center.y, arcRadius, 
               startAngle, endAngle, 0);
  
  CGPathCloseSubpath(path);
  
  self.path=path;
  
  CFRelease(path);
}

@end
