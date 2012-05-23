#import <Foundation/Foundation.h>
#import "INISection.h"

#define INIP_ERROR_NONE      0
#define INIP_ERROR_INVALID_ASSIGNMENT  1
#define INIP_ERROR_FOPEN_FAILED    2
#define INIP_ERROR_INVALID_SECTION  3
#define INIP_ERROR_NO_SECTION    4

@interface INIParser : NSObject

- (id)initWithString:(NSString *)data;
- (id)initWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;

- (void)parseString:(NSString *)data;
- (NSString *)asString;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error;

- (BOOL)exists:(NSString *)name section:(NSString *)section;
- (INISection *)getSection:(NSString *)name;
- (NSString *)get:(NSString *)name section:(NSString *)section;
- (BOOL)getBool:(NSString *)name section:(NSString *)section;
- (int)getInt:(NSString *)name section:(NSString *)section;
- (double)getDouble:(NSString *)name section:(NSString *)section;

- (void)set:(NSString*)value forName:(NSString *)name section:(NSString *)section;
- (void)setNumber:(NSNumber*)value forName:(NSString *)name section:(NSString *)section;


@end

//#import "utils.h"
//#import "parse.h"
//#import "retrieve.h"
