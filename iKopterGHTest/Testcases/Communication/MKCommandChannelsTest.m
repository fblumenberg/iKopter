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
#import "IKLcdDisplay.h"

#import "MKDataConstants.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"
#import "NSData+MKPayloadDecode.h"
#import "NSData+MKPayloadEncode.h"

@interface MKCommandChannelsTest : GHTestCase
@end

@implementation MKCommandChannelsTest

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

- (void)testDecodingChannels {
  
  int16_t channelValues[26];
  
  for(int i=0;i<26;i++)
    channelValues[i] = i;

  NSData *data = [NSData dataWithCommand:MKCommandChannelsValueResponse 
                              forAddress:kIKMkAddressFC 
                        payloadWithBytes:channelValues 
                                  length:sizeof(channelValues)];
  
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);

  NSData* payload = [data payload];
  
  int16_t channelValues2[26];
  
  GHAssertGreaterThanOrEqual([payload length], (NSUInteger)sizeof(channelValues2),nil);
  memcpy(channelValues2, [payload bytes], sizeof(channelValues2));

  for(int i=0;i<26;i++)
    GHAssertEquals(channelValues[i], channelValues2[i],nil);
}

- (void)testDecodingChannelsDictionary {

  int16_t channelValues[26];
  
  for(int i=0;i<26;i++)
    channelValues[i] = i;
  
  NSData *data = [NSData dataWithCommand:MKCommandChannelsValueResponse 
                              forAddress:kIKMkAddressFC 
                        payloadWithBytes:channelValues 
                                  length:sizeof(channelValues)];
  
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* payload = [data payload];

  NSDictionary* d = [payload decodeChannelsDataResponse];
  
  GHAssertGreaterThan([d count],0U,nil);

  NSData *payload2 = [d objectForKey:kMKDataKeyChannels];
  
  GHAssertNotNil(payload2,nil);
  int16_t channelValues2[26];
  
  GHAssertGreaterThanOrEqual([payload2 length], (NSUInteger)sizeof(channelValues2),nil);
  memcpy(channelValues2, [payload2 bytes], sizeof(channelValues2));
  
  for(int i=0;i<26;i++)
    GHAssertEquals(channelValues[i], channelValues2[i],nil);
}


@end
