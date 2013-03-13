//
//  BaseTest.m
//  InnerBand
//
//  InnerBand - The iOS Booster!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
#import <UIKit/UIKit.h>

#import "GHUnit.h"
#import "InnerBand.h"

#import "IKMkDataTypes.h"
#import "IKDebugData.h"

#import "MKDataConstants.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "NSData+MKPayloadEncode.h"

@interface MKCommandDebugDataTest : GHTestCase
@end

@implementation MKCommandDebugDataTest

- (void)setUpClass {
  // Run at start of all tests in the class
}

- (void)tearDownClass {
  // Run at end of all tests in the class
}

- (void)setUp {
  // Run before each test method
}

- (void)tearDown {
  // Run after each test method
}   

- (void)testDecodingDebugData {
  
  IKMkDebugOut mkData;
  
  mkData.Digital[0]=YES;
  mkData.Digital[1]=YES;
  
  for(int i=0;i<32;i++)
    mkData.Analog[i] = i;

  NSData *data = [NSData dataWithCommand:MKCommandDebugValueResponse 
                              forAddress:kIKMkAddressFC 
                        payloadWithBytes:&mkData 
                                  length:sizeof(mkData)];

  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* payload = [data payload];

  IKDebugData* d= [IKDebugData dataWithData:payload forAddress:[data address]];
  GHAssertNotNil(d,nil);

  GHAssertEquals((BOOL)mkData.Digital[0], [d digitalValueAtIndex:0],nil);
  GHAssertEquals((BOOL)mkData.Digital[1], [d digitalValueAtIndex:1],nil);
  
  mkData.Digital[0]=YES;
  mkData.Digital[1]=YES;
  
  for(int i=0;i<32;i++)
    GHAssertEquals((NSInteger)mkData.Analog[i], [d analogValueAtIndex:i].integerValue,nil);
}

- (void)testDecodingDebugDataDictionary {
  
  IKMkDebugOut mkData;
  
  mkData.Digital[0]=YES;
  mkData.Digital[1]=YES;
  
  for(int i=0;i<32;i++)
    mkData.Analog[i] = i;
  
  NSData *data = [NSData dataWithCommand:MKCommandDebugValueResponse 
                              forAddress:kIKMkAddressFC 
                        payloadWithBytes:&mkData 
                                  length:sizeof(mkData)];
  
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* payload = [data payload];
  
  NSDictionary* di = [payload decodeDebugDataResponseForAddress:[data address]];
  GHAssertGreaterThan([di count],0U,nil);
  
  IKDebugData* d=[di objectForKey:kIKDataKeyDebugData];
  GHAssertNotNil(d,nil);
  
  GHAssertEquals((BOOL)mkData.Digital[0], [d digitalValueAtIndex:0],nil);
  GHAssertEquals((BOOL)mkData.Digital[1], [d digitalValueAtIndex:1],nil);
  
  mkData.Digital[0]=YES;
  mkData.Digital[1]=YES;
  
  for(int i=0;i<32;i++)
    GHAssertEquals((NSInteger)mkData.Analog[i], [d analogValueAtIndex:i].integerValue,nil);

}


@end
