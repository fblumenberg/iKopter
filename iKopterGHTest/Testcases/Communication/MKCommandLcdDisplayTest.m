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

@interface MKCommandLcdDisplayTest : GHTestCase
@end

@implementation MKCommandLcdDisplayTest

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

- (void)testDecodingLcdDiplay {
  
  NSString *screen = @"A1234567890123456789B1234567890123456789C1234567890123456789D1234567890123456789";
  
  NSData *payload = [screen dataUsingEncoding:NSASCIIStringEncoding];

  NSData *data = [payload dataWithCommand:MKCommandLcdResponse forAddress:kIKMkAddressFC];
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);

  NSData* payload2 = [data payload] ;

  IKLcdDisplay* l= [IKLcdDisplay menuWithData:payload2 forAddress:[data address]];
  
  GHAssertEqualStrings([l screenTextJoinedByString:@"|"],@"A1234567890123456789|B1234567890123456789|C1234567890123456789|D1234567890123456789",nil);
}

- (void)testDecodingLcdDiplayDictionary {
  
  NSString *screen = @"A1234567890123456789B1234567890123456789C1234567890123456789D1234567890123456789";
  
  NSData *payload = [screen dataUsingEncoding:NSASCIIStringEncoding];
  
  NSData *data = [payload dataWithCommand:MKCommandLcdResponse forAddress:kIKMkAddressFC];
  GHAssertNotNil(data,nil);
  GHAssertGreaterThan([data length], 0U,nil);

  
  NSData* payload2 = [data payload] ;
  
  NSDictionary* d = [payload2 decodeLcdResponseForAddress:[data address]];
  
  GHAssertGreaterThan([d count],0U,nil);
  
  IKLcdDisplay* l=[d objectForKey:kIKDataKeyLcdDisplay];
  
  GHAssertNotNil(l,nil);

  GHAssertEqualStrings([l screenTextJoinedByString:@"|"],@"A1234567890123456789|B1234567890123456789|C1234567890123456789|D1234567890123456789",nil);
}


@end
