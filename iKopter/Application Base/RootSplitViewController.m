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


#import "RootSplitViewController.h"
#import "RootViewController.h"

@implementation RootSplitViewController

@synthesize left, right;

- (void)dealloc {
  self.left = nil;
  self.right = nil;
  
  [super dealloc];
}


- (UIColor *) randomColor {
  CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
  CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
  CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  
  return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (UIViewController*) randomViewController1 {
  UIViewController *viewController = [[UIViewController alloc] init];
  viewController.view.backgroundColor = [self randomColor];    
  
  return [viewController autorelease];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.title = @"Master";
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  
  self.left = [self randomViewController1];
  
  RootViewController* root=[[[RootViewController alloc]initWithNibName:@"RootViewController" bundle:nil]autorelease];

  self.right = root;
  
  [self pushToMasterController:self.left];
  [self pushToDetailController:self.right];
  
  self.left.title = @"Left root";
//  self.right.title = @"Right root";
}

- (void)viewDidUnload {
  [super viewDidUnload];
  
  self.left = nil;
  self.right = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
