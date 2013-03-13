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
#import "NSData+MKCommandDecode.h"
#import "NSData+MKCommandEncode.h"

@interface MKCommandTest : GHTestCase
@end

@implementation MKCommandTest

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

- (void)testDecodingAndEncoding {
  
  NSData *payload = [@"TEST" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(payload,nil);

  NSData *data = [payload dataWithCommand:MKCommandLcdResponse forAddress:kIKMkAddressFC];
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* data2 = [data copy];
  GHAssertEqualObjects(data, data2, nil);

  GHAssertEquals([data2 command], MKCommandLcdResponse, nil);
  GHAssertEquals([data2 address], kIKMkAddressFC, nil);
  
  NSData* payload2 = [data2 payload] ;
  
  NSRange r = [payload2 rangeOfData:payload options:0 range:NSMakeRange(0, [payload2 length])];
  GHAssertTrue(NSEqualRanges(r,NSMakeRange(0, [payload length])),nil);
}

- (void)testDecodingAndEncodingPointer {
  
  NSData *payload = [@"TEST" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(payload,nil);
  
  NSData *data = [NSData dataWithCommand:MKCommandLcdResponse 
                              forAddress:kIKMkAddressFC 
                        payloadWithBytes:[payload bytes] 
                                  length:[payload length]];
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* data2 = [data copy];
  GHAssertEqualObjects(data, data2, nil);
  
  GHAssertEquals([data2 command], MKCommandLcdResponse, nil);
  GHAssertEquals([data2 address], kIKMkAddressFC, nil);
  
  NSData* payload2 = [data2 payload] ;
  
  NSRange r = [payload2 rangeOfData:payload options:0 range:NSMakeRange(0, [payload2 length])];
  GHAssertTrue(NSEqualRanges(r,NSMakeRange(0, [payload length])),nil);
}


- (void)testDecodingAndEncodingOneByte {
  
  NSData *payload = [@"TEST" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(payload,nil);
  
  NSData *data = [NSData dataWithCommand:MKCommandLcdResponse forAddress:kIKMkAddressFC payloadForByte:0xAF];
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);
  
  NSData* data2 = [data copy];
  GHAssertEqualObjects(data, data2, nil);
  
  GHAssertEquals([data2 command], MKCommandLcdResponse, nil);
  GHAssertEquals([data2 address], kIKMkAddressFC, nil);
  
  NSData* payload2 = [data2 payload];
  const char * payloadBytes = [payload2 bytes];
  
  GHAssertEquals((char)0xAF, payloadBytes[0], nil);
}

- (void)testDecodingVersionRequest{
  NSData* data=[@"#av@w" dataUsingEncoding:NSASCIIStringEncoding];

  GHAssertEquals([data command], MKCommandVersionRequest, nil);
  GHAssertEquals([data address], kIKMkAddressAll, nil);
}

- (void)testDecodingVersionResponse{
  NSData* data=[@"#cV=>]H==A=========PY" dataUsingEncoding:NSASCIIStringEncoding];
  
  GHAssertEquals([data command], MKCommandVersionResponse, nil);
  GHAssertEquals([data address], kIKMkAddressNC, nil);
}

- (void)testDecodingVersionResponseInvCrc{
  NSData* data=[@"#cV=>]H==Ac========PY" dataUsingEncoding:NSASCIIStringEncoding];
  
  GHAssertFalse([data isCrcOk],nil);

  GHAssertThrows([data command], nil);
  GHAssertThrows([data address], nil);
}

- (void)testDecodingVersionResponseInvData{
  NSData* data=[@"cV=>]H==Ac========PY" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertFalse([data isMkData],nil);
}


@end
