//
//  RouteMapViewController.h
//  iKopter
//
//  Created by Frank Blumenberg on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Route.h"

@interface RouteMapViewController : UIViewController {
    
}

@property (retain) Route* route;


- (id)initWithRoute:(Route*) theRoute;


@end
