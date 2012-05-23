#import "INIParser.h"
#import "InnerBand.h"

@interface INIParser () {

  NSMutableDictionary *sections;
  NSRegularExpression *sectionRegex;
  NSRegularExpression *lineRegex;

//	INISection * csection;

}

- (NSString *)sectionValueFromRow:(NSString *)row;
- (void)parseLineFromRow:(NSString *)row intoSection:(INISection *)section;

@end

@implementation INIParser

- (id)init{
  self = [super init];
  if (self) {
    sections = [[NSMutableDictionary alloc] init];
    sectionRegex = [[NSRegularExpression alloc] initWithPattern:@"^\\s*\\[(\\w+)\\]" options:0 error:nil];
    lineRegex = [[NSRegularExpression alloc] initWithPattern:@"^([-\\w]+)\\s*=(.*)$" options:0 error:nil];
  }
  return self;
}

- (id)initWithString:(NSString *)data {
  self = [self init];
  if (self) {
    [self parseString:data];
  }
  return self;
}

- (id)initWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error {
  NSString *data = [NSString stringWithContentsOfFile:path encoding:enc error:error];
  return [self initWithString:data];
}

- (void)dealloc {
  SAFE_ARC_RELEASE(sectionRegex);
  SAFE_ARC_RELEASE(lineRegex);
  SAFE_ARC_RELEASE(sections);
  SAFE_ARC_SUPER_DEALLOC();
}

#pragma mark - Parsing

- (void)parseString:(NSString *)data {

  [sections removeAllObjects];
  NSArray *allLinedStrings = [data componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

  INISection *currentSection = nil;
  for (NSString *row in allLinedStrings) {
    NSString *trimmedRow = [row trimmedString];

    NSString *value = [self sectionValueFromRow:trimmedRow];
    if (value) {
      currentSection = [[[INISection alloc] initWithName:value] autorelease];
      [sections setObject:currentSection forKey:value];
    }
    else {
      [self parseLineFromRow:trimmedRow intoSection:currentSection];
    }
  }
}

- (NSString *)sectionValueFromRow:(NSString *)row {
  NSArray *matches = [sectionRegex matchesInString:row options:0 range:NSMakeRange(0, [row length])];
  if (matches.count == 0)
    return nil;

  NSTextCheckingResult *match = [matches firstObject];

  return [row substringWithRange:[match rangeAtIndex:1]];
}

- (void)parseLineFromRow:(NSString *)row intoSection:(INISection *)section {
  NSArray *matches = [lineRegex matchesInString:row options:0 range:NSMakeRange(0, [row length])];
  if (matches.count > 0){
    NSTextCheckingResult *match = [matches firstObject];
    NSString* key = [row substringWithRange:[match rangeAtIndex:1]];
    NSString* value = [[row substringWithRange:[match rangeAtIndex:2]] trimmedString];
    [section insert:key value:value];
  }
}

- (NSString *)asString{
    
  NSMutableArray* rows = [NSMutableArray array];
  
  [sections  enumerateKeysAndObjectsUsingBlock:^(id sectionName,INISection* section, BOOL* stop){
    [rows pushObject:[NSString stringWithFormat:@"[%@]",section.name]];
    [section.assignments enumerateKeysAndObjectsUsingBlock:^(id key,id value, BOOL* stop){
      [rows pushObject:[NSString stringWithFormat:@"%@ = %@",key,value]];
    }];
  }];

  return [rows componentsJoinedByString:@"\n"];
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error{
  return  [[self asString] writeToFile:path atomically:useAuxiliaryFile encoding:enc error:error];
}

#pragma mark - Retrieve

- (BOOL)exists:(NSString *)name
       section:(NSString *)section {
  NSString *str;

  str = [self get:name section:section];
  return ((str != nil) ? YES : NO);
}

- (INISection *)getSection:(NSString *)name {
  INISection *sect = (INISection *) [sections objectForKey:name];
  return sect;
}

- (NSString *)get:(NSString *)name
          section:(NSString *)section {
  INISection *sect = [self getSection:section];
  return [sect retrieve:name];
}

- (BOOL)getBool:(NSString *)name
        section:(NSString *)section {
  NSString *str = [[self get:name section:section] lowercaseString];
  return ([str isEqualToString:@"y"] || [str isEqualToString:@"t"] || [str isEqualToString:@"1"]);
}

- (int)getInt:(NSString *)name
      section:(NSString *)section {
  NSString* value = [self get:name section:section];
  return [value intValue];
}

- (double)getDouble:(NSString *)name
      section:(NSString *)section {
  NSString* value = [self get:name section:section];
  return [value doubleValue];
}

#pragma mark - Set

- (void)set:(NSString*)value forName:(NSString *)name section:(NSString *)section{
  INISection* s = [sections objectForKey:section];
  if(s==nil){
    s = [[[INISection alloc] initWithName:section] autorelease];
    [sections setObject:s forKey:section];
  }
  [s insert:name value:value];
}

- (void)setNumber:(NSNumber*)value forName:(NSString *)name section:(NSString *)section{
  [self set:value.stringValue forName:name section:section];
}


@end
