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

#import "NSData+MKPayloadDecode.h"
#import "MKDataConstants.h"

#import "IKParamSet.h"
#import "IKLcdDisplay.h"

static const NSString * HardwareType[] = { @"Default", @"FlightCtrl", @"NaviCtrl", @"MK3Mag" };

@implementation NSData (MKPayloadDecode)

//-------------------------------------------------------------------------------------------
- (NSString *) debugLabelWithIndex:(int *)theIndex {
  const char * bytes = [self bytes];
  
  *theIndex = (int)bytes[0];
  
  int dataLength = [self length] < 16 ? [self length] : 16;
  
  NSData * strData = [NSData dataWithBytesNoCopy:(void*)(++bytes) length:dataLength freeWhenDone:NO];
  NSString * label = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
  
  return [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSDictionary *) decodeAnalogLabelResponseForAddress:(MKAddress)address;
{
  int index;
  NSString * label = [self debugLabelWithIndex:&index];
  
  return [NSDictionary dictionaryWithObjectsAndKeys:label, kMKDataKeyLabel, [NSNumber numberWithInt:index], kMKDataKeyIndex, nil];
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeDebugDataResponseForAddress:(MKAddress)address;
{
  DebugOut * debugData = (DebugOut *)[self bytes];
  
  NSNumber* theAddress=[NSNumber numberWithInt:address];
  
  NSMutableArray * targetArray = [[NSMutableArray alloc] initWithCapacity:32];
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  for (int i = 0; i < 32; i++) 
  {
    NSNumber *number = [NSNumber numberWithShort:debugData->Analog[i]];
    [targetArray addObject:number];
  }
  
  [pool drain];
  
  NSDictionary* responseDictionary=[NSDictionary dictionaryWithObjectsAndKeys:targetArray, kMKDataKeyDebugData, 
                                    theAddress, kMKDataKeyAddress, nil];
  
  [targetArray release];
  
  return responseDictionary;
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeLcdMenuResponseForAddress:(MKAddress)address;
{
  const char * bytes = [self bytes];
  
  NSNumber* theAddress=[NSNumber numberWithInt:address];
  NSNumber * menuItem = [NSNumber numberWithChar:bytes[0]];
  NSNumber * maxMenuItem = [NSNumber numberWithChar:bytes[1]];
  
  NSData * strData = [NSData dataWithBytesNoCopy:(char *)(bytes + 2) length:[self length] - 2 freeWhenDone:NO];
  NSString * label = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
  
  NSMutableArray * menuRows = [[NSMutableArray alloc] init];
  
  [menuRows addObject:[label substringWithRange:NSMakeRange(0, 20)]];
  [menuRows addObject:[label substringWithRange:NSMakeRange(20, 20)]];
  [menuRows addObject:[label substringWithRange:NSMakeRange(40, 20)]];
  [menuRows addObject:[label substringWithRange:NSMakeRange(60, 20)]];
  
  NSDictionary* d =[NSDictionary dictionaryWithObjectsAndKeys:menuItem, kMKDataKeyMenuItem, 
                    maxMenuItem, kMKDataKeyMaxMenuItem, 
                    menuRows, kMKDataKeyMenuRows, theAddress, kMKDataKeyAddress, nil];

  [menuRows autorelease];
  
  return d;
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeLcdResponseForAddress:(MKAddress)address;
{
  IKLcdDisplay* lcdData=[IKLcdDisplay menuWithData:self forAddress:address];
  NSDictionary* d=[NSDictionary dictionaryWithObjectsAndKeys:lcdData, kIKLcdDisplay, nil];
  
  return d; 
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeVersionResponseForAddress:(MKAddress)address;
{
  const VersionInfo * version = [self bytes];
  NSNumber* theAddress=[NSNumber numberWithInt:address];
  
  NSString * versionStr = [NSString stringWithFormat:@"%@ %d.%d %c", 
                           HardwareType[address], 
                           version->SWMajor, 
                           version->SWMinor, 
                           (version->SWPatch + 'a')];
  
  NSString * versionStrShort = [NSString stringWithFormat:@"%d.%d%c", 
                                version->SWMajor, 
                                version->SWMinor, 
                                (version->SWPatch + 'a')];
  
  return [NSDictionary dictionaryWithObjectsAndKeys:versionStr, kMKDataKeyVersion, 
          versionStrShort, kMKDataKeyVersionShort, theAddress, kMKDataKeyAddress, nil];
}

- (NSDictionary *) decodeChannelsDataResponse {

  return [NSDictionary dictionaryWithObjectsAndKeys:self, kMKDataKeyChannels, nil];

}


- (NSDictionary *) decodeOsdResponse {
//  NSValue* value = [NSValue valueWithBytes:[self bytes] 
//                                  objCType:@encode(NaviData_t)];

  return [NSDictionary dictionaryWithObjectsAndKeys:self, kMKDataKeyRawValue, nil];
}

@end

/////////////////////////////////////////////////////////////////////////////////
#pragma mark -
/////////////////////////////////////////////////////////////////////////////////

@implementation NSData (MKPayloadDecodeSetting)

- (NSDictionary *) decodeReadSettingResponse {
  IKParamSet* paramSet=[IKParamSet settingWithData:self];
  return [NSDictionary dictionaryWithObjectsAndKeys:paramSet, kIKParamSet, nil];
}

- (NSDictionary *) decodeWriteSettingResponse {
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex, nil];
}

- (NSDictionary *) decodeChangeSettingResponse {
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex, nil];
}

@end

