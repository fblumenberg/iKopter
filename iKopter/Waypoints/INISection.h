#import <Foundation/Foundation.h>

@interface INISection : NSObject 
- (id)initWithName: (NSString *)name;
- (void)insert: (NSString *)name value: (NSString *)value;
- (NSString *)retrieve: (NSString *)name;

@property(readonly) NSString* name;
@property(readonly) NSDictionary* assignments;

@end
