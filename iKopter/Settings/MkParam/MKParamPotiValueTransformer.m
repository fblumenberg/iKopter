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


#import <IBAForms/IBAForms.h>
#import "MKParamPotiValueTransformer.h"

@interface MKParamPotiValueTransformer ()

@property(nonatomic, readwrite, retain) NSArray *pickListOptions;

@end

@implementation MKParamPotiValueTransformer

@synthesize pickListOptions = pickListOptions_;

+ (MKParamPotiValueTransformer *)transformer {
  return [[MKParamPotiValueTransformer new] autorelease];
}


- (id)init {
  self = [super init];
  if (self) {
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:256];
    for (int i = 0; i < 248; i++) {
      [values addObject:[NSString stringWithFormat:@"%d", i]];
    }

    for (int i = 248; i < 256; i++) {
      [values addObject:[NSString stringWithFormat:@"Poti %d", 256 - i]];
    }

    self.pickListOptions = [IBAPickListFormOption pickListOptionsForStrings:values];
  }

  return self;
}

- (void)dealloc {
  self.pickListOptions = nil;
  [super dealloc];
}

+ (Class)transformedValueClass {
  return [NSNumber class];
}

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)transformedValue:(id)value {
  // Assume we're given a set with a single IBAPickListFormOption and convert it to an NSNumber representing the option
  // index in to pickListOptions
  IBAPickListFormOption *option = [value anyObject];
  NSNumber *index = [NSNumber numberWithInt:[self.pickListOptions indexOfObject:option]];

  return index;
}

- (id)reverseTransformedValue:(id)value {
  // Assume we're given an NSNumber representing an index in to pickListOptions and convert it to a set with a
  // single IBAPickListFormOption
  NSMutableSet *options = [[[NSMutableSet alloc] init] autorelease];
  int index = [(NSNumber *) value intValue];
  if ((index >= 0) && (index < [self.pickListOptions count])) {
    IBAPickListFormOption *option = [self.pickListOptions objectAtIndex:index];
    if (option != nil) {
      [options addObject:option];
    }
  }

  return options;
}


@end
