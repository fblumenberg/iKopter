#import "INISection.h"
#import "InnerBand.h"

@interface INISection () {
  NSMutableDictionary *assignments;
  NSString *sname;
}

@end

@implementation INISection
@synthesize assignments;

- (id)initWithName:(NSString *)name {
  self = [super init];
  if (self) {
    assignments = [[NSMutableDictionary alloc] init];
    sname = name;
  }
  return self;
}

- (void)dealloc {
  SAFE_ARC_RELEASE(assignments);
  SAFE_ARC_RELEASE(sname);
  SAFE_ARC_SUPER_DEALLOC();
}

- (NSString *)name{
  return sname;
}

- (void)insert:(NSString *)name value:(NSString *)value {
  [assignments setObject:value forKey:name];
}

- (NSString *)retrieve:(NSString *)name {
  return [assignments objectForKey:name];
}

@end
