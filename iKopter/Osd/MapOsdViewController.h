//
//  MapOsdViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 12.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "OsdValue.h"

@interface MapOsdViewController : UIViewController<OsdValueDelegate,MKMapViewDelegate,CLLocationManagerDelegate> {
    
  
}

//CLLocationManagerDelegate, MKReverseGeocoderDelegate, MKMapViewDelegate
@property(retain) IBOutlet MKMapView* mapView;
@property(retain) IBOutlet UISwitch* mapTypeSwitch;

- (IBAction)mapTypeChange;

@end
