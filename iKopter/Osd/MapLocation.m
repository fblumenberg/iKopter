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

#import "MapLocation.h"
#import <MapKit/MapKit.h>

@implementation MapLocation
@synthesize type;
@synthesize coordinate;
#pragma mark -
- (NSString *)title {
    return NSLocalizedString(@"You are Here!", @"You are Here!");
}

//- (NSString *)subtitle {
//    
//    NSMutableString *ret = [NSMutableString string];
//    if (streetAddress)
//        [ret appendString:streetAddress]; 
//    if (streetAddress && (city || state || zip)) 
//        [ret appendString:@" • "];
//    if (city)
//        [ret appendString:city];
//    if (city && state)
//        [ret appendString:@", "];
//    if (state)
//        [ret appendString:state];
//    if (zip)
//        [ret appendFormat:@", %@", zip];
//    
//    return ret;
//}

#pragma mark -
- (void)dealloc {
    [super dealloc];
}
#pragma mark -
#pragma mark NSCoding Methods
- (void) encodeWithCoder: (NSCoder *)encoder {
    [encoder encodeObject: [NSNumber numberWithInt:self.type] forKey: @"type"];
}
- (id) initWithCoder: (NSCoder *)decoder  {
    if ((self = [super init])) {
      self.type = [[decoder decodeObjectForKey: @"type"] intValue];
    }
    return self;
}
@end
