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
#import "IKDebugData.h"
#import "IKDebugLabel.h"
#import "IKDeviceVersion.h"
#import "IKData3D.h"
#import "IKNaviData.h"
#import "IKPoint.h"

@implementation NSData (MKPayloadDecode)

//-------------------------------------------------------------------------------------------
//- (NSString *) debugLabelWithIndex:(int *)theIndex {
//  const char * bytes = [self bytes];
//  
//  *theIndex = (int)bytes[0];
//  
//  int dataLength = [self length] < 16 ? [self length] : 16;
//  
//  NSData * strData = [NSData dataWithBytesNoCopy:(void*)(++bytes) length:dataLength freeWhenDone:NO];
//  NSString * label = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
//  
//  return [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//}

- (NSDictionary *) decodeAnalogLabelResponseForAddress:(IKMkAddress)address;
{
  IKDebugLabel* label = [IKDebugLabel labelWithData:self forAddress:address];
  return [NSDictionary dictionaryWithObjectsAndKeys:label, kIKDataKeyDebugLabel, nil];
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeDebugDataResponseForAddress:(IKMkAddress)address;
{
  IKDebugData* debugData = [IKDebugData dataWithData:self forAddress:address];
  return [NSDictionary dictionaryWithObjectsAndKeys:debugData,kIKDataKeyDebugData, nil];
}

//-------------------------------------------------------------------------------------------
//- (NSDictionary *) decodeLcdMenuResponseForAddress:(IKMkAddress)address;
//{
//  const char * bytes = [self bytes];
//  
//  NSNumber* theAddress=[NSNumber numberWithInt:address];
//  NSNumber * menuItem = [NSNumber numberWithChar:bytes[0]];
//  NSNumber * maxMenuItem = [NSNumber numberWithChar:bytes[1]];
//  
//  NSData * strData = [NSData dataWithBytesNoCopy:(char *)(bytes + 2) length:[self length] - 2 freeWhenDone:NO];
//  NSString * label = [[[NSString alloc] initWithData:strData encoding:NSASCIIStringEncoding] autorelease];
//  
//  NSMutableArray * menuRows = [[NSMutableArray alloc] init];
//  
//  [menuRows addObject:[label substringWithRange:NSMakeRange(0, 20)]];
//  [menuRows addObject:[label substringWithRange:NSMakeRange(20, 20)]];
//  [menuRows addObject:[label substringWithRange:NSMakeRange(40, 20)]];
//  [menuRows addObject:[label substringWithRange:NSMakeRange(60, 20)]];
//  
//  NSDictionary* d =[NSDictionary dictionaryWithObjectsAndKeys:menuItem, kMKDataKeyMenuItem, 
//                    maxMenuItem, kMKDataKeyMaxMenuItem, 
//                    menuRows, kMKDataKeyMenuRows, theAddress, kMKDataKeyAddress, nil];
//
//  [menuRows autorelease];
//  
//  return d;
//}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeLcdResponseForAddress:(IKMkAddress)address;
{
  IKLcdDisplay* lcdData=[IKLcdDisplay menuWithData:self forAddress:address];
  NSDictionary* d=[NSDictionary dictionaryWithObjectsAndKeys:lcdData, kIKDataKeyLcdDisplay, nil];
  
  return d; 
}

//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeVersionResponseForAddress:(IKMkAddress)address;
{
  IKDeviceVersion* dv=[IKDeviceVersion versionWithData:self forAddress:(IKMkAddress)address];
  return [NSDictionary dictionaryWithObjectsAndKeys:dv, kIKDataKeyVersion, nil];
}

- (NSDictionary *) decodeChannelsDataResponse {

  return [NSDictionary dictionaryWithObjectsAndKeys:self, kMKDataKeyChannels, nil];
}


//-------------------------------------------------------------------------------------------
- (NSDictionary *) decodeData3DResponse;
{
  IKData3D* data3D=[IKData3D dataWithData:self];
  NSDictionary* d=[NSDictionary dictionaryWithObjectsAndKeys:data3D, kIKDataKeyData3D, nil];
  
  return d; 
}

//-------------------------------------------------------------------------------------------

- (NSDictionary *) decodeOsdResponse {
  IKNaviData* data3D=[IKNaviData dataWithData:self];
  NSDictionary* d=[NSDictionary dictionaryWithObjectsAndKeys:data3D, kIKDataKeyOsd, nil];
  
  return d; 
}

- (NSDictionary *) decodeMixerReadResponse {
  return [NSDictionary dictionary];
}

- (NSDictionary *) decodeMixerWriteResponse {
  return [NSDictionary dictionary];
}

- (NSDictionary *) decodePointReadResponse {
  const char * bytes = [self bytes];

  NSNumber * totalNumber = [NSNumber numberWithChar:bytes[0]];
  
  if ([self length]>1) {
    NSNumber * theIndex = [NSNumber numberWithChar:bytes[1]];
    IKPoint* thePoint = [IKPoint pointWithData:self];
    return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex,
            totalNumber,kMKDataKeyMaxItem,thePoint,kIKDataKeyPoint,nil];
  }

  return [NSDictionary dictionaryWithObjectsAndKeys:totalNumber,kMKDataKeyMaxItem,nil];
}

- (NSDictionary *) decodePointWriteResponse {
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex, nil];
}


- (NSDictionary *) decodeMotorDataResponse{
  const char * bytes = [self bytes];
  NSNumber * theIndex = [NSNumber numberWithChar:bytes[0]];

  IKMotorData* thePoint = [IKMotorData dataWithData:self];
  return [NSDictionary dictionaryWithObjectsAndKeys:theIndex, kMKDataKeyIndex,
            thePoint,kIKDataKeyMotorData,nil];
}


@end

/////////////////////////////////////////////////////////////////////////////////
#pragma mark -
/////////////////////////////////////////////////////////////////////////////////

@implementation NSData (MKPayloadDecodeSetting)

- (NSDictionary *) decodeReadSettingResponse {
  IKParamSet* paramSet=[IKParamSet settingWithData:self];
  return [NSDictionary dictionaryWithObjectsAndKeys:paramSet, kIKDataKeyParamSet, nil];
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

