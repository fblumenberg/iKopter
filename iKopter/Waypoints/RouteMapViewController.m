//
//  RouteMapViewController.m
//  iKopter
//
//  Created by Frank Blumenberg on 21.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RouteMapViewController.h"


@implementation RouteMapViewController

@synthesize route;

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
  // Do any additional setup after loading the view from its nib.
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
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
