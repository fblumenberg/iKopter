//
//  HeadingOverlayView.h
//  iKopter
//
//  Created by Frank Blumenberg on 04.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@class HeadingOverlay;

@interface HeadingOverlayView : MKCircleView {
    
}

@property(readonly) HeadingOverlay* overlay;

-(id)initWithHeadingOverlay:(HeadingOverlay*)overlay;

@end
