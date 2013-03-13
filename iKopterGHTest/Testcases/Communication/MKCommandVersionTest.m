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
#import "IKDeviceVersion.h"

#import "MKDataConstants.h"
#import "NSData+MKCommandDecode.h"
#import "NSData+MKPayloadDecode.h"

@interface MKCommandVersionTest : GHTestCase
@end

@implementation MKCommandVersionTest

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

- (void)testDecodingFCVersion {
  
  NSData *data = [@"#bV=BMH============PH" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(data,nil);

  GHAssertEquals([data command], MKCommandVersionResponse, nil);
  GHAssertEquals([data address], kIKMkAddressFC, nil);

  NSData* payload2 = [data payload] ;

  IKDeviceVersion* v = [IKDeviceVersion versionWithData:payload2 forAddress:[data address]];
  
  GHAssertEquals(v.address, [data address],nil);
  GHAssertEqualStrings(v.versionString, @"FlightCtrl 0.84 a",nil);
  GHAssertEqualStrings(v.versionStringShort, @"0.84a",nil);
  
  GHAssertFalse(v.hasError,nil);
}

- (void)testDecodingFCVersionError {
  
  NSData *data = [@"#bV=B]H==M=?=======Pj" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(data,nil);
  
  GHAssertEquals([data command], MKCommandVersionResponse, nil);
  GHAssertEquals([data address], kIKMkAddressFC, nil);
  
  NSData* payload2 = [data payload] ;
  
  IKDeviceVersion* v = [IKDeviceVersion versionWithData:payload2 forAddress:[data address]];
  
  GHAssertEquals(v.address, [data address],nil);
  GHAssertEqualStrings(v.versionString, @"FlightCtrl 0.88 e",nil);
  GHAssertEqualStrings(v.versionStringShort, @"0.88e",nil);
  
  GHAssertTrue(v.hasError,nil);
  GHAssertGreaterThan([[v errorDescriptions] count],0U,nil);
}

- (void)testDecodingNCVersion {
  
  NSData *data = [@"#cV=>]H==A=========PY" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(data,nil);
  
  GHAssertEquals([data command], MKCommandVersionResponse, nil);
  GHAssertEquals([data address], kIKMkAddressNC, nil);
  
  NSData* payload2 = [data payload] ;
  
  IKDeviceVersion* v = [IKDeviceVersion versionWithData:payload2 forAddress:[data address]];
  
  GHAssertEquals(v.address, [data address],nil);
  GHAssertEqualStrings(v.versionString, @"NaviCtrl 0.24 b",nil);
  GHAssertEqualStrings(v.versionStringShort, @"0.24b",nil);
  
  GHAssertFalse(v.hasError,nil);
}

- (void)testDecodingNCVersionDictionary {
  
  NSData *data = [@"#cV=>]H==A=========PY" dataUsingEncoding:NSASCIIStringEncoding];
  GHAssertNotNil(data,nil);
  
  GHAssertEquals([data command], MKCommandVersionResponse, nil);
  GHAssertEquals([data address], kIKMkAddressNC, nil);
  
  NSData* payload2 = [data payload] ;
  
  IKDeviceVersion* v = [IKDeviceVersion versionWithData:payload2 forAddress:[data address]];
  
  GHAssertEquals(v.address, [data address],nil);
  GHAssertEqualStrings(v.versionString, @"NaviCtrl 0.24 b",nil);
  GHAssertEqualStrings(v.versionStringShort, @"0.24b",nil);
  
  GHAssertFalse(v.hasError,nil);
  
  NSDictionary* d = [payload2 decodeVersionResponseForAddress:[data address]];

  GHAssertGreaterThan([d count],0U,nil);
  
  IKDeviceVersion* v2=[d objectForKey:kIKDataKeyVersion];
  
  GHAssertNotNil(v2,nil);
  
  GHAssertEquals(v.address, v2.address,nil);
  GHAssertEqualStrings(v.versionString, v.versionString,nil);
  GHAssertEqualStrings(v.versionStringShort, v.versionStringShort,nil);
}



@end
