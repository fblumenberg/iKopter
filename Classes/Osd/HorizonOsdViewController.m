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

#import "HorizonOsdViewController.h"

@implementation HorizonOsdViewController

@synthesize indicator;
@synthesize osdText;

@synthesize heigth;
@synthesize heigthSetpoint;
@synthesize battery;
@synthesize current;
@synthesize usedCapacity;
@synthesize satelites;
@synthesize gpsMode;
@synthesize gpsTarget;
@synthesize flightTime;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (void) viewWillAppear:(BOOL)animated {
  
  [self.navigationController setToolbarHidden:YES animated:NO];

  osdValue = [[OsdValue alloc] init];
  osdValue.delegate = self;
}

- (void) viewWillDisappear:(BOOL)animated {
  [osdValue release];
}  


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
  if ( UIInterfaceOrientationIsPortrait(orientation) ){
    [[NSBundle mainBundle] loadNibNamed:@"HorizonOsdViewController" owner:self options:nil];
  }
  else if (UIInterfaceOrientationIsLandscape(orientation)){
    [[NSBundle mainBundle] loadNibNamed:@"HorizonOsdViewControllerLandscape" owner:self options:nil];
  }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (void) newValue:(IKNaviData*)data {
  
  
  heigth.text=[NSString stringWithFormat:@"%0.1f m",data.data->Altimeter/10.0];  
  heigthSetpoint.text=[NSString stringWithFormat:@"%0.1f m",data.data->SetpointAltitude/10.0];  
  battery.text=[NSString stringWithFormat:@"%0.1f V",data.data->UBat/10.0];    
  current.text=[NSString stringWithFormat:@"%0.1f A",data.data->Current/10.0];      
  usedCapacity.text=[NSString stringWithFormat:@"%d mAh",data.data->UsedCapacity];  
  
  satelites.text=[NSString stringWithFormat:@"%d Sat.",data.data->SatsInUse];  
  satelites.textColor = osdValue.isGpsOk?[UIColor darkTextColor]:[UIColor redColor];
  
  if(osdValue.isFreeModeEnabled)
    gpsMode.text=@"FREE";    
  else if(osdValue.isPositionHoldEnabled)
    gpsMode.text=@"PH";    
  else if(osdValue.isComingHomeEnabled)
    gpsMode.text=@"CH";    
  else
    gpsMode.text=@"??";    
  
  if(osdValue.isTargetReached)
    gpsTarget.text=@"TARGET";
  else
    gpsTarget.text=@"";
  
  NSMutableString* info=[NSMutableString stringWithString:@"INFO\r\n"];
  
  [info appendFormat:@"SatsInUse: %d\r\n",data.data->SatsInUse];
  [info appendFormat:@"Altimeter: %d\r\n",data.data->Altimeter];
  [info appendFormat:@"Variometer: %d\r\n",data.data->Variometer];
  [info appendFormat:@"FlyingTime: %d\r\n",data.data->FlyingTime];
  [info appendFormat:@"UBat: %d\r\n",data.data->UBat];
  [info appendFormat:@"GroundSpeed: %d\r\n",data.data->GroundSpeed];
  [info appendFormat:@"Heading: %d\r\n",data.data->Heading];
  [info appendFormat:@"CompassHeading: %d\r\n",data.data->CompassHeading];
  [info appendFormat:@"AngleNick: %d\r\n",data.data->AngleNick];
  [info appendFormat:@"AngleRoll: %d\r\n",data.data->AngleRoll];
  [info appendFormat:@"RC_Quality: %d\r\n",data.data->RC_Quality];
  [info appendFormat:@"FC_ST_MOTOR_RUN        : %d\r\n",data.data->FCStatusFlags&FC_STATUS_MOTOR_RUN        ];
  [info appendFormat:@"FC_ST_FLY              : %d\r\n",data.data->FCStatusFlags&FC_STATUS_FLY              ];
  [info appendFormat:@"FC_ST_CALIBRATE        : %d\r\n",data.data->FCStatusFlags&FC_STATUS_CALIBRATE        ];
  [info appendFormat:@"FC_ST_START            : %d\r\n",data.data->FCStatusFlags&FC_STATUS_START            ];
  [info appendFormat:@"FC_ST_EMERGENCY_LANDING: %d\r\n",data.data->FCStatusFlags&FC_STATUS_EMERGENCY_LANDING];
  [info appendFormat:@"FC_ST_LOWBAT           : %d\r\n",data.data->FCStatusFlags&FC_STATUS_LOWBAT           ];
  [info appendFormat:@"FC_ST_VARIO_TRIM_UP    : %d\r\n",data.data->FCStatusFlags&FC_STATUS_VARIO_TRIM_UP    ];
  [info appendFormat:@"FC_ST_VARIO_TRIM_DOWN  : %d\r\n",data.data->FCStatusFlags&FC_STATUS_VARIO_TRIM_DOWN  ];
  [info appendFormat:@"FCFlags: %d\r\n",data.data->FCStatusFlags];
  [info appendFormat:@"NC_F_FREE          : %d\r\n",data.data->NCFlags&NC_FLAG_FREE          ];
  [info appendFormat:@"NC_F_PH            : %d\r\n",data.data->NCFlags&NC_FLAG_PH            ];
  [info appendFormat:@"NC_F_CH            : %d\r\n",data.data->NCFlags&NC_FLAG_CH            ];
  [info appendFormat:@"NC_F_RANGE_LIMIT   : %d\r\n",data.data->NCFlags&NC_FLAG_RANGE_LIMIT   ];
  [info appendFormat:@"NC_F_NOSERIALLINK  : %d\r\n",data.data->NCFlags&NC_FLAG_NOSERIALLINK  ];
  [info appendFormat:@"NC_F_TARGET_REACHED: %d\r\n",data.data->NCFlags&NC_FLAG_TARGET_REACHED];
  [info appendFormat:@"NC_F_MANUAL_CONTROL: %d\r\n",data.data->NCFlags&NC_FLAG_MANUAL_CONTROL];
  [info appendFormat:@"NC_F_GPS_OK        : %d\r\n",data.data->NCFlags&NC_FLAG_GPS_OK        ];
  [info appendFormat:@": %d\r\n",data.data->NCFlags];
  [info appendFormat:@"Errorcode: %d\r\n",data.data->Errorcode];
  [info appendFormat:@"TopSpeed: %d\r\n",data.data->TopSpeed];
  [info appendFormat:@"TargetHoldTime: %d\r\n",data.data->TargetHoldTime];
  [info appendFormat:@"SetpointAltitude: %d\r\n",data.data->SetpointAltitude];
  [info appendFormat:@"Gas: %d\r\n",data.data->Gas];
  
  
  [info appendFormat:@"RC_RSSI: %d\r\n",data.data->RC_RSSI];
  [info appendFormat:@"Current: %d\r\n",data.data->Current];
  [info appendFormat:@"UsedCapacity: %d\r\n",data.data->UsedCapacity];
  
  osdText.text=info;
  
  self.indicator.pitch=-1*(data.data->AngleNick);
  self.indicator.roll=-1*(data.data->AngleRoll);
}

@end
