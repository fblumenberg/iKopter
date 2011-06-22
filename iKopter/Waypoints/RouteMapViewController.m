//
//  RouteMapViewController.m
//  iKopter
//
//  Created by Frank Blumenberg on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "RouteMapViewController.h"


@implementation RouteMapViewController

@synthesize route;
@synthesize mapView;
@synthesize curlBarItem;
@synthesize segmentedControl;

- (id)initWithRoute:(Route*) theRoute {
  self = [super initWithNibName:@"RouteMapViewController" bundle:nil];
  if (self) {
    self.route = theRoute;
  }
  return self;
}

- (void)dealloc
{
  self.route = nil;
  self.curlBarItem = nil;
  [super dealloc];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.curlBarItem = [[[FDCurlViewControl alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPageCurl]autorelease];
  [self.curlBarItem setHidesWhenAnimating:NO];
  [self.curlBarItem setTargetView:self.mapView];
  
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self.curlBarItem 
                                                                              action:@selector(curlViewDown)];  
  [self.view addGestureRecognizer:singleTap];
  [singleTap release];    
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

#pragma mark - Page Curl stuff

- (void)changeMapViewType {
	[self.mapView setMapType:self.segmentedControl.selectedSegmentIndex];
  [self.curlBarItem curlViewDown];
}

@end
