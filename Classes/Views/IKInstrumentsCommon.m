#import "IKInstrumentsCommon.h"

//////////////////////////////////////////////////////////////////////////////////////////
@implementation IKLayerDelegateProxy

- (id)initWithDelegate:(id)delegate {
  self = [super init];
  if (self) {
    _delegate = delegate;
  }
  return self; 
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  if( [_delegate respondsToSelector:@selector(drawLayer:inContext:)] )
    [_delegate drawLayer:layer inContext:ctx];
}

@end