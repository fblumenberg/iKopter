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


#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

# ifndef _LCL_NO_LOGGING

  BOOL logActive = NO;
  _lcl_level_t level = lcl_vCritical;

  NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingActive];
  if (testValue) {
    logActive = [[NSUserDefaults standardUserDefaults] boolForKey:kIKLoggingActive];
  }

  testValue = nil;
  testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kIKLoggingLevel];
  if (testValue) {
    level = [[NSUserDefaults standardUserDefaults] integerForKey:kIKLoggingLevel];
  }

  if (!logActive)
    level = lcl_vOff;

  lcl_configure_by_identifier("*", level);

# endif

  qlinfo(@"Logging initialized, path ist %@", [LCLLogFile path])

  int retVal = UIApplicationMain(argc, argv, nil, nil);
  [pool release];
  return retVal;
}
