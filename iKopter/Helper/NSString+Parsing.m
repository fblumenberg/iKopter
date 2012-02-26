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

#import "NSString+Parsing.h"

@implementation NSString (ParsingExtensions)

- (NSArray *)csvRows {
  NSMutableArray *rows = [NSMutableArray array];

  // Get newline character set
  NSMutableCharacterSet *newlineCharacterSet = (id) [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
  [newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];

  // Characters that are important to the parser
  NSMutableCharacterSet *importantCharactersSet = (id) [NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
  [importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];

  // Create scanner, and scan string
  NSScanner *scanner = [NSScanner scannerWithString:self];
  [scanner setCharactersToBeSkipped:nil];
  while (![scanner isAtEnd]) {
    BOOL insideQuotes = NO;
    BOOL finishedRow = NO;
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *currentColumn = [NSMutableString string];
    while (!finishedRow) {
      NSString *tempString;
      if ([scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString]) {
        [currentColumn appendString:tempString];
      }

      if ([scanner isAtEnd]) {
        if (![currentColumn isEqualToString:@""]) [columns addObject:currentColumn];
        finishedRow = YES;
      }
      else if ([scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString]) {
        if (insideQuotes) {
          // Add line break to column text
          [currentColumn appendString:tempString];
        }
        else {
          // End of row
          if (![currentColumn isEqualToString:@""]) [columns addObject:currentColumn];
          finishedRow = YES;
        }
      }
      else if ([scanner scanString:@"\"" intoString:NULL]) {
        if (insideQuotes && [scanner scanString:@"\"" intoString:NULL]) {
          // Replace double quotes with a single quote in the column string.
          [currentColumn appendString:@"\""];
        }
        else {
          // Start or end of a quoted string.
          insideQuotes = !insideQuotes;
        }
      }
      else if ([scanner scanString:@"," intoString:NULL]) {
        if (insideQuotes) {
          [currentColumn appendString:@","];
        }
        else {
          // This is a column separating comma
          [columns addObject:currentColumn];
          currentColumn = [NSMutableString string];
          [scanner scanCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:NULL];
        }
      }
    }
    if ([columns count] > 0) [rows addObject:columns];
  }

  return rows;
}

@end