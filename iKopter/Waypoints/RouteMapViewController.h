//
//  RouteMapViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"
#import "FDCurlViewControl.h"

@class MKMapView;

@interface RouteMapViewController : UIViewController {
    
}

@property (retain) Route* route;
@property (retain) IBOutlet MKMapView *mapView;
@property (retain) FDCurlViewControl* curlBarItem;
@property(retain) IBOutlet UISegmentedControl *segmentedControl;

- (id)initWithRoute:(Route*) theRoute;
- (IBAction) changeMapViewType;
- (void)addPoint;


@end
