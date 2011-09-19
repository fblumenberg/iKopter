//
//  DetailViewController.m
//  MGSplitView
//
//  Created by Matt Gemmell on 26/07/2010.
//  Copyright Instinctive Code 2010.
//

#import "DetailViewController.h"
#import "RootViewController.h"


@implementation DetailViewController

-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  self.navigationController.delegate = self;
  
  self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
}

- (void)navigationController:(UINavigationController *)navigationController 
      willShowViewController:(UIViewController *)viewController 
                    animated:(BOOL)animated
{

  if( self==viewController ){
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
  }
    
}

#pragma mark -
#pragma mark Rotation support


// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
