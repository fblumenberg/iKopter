//
//  NSString+Parsing.m
//  iKopter
//
//  Created by Frank Blumenberg on 27.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSString+Parsing.h"

@implementation NSString (ParsingExtensions)

-(NSArray *)csvRows {
  NSMutableArray *rows = [NSMutableArray array];
  
  // Get newline character set
  NSMutableCharacterSet *newlineCharacterSet = (id)[NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
  [newlineCharacterSet formIntersectionWithCharacterSet:[[NSCharacterSet whitespaceCharacterSet] invertedSet]];
  
  // Characters that are important to the parser
  NSMutableCharacterSet *importantCharactersSet = (id)[NSMutableCharacterSet characterSetWithCharactersInString:@",\""];
  [importantCharactersSet formUnionWithCharacterSet:newlineCharacterSet];
  
  // Create scanner, and scan string
  NSScanner *scanner = [NSScanner scannerWithString:self];
  [scanner setCharactersToBeSkipped:nil];
  while ( ![scanner isAtEnd] ) {        
    BOOL insideQuotes = NO;
    BOOL finishedRow = NO;
    NSMutableArray *columns = [NSMutableArray arrayWithCapacity:10];
    NSMutableString *currentColumn = [NSMutableString string];
    while ( !finishedRow ) {
      NSString *tempString;
      if ( [scanner scanUpToCharactersFromSet:importantCharactersSet intoString:&tempString] ) {
        [currentColumn appendString:tempString];
      }
      
      if ( [scanner isAtEnd] ) {
        if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
        finishedRow = YES;
      }
      else if ( [scanner scanCharactersFromSet:newlineCharacterSet intoString:&tempString] ) {
        if ( insideQuotes ) {
          // Add line break to column text
          [currentColumn appendString:tempString];
        }
        else {
          // End of row
          if ( ![currentColumn isEqualToString:@""] ) [columns addObject:currentColumn];
          finishedRow = YES;
        }
      }
      else if ( [scanner scanString:@"\"" intoString:NULL] ) {
        if ( insideQuotes && [scanner scanString:@"\"" intoString:NULL] ) {
          // Replace double quotes with a single quote in the column string.
          [currentColumn appendString:@"\""]; 
        }
        else {
          // Start or end of a quoted string.
          insideQuotes = !insideQuotes;
        }
      }
      else if ( [scanner scanString:@"," intoString:NULL] ) {  
        if ( insideQuotes ) {
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
    if ( [columns count] > 0 ) [rows addObject:columns];
  }
  
  return rows;
}

@end