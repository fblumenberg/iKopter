// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2011, Frank Blumenberg
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

#import "RawOsdViewController.h"


@implementation RawOsdViewController

@synthesize osdText;
  
- (void)dealloc {
  self.osdText = nil;
  [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return YES;
}

- (void)newValue:(OsdValue *)value {

  NSMutableString *info = [NSMutableString stringWithString:@""];

  [info appendFormat:@"SatsInUse: %d\r\n", value.data.data->SatsInUse];
  [info appendFormat:@"Altimeter: %d\r\n", value.data.data->Altimeter];
  [info appendFormat:@"Variometer: %d\r\n", value.data.data->Variometer];
  [info appendFormat:@"FlyingTime: %d\r\n", value.data.data->FlyingTime];
  [info appendFormat:@"UBat: %d\r\n", value.data.data->UBat];
  [info appendFormat:@"GroundSpeed: %d\r\n", value.data.data->GroundSpeed];
  [info appendFormat:@"Heading: %d\r\n", value.data.data->Heading];
  [info appendFormat:@"CompassHeading: %d\r\n", value.data.data->CompassHeading];
  [info appendFormat:@"AngleNick: %d\r\n", value.data.data->AngleNick];
  [info appendFormat:@"AngleRoll: %d\r\n", value.data.data->AngleRoll];
  [info appendFormat:@"RC_Quality: %d\r\n", value.data.data->RC_Quality];
  [info appendFormat:@"FC_ST_MOTOR_RUN        : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_MOTOR_RUN];
  [info appendFormat:@"FC_ST_FLY              : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_FLY];
  [info appendFormat:@"FC_ST_CALIBRATE        : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_CALIBRATE];
  [info appendFormat:@"FC_ST_START            : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_START];
  [info appendFormat:@"FC_ST_EMERGENCY_LANDING: %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_EMERGENCY_LANDING];
  [info appendFormat:@"FC_ST_LOWBAT           : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_LOWBAT];
  [info appendFormat:@"FC_ST_VARIO_TRIM_UP    : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_VARIO_TRIM_UP];
  [info appendFormat:@"FC_ST_VARIO_TRIM_DOWN  : %d\r\n", value.data.data->FCStatusFlags & FC_STATUS_VARIO_TRIM_DOWN];
  [info appendFormat:@"FCStatusFlags: %d\r\n", value.data.data->FCStatusFlags];
  [info appendFormat:@"NC_F_FREE          : %d\r\n", value.data.data->NCFlags & NC_FLAG_FREE];
  [info appendFormat:@"NC_F_PH            : %d\r\n", value.data.data->NCFlags & NC_FLAG_PH];
  [info appendFormat:@"NC_F_CH            : %d\r\n", value.data.data->NCFlags & NC_FLAG_CH];
  [info appendFormat:@"NC_F_RANGE_LIMIT   : %d\r\n", value.data.data->NCFlags & NC_FLAG_RANGE_LIMIT];
  [info appendFormat:@"NC_F_NOSERIALLINK  : %d\r\n", value.data.data->NCFlags & NC_FLAG_NOSERIALLINK];
  [info appendFormat:@"NC_F_TARGET_REACHED: %d\r\n", value.data.data->NCFlags & NC_FLAG_TARGET_REACHED];
  [info appendFormat:@"NC_F_MANUAL_CONTROL: %d\r\n", value.data.data->NCFlags & NC_FLAG_MANUAL_CONTROL];
  [info appendFormat:@"NC_F_GPS_OK        : %d\r\n", value.data.data->NCFlags & NC_FLAG_GPS_OK];
  [info appendFormat:@"NCFlags: %d\r\n", value.data.data->NCFlags];
  [info appendFormat:@"Errorcode: %d\r\n", value.data.data->Errorcode];
  [info appendFormat:@"TopSpeed: %d\r\n", value.data.data->TopSpeed];
  [info appendFormat:@"TargetHoldTime: %d\r\n", value.data.data->TargetHoldTime];
  [info appendFormat:@"SetpointAltitude: %d\r\n", value.data.data->SetpointAltitude];
  [info appendFormat:@"Gas: %d\r\n", value.data.data->Gas];


  if (value.data.data->Version == 5)
    [info appendFormat:@"FCStatusFlags2: %d\r\n", value.data.data->FCStatusFlags2];
  else
    [info appendFormat:@"RC_RSSI: %d\r\n", value.data.data->FCStatusFlags2];
  [info appendFormat:@"Current: %d\r\n", value.data.data->Current];
  [info appendFormat:@"UsedCapacity: %d\r\n", value.data.data->UsedCapacity];

  osdText.text = info;
}


@end
