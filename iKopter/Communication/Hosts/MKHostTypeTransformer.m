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


#import "IBAForms/IBAPickListFormField.h"
#import "MKHostTypeTransformer.h"

@implementation MKHostTypeTransformer

@synthesize pickListOptions;

+ (id)instance {
	return [[[[self class] alloc] init] autorelease];
}

- (id)init {
  self = [super init];
  if (self) {
    keys = [[NSArray alloc] initWithObjects:
            @"MKIpConnection", 
            @"MKSerialConnection", 
            @"MKBluetoothConnection", 
            @"MKFakeConnection", 
            nil];

    pickListOptions = [[NSMutableArray array]retain];
    UIFont* font=[UIFont systemFontOfSize:16];
    
    [pickListOptions addObject:[[[IBAPickListFormOption alloc] initWithName:NSLocalizedString(@"WLAN Connection",@"WLAN Connection title") 
                                                                  iconImage:[UIImage imageNamed:@"icon-wifi.png"] 
                                                                       font:font] autorelease]];
    [pickListOptions addObject:[[[IBAPickListFormOption alloc] initWithName:NSLocalizedString(@"Serial Connection",@"Serial Connection title")
                                                                  iconImage:[UIImage imageNamed:@"icon-usb.png"] 
                                                                       font:font] autorelease]];
    [pickListOptions addObject:[[[IBAPickListFormOption alloc] initWithName:NSLocalizedString(@"Bluetooth Connection",@"BT Connection title") 
                                                                  iconImage:[UIImage imageNamed:@"icon-bluetooth.png"] 
                                                                       font:font] autorelease]];
    [pickListOptions addObject:[[[IBAPickListFormOption alloc] initWithName:NSLocalizedString(@"Fake Connection",@"Fake Connection title") 
                                                                  iconImage:[UIImage imageNamed:@"icon-phone.png"] 
                                                                       font:font] autorelease]];
  }
  return self;
}

- (void)dealloc {
  [keys release];
  [pickListOptions release];
  [super dealloc];
}


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSString class];
}

- (id)transformedValue:(id)value {
  
	IBAPickListFormOption *option = [value anyObject];

  int idx = [self.pickListOptions indexOfObject:option];

  return idx!=NSNotFound?[keys objectAtIndex:idx]:nil;
}

- (id)reverseTransformedValue:(id)value {
  // Assume we're given an NSString representing an index in to pickListOptions and convert it to a set with a 
	// single IBAPickListFormOption
	NSMutableSet *options = [[[NSMutableSet alloc] init] autorelease];
	
  int index = [keys indexOfObject:value];
  
	if ((index >= 0) && (index < [self.pickListOptions count])) {
		IBAPickListFormOption *option = [self.pickListOptions objectAtIndex:index];
		if (option != nil) {
			[options addObject:option];
		}
	}
	
	return options;

  
}

@end
