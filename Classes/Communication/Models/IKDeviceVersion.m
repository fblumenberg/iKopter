// ///////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2010-2011, Frank Blumenberg
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


#import "IKDeviceVersion.h"

static const NSString * HardwareType[] = { @"Default", @"FlightCtrl", @"NaviCtrl", @"MK3Mag" };


@implementation IKDeviceVersion

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@synthesize address;
@synthesize versionString;
@synthesize versionStringShort;

- (BOOL)hasError {
  return (_version.HardwareError[0]>0||_version.HardwareError[1]>0);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ (id)versionWithData:(NSData *)data forAddress:(IKMkAddress) theAddress {
  return [[[IKDeviceVersion alloc] initWithData:data forAddress: theAddress] autorelease];
}

- (id)initWithData:(NSData*)data forAddress:(IKMkAddress) theAddress {
  self = [super init];
  if (self != nil) {
    
    address = theAddress;
    
    memcpy(&_version,[data bytes],sizeof(_version));
    
    versionString = [[NSString stringWithFormat:@"%@ %d.%d %c", 
                             HardwareType[address], 
                             _version.SWMajor, 
                             _version.SWMinor, 
                             (_version.SWPatch + 'a')] retain];
    
    
    versionStringShort = [[NSString stringWithFormat:@"%d.%d%c", 
                              _version.SWMajor, 
                              _version.SWMinor, 
                              (_version.SWPatch + 'a')] retain];
    
  }
  return self;
}

- (void)dealloc
{
	[versionString release];
	[versionStringShort release];
	[super dealloc];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*) errorDescriptions{
  NSMutableArray* a = [NSMutableArray arrayWithCapacity:0];

  if(address==MKAddressFC){
    if((_version.HardwareError[0]&FC_ERROR0_GYRO_NICK)==FC_ERROR0_GYRO_NICK){
      [a addObject:NSLocalizedString(@"Hardware: Gyro NICK error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_GYRO_ROLL)==FC_ERROR0_GYRO_ROLL){
      [a addObject:NSLocalizedString(@"Hardware: Gyro ROLL error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_GYRO_YAW)==FC_ERROR0_GYRO_YAW){
      [a addObject:NSLocalizedString(@"Hardware: Gyro YAW error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_ACC_NICK)==FC_ERROR0_ACC_NICK){
      [a addObject:NSLocalizedString(@"Hardware: Acc NICK error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_ACC_ROLL)==FC_ERROR0_ACC_ROLL){
      [a addObject:NSLocalizedString(@"Hardware: Acc ROLL error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_ACC_TOP)==FC_ERROR0_ACC_TOP){
      [a addObject:NSLocalizedString(@"Hardware: Acc Z error (FlightCtrl installed upside down ?)",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_PRESSURE)==FC_ERROR0_PRESSURE){
      [a addObject:NSLocalizedString(@"Hardware: Pressure sensor error",@"")];
    }
    if((_version.HardwareError[0]&FC_ERROR0_CAREFREE)==FC_ERROR0_CAREFREE){
      [a addObject:NSLocalizedString(@"Carefree control error/not possible (compass okay?, Orientation = 0 ?)",@"")];
    }
    if((_version.HardwareError[1]&FC_ERROR1_I2C)==FC_ERROR1_I2C){
      [a addObject:NSLocalizedString(@"I2C bus error (check I2C connections)",@"")];
    }
    if((_version.HardwareError[1]&FC_ERROR1_BL_MISSING)==FC_ERROR1_BL_MISSING){
      [a addObject:NSLocalizedString(@"BL-Ctrl missing (check connections & mixer setup)",@"")];
    }
    if((_version.HardwareError[1]&FC_ERROR1_SPI_RX)==FC_ERROR1_SPI_RX){
      [a addObject:NSLocalizedString(@"SPI communication error. No data from Navi-Ctrl",@"")];
    }
    if((_version.HardwareError[1]&FC_ERROR1_PPM)==FC_ERROR1_PPM){
      [a addObject:NSLocalizedString(@"No receiver signal",@"")];
    }
    if((_version.HardwareError[1]&FC_ERROR1_MIXER)==FC_ERROR1_MIXER){
      [a addObject:NSLocalizedString(@"Mixer setup error (check mixervalues)",@"")];
    }
  }
  else if(address==MKAddressNC){
    if((_version.HardwareError[0]&NC_ERROR0_SPI_RX)==NC_ERROR0_SPI_RX){
      [a addObject:NSLocalizedString(@"SPI: no data from Flight-Ctrl",@"")];
    }
    if((_version.HardwareError[0]&NC_ERROR0_COMPASS_RX)==NC_ERROR0_COMPASS_RX){
      [a addObject:NSLocalizedString(@"no data from MK3Mag",@"")];
    }
    if((_version.HardwareError[0]&NC_ERROR0_GPS_RX)==NC_ERROR0_GPS_RX){
      [a addObject:NSLocalizedString(@"Flight-Ctrl software incompatible",@"")];
    }
    if((_version.HardwareError[0]&NC_ERROR0_GPS_RX)==NC_ERROR0_GPS_RX){
      [a addObject:NSLocalizedString(@"MK3Mag software incompatible",@"")];
    }
    if((_version.HardwareError[0]&NC_ERROR0_GPS_RX)==NC_ERROR0_GPS_RX){
      [a addObject:NSLocalizedString(@"no data from MKGPS",@"")];
    }
    if((_version.HardwareError[0]&NC_ERROR0_COMPASS_VALUE)==NC_ERROR0_COMPASS_VALUE){
      [a addObject:NSLocalizedString(@"invalid compass value (MK3Mag not calibrated ?)",@"")];
    }
  }

  return a;
}

@end
