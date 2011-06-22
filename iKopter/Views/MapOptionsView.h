//
//  MapOptionsView.h
//  iKopter
//
//  Created by Frank Blumenberg on 22.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@protocol CurlMapOptionsViewDelegate;

@interface MapOptionsView : UIView {
    
}

@property(retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, assign) CGFloat paddingTop;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, assign) id <CurlMapOptionsViewDelegate> delegate;

-(IBAction) changeMapViewType;

@end

@protocol CurlMapOptionsViewDelegate <NSObject>

- (void)curlMapOptionsViewDidCaptureTouchOnPaddingRegion:(MapOptionsView *)curlMapOptionsView;

@end
