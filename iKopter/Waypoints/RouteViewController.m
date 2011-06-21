// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010, Frank Blumenberg
//
// See License.txt for complete licensing and attribution information.
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// ///////////////////////////////////////////////////////////////////////////////

#import "RouteViewController.h"
#import "RouteListViewController.h"
#import "RouteMapViewController.h"

@interface RouteViewController()

-(void) updateSelectedViewFrame;
-(void) changeView;

@end

@implementation RouteViewController

@synthesize viewControllers;
@synthesize selectedViewController;
@synthesize route;
@synthesize segment;

/////////////////////////////////////////////////////////////////////////////////

- (id)initWithRoute:(Route*) theRoute {
  self = [super initWithNibName:@"RouteViewController" bundle:nil];
  if (self) {
    self.route=theRoute;
    self.title=NSLocalizedString(@"Route", @"Waypoint Lists title");
    
    RouteListViewController*  listViewController=[[RouteListViewController alloc] initWithRoute:theRoute];
    RouteMapViewController* mapViewController=[[RouteMapViewController alloc] initWithRoute:theRoute];
    
    NSArray *array = [[NSArray alloc] initWithObjects:listViewController, mapViewController, nil];
    self.viewControllers = array;
    
    [self.view addSubview:listViewController.view];
    self.selectedViewController = listViewController;
    
    [array release];
    [listViewController release];
    [mapViewController release];
    
  }
  return self;
}

- (void)dealloc {
  self.route = nil;
  self.viewControllers = nil;
  self.selectedViewController = nil;
  
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
  
  NSArray* segmentItems = [NSArray arrayWithObjects:@"List",@"Map",nil];
  segment = [[UISegmentedControl alloc] initWithItems:segmentItems];
  segment.segmentedControlStyle=UISegmentedControlStyleBar;
  
  segment.tintColor = [UIColor darkGrayColor];
  [segment setImage:[UIImage imageNamed:@"list-mode.png"] forSegmentAtIndex:0];
  [segment setWidth:50.0 forSegmentAtIndex:0];
  [segment setWidth:50.0 forSegmentAtIndex:1];
  [segment setImage:[UIImage imageNamed:@"map-mode.png"] forSegmentAtIndex:1];
  
  
  [segment addTarget:self
              action:@selector(changeView)
    forControlEvents:UIControlEventValueChanged];
  
  UIBarButtonItem* segmentButton;
  segmentButton =  [[[UIBarButtonItem alloc]
                     initWithCustomView:segment] autorelease];

  [self.navigationItem setRightBarButtonItem:segmentButton animated:NO];
  

}

- (void)viewDidUnload
{
  [super viewDidUnload];

  self.route = nil;
  self.viewControllers = nil;
  self.selectedViewController = nil;
}

- (void) viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  [self.selectedViewController viewWillAppear:animated];
  [self updateSelectedViewFrame];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) updateSelectedViewFrame {
  self.selectedViewController.view.frame=CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 
                                                    CGRectGetHeight(self.view.bounds));

//  [self.navigationItem setRightBarButtonItem:self.selectedViewController.editButtonItem animated:YES];
}


/////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITabBarDelegate

-(void) changeView{
  UIViewController *newSelectedViewController = [viewControllers objectAtIndex:segment.selectedSegmentIndex];
  
  [self.selectedViewController setEditing:NO animated:YES];
  [self.selectedViewController viewWillDisappear:NO];
  [self.selectedViewController.view removeFromSuperview];
  
  [self.view addSubview:newSelectedViewController.view];
  self.selectedViewController = newSelectedViewController;
  [self.selectedViewController viewWillAppear:NO];
  [self updateSelectedViewFrame];
}

//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//{
//  UIViewController *newSelectedViewController = [viewControllers objectAtIndex:item.tag];
//  
//  [self.selectedViewController setEditing:NO animated:YES];
//  [self.selectedViewController viewWillDisappear:NO];
//  [self.selectedViewController.view removeFromSuperview];
//  
//  [self.view addSubview:newSelectedViewController.view];
//  self.selectedViewController = newSelectedViewController;
//  [self.selectedViewController viewWillAppear:NO];
//  [self updateSelectedViewFrame];
//}


@end
