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
