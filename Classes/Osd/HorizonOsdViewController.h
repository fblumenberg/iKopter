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


#import <UIKit/UIKit.h>
#import "IKAttitudeIndicator.h"
#import "OsdValue.h"

@interface HorizonOsdViewController : UIViewController<OsdValueDelegate> {

  UITextView* osdText;
  IKAttitudeIndicator* indicator;
  
  UILabel* heigth;
  UILabel* heigthSetpoint;
  UILabel* battery;
  UILabel* current;
  UILabel* usedCapacity;
  UILabel* satelites;
  UILabel* gpsMode;
  UILabel* gpsTarget;
  UILabel* flightTime;
}

@property(retain) IBOutlet IKAttitudeIndicator* indicator;
@property(retain) IBOutlet UITextView* osdText;

@property(retain) IBOutlet UILabel* heigth;
@property(retain) IBOutlet UILabel* heigthSetpoint;
@property(retain) IBOutlet UILabel* battery;
@property(retain) IBOutlet UILabel* current;
@property(retain) IBOutlet UILabel* usedCapacity;
@property(retain) IBOutlet UILabel* satelites;
@property(retain) IBOutlet UILabel* gpsMode;
@property(retain) IBOutlet UILabel* gpsTarget;
@property(retain) IBOutlet UILabel* flightTime;

@end
