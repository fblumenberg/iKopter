  //
//  InnerBand
//
//  InnerBand - Making the iOS SDK greater from within!
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@class CoreDataStore;


  


NSNumber *BOX_BOOL(BOOL x);
NSNumber *BOX_INT(NSInteger x);
NSNumber *BOX_SHORT(short x);
NSNumber *BOX_LONG(long x);
NSNumber *BOX_UINT(NSUInteger x);
NSNumber *BOX_FLOAT(float x);
NSNumber *BOX_DOUBLE(double x);

BOOL UNBOX_BOOL(NSNumber *x);
NSInteger UNBOX_INT(NSNumber *x);
short UNBOX_SHORT(NSNumber *x);
long UNBOX_LONG(NSNumber *x);
NSUInteger UNBOX_UINT(NSNumber *x);
float UNBOX_FLOAT(NSNumber *x);
double UNBOX_DOUBLE(NSNumber *x);


NSString *STRINGIFY_BOOL(BOOL x);
NSString *STRINGIFY_INT(NSInteger x);
NSString *STRINGIFY_SHORT(short x);
NSString *STRINGIFY_LONG(long x);
NSString *STRINGIFY_UINT(NSUInteger x);
NSString *STRINGIFY_FLOAT(float x);
NSString *STRINGIFY_DOUBLE(double x);


CGRect RECT_WITH_X(CGRect rect, float x);
CGRect RECT_WITH_Y(CGRect rect, float y);
CGRect RECT_WITH_X_Y(CGRect rect, float x, float y);

CGRect RECT_WITH_WIDTH_HEIGHT(CGRect rect, float width, float height);
CGRect RECT_WITH_WIDTH(CGRect rect, float width);
CGRect RECT_WITH_HEIGHT(CGRect rect, float height);
CGRect RECT_WITH_HEIGHT_FROM_BOTTOM(CGRect rect, float height);

CGRect RECT_INSET_BY_LEFT_TOP_RIGHT_BOTTOM(CGRect rect, float left, float top, float right, float bottom);
CGRect RECT_INSET_BY_TOP_BOTTOM(CGRect rect, float top, float bottom);
CGRect RECT_INSET_BY_LEFT_RIGHT(CGRect rect, float left, float right);

CGRect RECT_STACKED_OFFSET_BY_X(CGRect rect, float offset);
CGRect RECT_STACKED_OFFSET_BY_Y(CGRect rect, float offset);


UIImage *IMAGE(NSString *x);


double DEG_TO_RAD(double degrees);
double RAD_TO_DEG(double radians);

NSInteger CONSTRAINED_INT_VALUE(NSInteger val, NSInteger min, NSInteger max);
float CONSTRAINED_FLOAT_VALUE(float val, float min, float max);
double CONSTRAINED_DOUBLE_VALUE(double val, double min, double max);


BOOL fequal(double a, double b);
BOOL fequalf(float a, float b);
BOOL fequalzero(double a);
BOOL fequalzerof(float a);


BOOL IS_EMPTY_STRING(NSString *str);
BOOL IS_POPULATED_STRING(NSString *str);


NSString *RECT_TO_STR(CGRect r);
NSString *POINT_TO_STR(CGPoint p);
NSString *SIZE_TO_STR(CGSize s);


float RGB256_TO_COL(NSInteger rgb);
NSInteger COL_TO_RGB256(float col);


NSString *DOCUMENTS_DIR(void);


BOOL IS_IPAD(void);
BOOL IS_IPHONE(void);

BOOL IS_MULTITASKING_AVAILABLE(void);
BOOL IS_CAMERA_AVAILABLE(void);
BOOL IS_GAME_CENTER_AVAILABLE(void);
BOOL IS_EMAIL_ACCOUNT_AVAILABLE(void);
BOOL IS_GPS_ENABLED(void);
BOOL IS_GPS_ENABLED_ON_DEVICE(void);
BOOL IS_GPS_ENABLED_FOR_APP(void);


void DISPATCH_TO_MAIN_QUEUE(BOOL isAsync, void (^block)());
void DISPATCH_TO_GLOBAL_QUEUE(dispatch_queue_priority_t priority, BOOL isAsync, void (^block)());
void DISPATCH_TO_CURRENT_QUEUE(BOOL isAsync, void (^block)());
void DISPATCH_TO_QUEUE(dispatch_queue_t queue, BOOL isAsync, void (^block)());
void DISPATCH_TO_MAIN_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void DISPATCH_TO_GLOBAL_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_priority_t priority, void (^block)());
void DISPATCH_TO_CURRENT_QUEUE_AFTER(NSTimeInterval delay, void (^block)());
void DISPATCH_TO_QUEUE_AFTER(NSTimeInterval delay, dispatch_queue_t queue, void (^block)());




CG_EXTERN void CGContextAddRoundedRect(CGContextRef ccontext, CGRect rect, CGFloat radius);
CG_EXTERN void CGContextAddRoundedRectComplex(CGContextRef ccontext, CGRect rect, const CGFloat radiuses[]);




#if !defined(__clang__) || __clang_major__ < 3
    #ifndef __bridge
        #define __bridge
    #endif

    #ifndef __bridge_retain
        #define __bridge_retain
    #endif

    #ifndef __bridge_retained
        #define __bridge_retained
    #endif

    #ifndef __autoreleasing
        #define __autoreleasing
    #endif

    #ifndef __strong
        #define __strong
    #endif

    #ifndef __unsafe_unretained
        #define __unsafe_unretained
    #endif

    #ifndef __weak
        #define __weak
    #endif
#endif

#if __has_feature(objc_arc)
    #define SAFE_ARC_PROP_RETAIN strong
    #define SAFE_ARC_RETAIN(x) (x)
    #define SAFE_ARC_RELEASE(x)
    #define SAFE_ARC_AUTORELEASE(x) (x)
    #define SAFE_ARC_BLOCK_COPY(x) (x)
    #define SAFE_ARC_BLOCK_RELEASE(x)
    #define SAFE_ARC_SUPER_DEALLOC()
    #define SAFE_ARC_AUTORELEASE_POOL_START() @autoreleasepool {
    #define SAFE_ARC_AUTORELEASE_POOL_END() }
#else
    #define SAFE_ARC_PROP_RETAIN retain
    #define SAFE_ARC_RETAIN(x) ([(x) retain])
    #define SAFE_ARC_RELEASE(x) ([(x) release])
    #define SAFE_ARC_AUTORELEASE(x) ([(x) autorelease])
    #define SAFE_ARC_BLOCK_COPY(x) (Block_copy(x))
    #define SAFE_ARC_BLOCK_RELEASE(x) (Block_release(x))
    #define SAFE_ARC_SUPER_DEALLOC() ([super dealloc])
    #define SAFE_ARC_AUTORELEASE_POOL_START() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    #define SAFE_ARC_AUTORELEASE_POOL_END() [pool release];
#endif




#define HEIGHT_OF_STATUS_BAR 20
#define HEIGHT_OF_TOOLBAR 44
#define HEIGHT_OF_TABLE_CELL 44
#define HEIGHT_OF_TAB_BAR 49
#define HEIGHT_OF_SEARCH_BAR 44
#define HEIGHT_OF_NAVIGATION_BAR 44
#define HEIGHT_OF_TEXTFIELD 31
#define HEIGHT_OF_PICKER 216
#define HEIGHT_OF_KEYBOARD 216
#define HEIGHT_OF_SEGMENTED_CONTROL 43
#define HEIGHT_OF_SEGMENTED_CONTROL_BAR 29
#define HEIGHT_OF_SEGMENTED_CONTROL_BEZELED 40
#define HEIGHT_OF_SWITCH 27
#define HEIGHT_OF_SLIDER 22
#define HEIGHT_OF_PROGRESS_BAR 9
#define HEIGHT_OF_PAGE_CONTROL 36
#define HEIGHT_OF_BUTTON 37


#define SECONDS_IN_MINUTE 60
#define SECONDS_IN_HOUR 3600
#define SECONDS_IN_DAY 86400
#define SECONDS_IN_WEEK 604800
#define MINUTES_IN_HOUR 60
#define HOURS_IN_DAY 24
#define DAYS_IN_WEEK 7




#if __has_feature(objc_arc)
    #define SAFE_RELEASE(obj) 
    #define SAFE_TIMER_RELEASE(obj) 
#else
    #define SAFE_RELEASE(obj) ([obj release], obj = nil)
    #define SAFE_TIMER_RELEASE(obj) ([obj invalidate], [obj release], obj = nil)
#endif


#define SEL(x) @selector(x)
#define L(key) (NSLocalizedString((key), nil))

#define DECLARE_STRING( name ) extern NSString * const name;
#define DEFINE_STRING( name, value ) NSString * const name = value;
#define DECLARE_KEY( key ) extern NSString * const key;
#define DEFINE_KEY( key ) NSString * const key = @ #key;
#define DEFINE_KEY_WITH_VALUE( key, value ) NSString * const key = value;


typedef NSInteger (^ib_enum_bool_t)(id);
typedef id (^ib_enum_id_t)(id);
typedef void (^ib_http_proc_t)(NSData *, NSInteger);



#import <UIKit/UIKit.h>

@interface IBAlertView : UIAlertView <UIAlertViewDelegate> {
    void (^okCallback_)(void);
    void (^dismissCallback_)(void);
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle okTitle:(NSString *)okTitle dismissBlock:(void (^)(void))dismissBlock okBlock:(void (^)(void))okBlock;

- (id)initWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;
+ (id)alertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message dismissTitle:(NSString *)dismissTitle dismissBlock:(void (^)(void))dismissBlock;

+ (void)showDismissWithTitle:(NSString *)title message:(NSString *)message dismissBlock:(void (^)(void))dismissBlock;

@end



#import <UIKit/UIKit.h>

typedef enum {
	IBButtonTypeGlossy,
	IBButtonTypeSoft,
	IBButtonTypeFlat
} IBButtonType;

@interface IBButton : UIButton {
	IBButtonType _type;
	float _cornerRadius;
	UIColor *_color;
	UIColor *_shineColor;
	UIColor *_borderColor;
	int _borderSize;
}

@property(nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *color;
@property(nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *shineColor;
@property(nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *borderColor;
@property(nonatomic, assign) int borderSize;
@property(nonatomic, assign) IBButtonType type;
@property(nonatomic, assign) float cornerRadius;

+(IBButton*) glossButtonWithTitle:(NSString*)title color:(UIColor*)color;
+(IBButton*) softButtonWithTitle:(NSString*)title color:(UIColor*)color;
+(IBButton*) flatButtonWithTitle:(NSString*)title color:(UIColor*)color;

@end




#import <Foundation/Foundation.h>

@interface IBCoreTextLabel : UIControl {
	UIColor *_textColor;
	
	NSString *_text;
	NSMutableAttributedString *_attrStr;
	
	NSMutableArray *_boldRanges;
	NSMutableArray *_italicRanges;
	NSMutableArray *_fontRanges;
	NSMutableArray *_underlineRanges;
}

@property (nonatomic, SAFE_ARC_PROP_RETAIN) NSString *text;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *textColor;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) UIFont *font;
@property (nonatomic, readonly) float measuredHeight;

@end



#import <UIKit/UIKit.h>

@interface IBHTMLLabel : UIWebView {
	NSString *_text;
	UITextAlignment _textAlignment;
	UIColor *_textColor;
	UIColor *_linkColor;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UITextAlignment textAlignment;

@property (nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *textColor;
@property (nonatomic, SAFE_ARC_PROP_RETAIN) UIColor *linkColor;

@end



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStore : NSObject {
	NSManagedObjectContext *_managedObjectContext;	
}

@property (nonatomic, readonly) NSManagedObjectContext *context;

+ (CoreDataStore *)mainStore;
+ (CoreDataStore *)createStore;
+ (CoreDataStore *)createStoreWithContext:(NSManagedObjectContext *)context;

- (id)initWithContext:(NSManagedObjectContext *)context;

/* Clears all data from peristent store and re-initializes (great for unit testing!) */
- (void)clearAllData;

/* Saves context. */
- (void)save;

/* Create a new entity by name. */
- (NSManagedObject *)createNewEntityByName:(NSString *)entityName;

/* Remove entity. */
- (void)removeEntity:(NSManagedObject *)entity;

/* Remove all objects of an entity. */
- (void)removeAllEntitiesByName:(NSString *)entityName;


/* Returns ALL objects for an entity. */
- (NSUInteger)countForEntity:(NSString *)entityName error:(NSError **)error;

/* Returns ALL objects for an entity given a predicate. */
- (NSUInteger)countForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

/* Returns ALL objects for an entity. */
- (NSArray *)allForEntity:(NSString *)entityName error:(NSError **)error;

/* Returns ALL objects for an entity given a predicate. */
- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate error:(NSError **)error;

/* Returns ALL objects for an entity given a predicate and sorting. */
- (NSArray *)allForEntity:(NSString *)entityName predicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error;

/* Returns ALL objects for an entity ordered by a field. */
- (NSArray *)allForEntity:(NSString *)entityName orderBy:(NSString *)key ascending:(BOOL)ascending error:(NSError **)error;



/* Returns a single entity by name. */
- (NSManagedObject *)entityByName:(NSString *)entityName error:(NSError **)error;

/* Returns a single entity with the specified key/value. */
- (NSManagedObject *)entityByName:(NSString *)entityName key:(NSString *)key value:(NSObject *)value error:(NSError **)error;



/* Returns object based on URI representation. */
- (NSManagedObject *)entityByURI:(NSURL *)uri;

/* Returns object based on Object ID. */
- (NSManagedObject *)entityByObjectID:(NSManagedObjectID *)oid;



/* Returns an entity description by name. */
- (NSEntityDescription *)entityDescriptionForEntity:(NSString *)entityName;


@end



#import <Foundation/Foundation.h>


@interface DispatchMessage : NSObject {
    NSMutableDictionary *userInfo_;
}

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) NSDictionary *userInfo;
@property (nonatomic, assign, getter=isAsynchronous) BOOL asynchronous;

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
- (id)initWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
+ (id)messageWithName:(NSString *)name andObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

- (NSString *)name;
- (NSDictionary *)userInfo;

- (void)setUserInfoValue:(id)value forKey:(NSString *)key;

- (void)inputData:(NSData *)input;
- (NSData *)outputData;

@end



#import <Foundation/Foundation.h>

@class DispatchMessage;

@interface MessageCenter : NSObject {
}

+ (NSInteger)getCountOfListeningSources;

+ (void)setDebuggingEnabled:(BOOL)enabled;
+ (BOOL)isDebuggingEnabled;
	
+ (void)addGlobalMessageListener:(NSString *)name target:(NSObject *)target action:(SEL)action;
+ (void)addMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target action:(SEL)action;

+ (void)removeMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target action:(SEL)action;
+ (void)removeMessageListener:(NSString *)name source:(NSObject *)source target:(NSObject *)target;
+ (void)removeMessageListener:(NSString *)name target:(NSObject *)target action:(SEL)action;
+ (void)removeMessageListenersForTarget:(NSObject *)name;

+ (void)sendGlobalMessage:(DispatchMessage *)message;
+ (void)sendGlobalMessageNamed:(NSString *)name;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo;
+ (void)sendGlobalMessageNamed:(NSString *)name withUserInfoKey:(NSObject *)key andValue:(NSObject *)value;
+ (void)sendGlobalMessageNamed:(NSString *)name withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)sendMessage:(DispatchMessage *)message forSource:(NSObject *)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(NSObject *)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo forSource:(NSObject *)source;
+ (void)sendMessageNamed:(NSString *)name withUserInfoKey:(NSObject *)key andValue:(NSObject *)value forSource:(NSObject *)source;
+ (void)sendMessageNamed:(NSString *)name forSource:(NSObject *)source withObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;

@end



#import <Foundation/Foundation.h>

@class DispatchMessage;

@interface MessageProcessor : NSObject {
	DispatchMessage *_message;
	NSArray *_targetActions;
}

- (id)initWithMessage:(DispatchMessage *)message targetActions:(NSArray *)targetActions;
- (void)process;

@end



#import <Foundation/Foundation.h>

@interface TargetAction : NSObject

@property (nonatomic, assign) NSObject *target;
@property (nonatomic, copy) NSString *action;

@end



#import <Foundation/Foundation.h>

@interface NSArray (InnerBand)

- (NSArray *)sortedArrayAsDiacriticInsensitiveCaseInsensitive;
- (NSArray *)sortedArrayAsDiacriticInsensitive;
- (NSArray *)sortedArrayAsCaseInsensitive;
- (NSArray *)sortedArray;

- (NSArray *)reversedArray;
- (NSArray *)shuffledArray;

- (id)firstObject;

- (NSArray *)map:(ib_enum_id_t)blk;

@end



#import <UIKit/UIKit.h>


@interface NSDate (InnerBand)

@property (nonatomic, readonly) NSInteger utcYear;
@property (nonatomic, readonly) NSInteger utcMonth;
@property (nonatomic, readonly) NSInteger utcDay;
@property (nonatomic, readonly) NSInteger utcHour;
@property (nonatomic, readonly) NSInteger utcMinute;
@property (nonatomic, readonly) NSInteger utcSecond;

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;

+ (NSDate *)dateDaysAgo:(NSInteger)numDays;
+ (NSDate *)dateWeeksAgo:(NSInteger)numWeeks;

- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle;
- (NSString *)formattedTimeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedDatePattern:(NSString *)datePattern;

- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle;
- (NSString *)formattedUTCTimeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedUTCDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
- (NSString *)formattedUTCDatePattern:(NSString *)datePattern;

- (NSDate *)dateAsMidnight;

- (BOOL)isSameDay:(NSDate *)rhs;

@end



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (InnerBand)


+ (id)create;
+ (id)createInStore:(CoreDataStore *)store;


+ (NSUInteger)count;
+ (NSUInteger)countForPredicate:(NSPredicate *)predicate;
+ (NSUInteger)countInStore:(CoreDataStore *)store;
+ (NSUInteger)countForPredicate:(NSPredicate *)predicate inStore:(CoreDataStore *)store;

+ (NSArray *)all;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending;
+ (NSArray *)allInStore:(CoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate inStore:(CoreDataStore *)store;
+ (NSArray *)allForPredicate:(NSPredicate *)predicate orderBy:(NSString *)key ascending:(BOOL)ascending inStore:(CoreDataStore *)store;
+ (NSArray *)allOrderedBy:(NSString *)key ascending:(BOOL)ascending inStore:(CoreDataStore *)store;

+ (id)first;
+ (id)firstWithKey:(NSString *)key value:(NSObject *)value;

+ (id)firstInStore:(CoreDataStore *)store;
+ (id)firstWithKey:(NSString *)key value:(NSObject *)value inStore:(CoreDataStore *)store;


+ (void)destroyAll;
+ (void)destroyAllInStore:(CoreDataStore *)store;

- (void)destroy;

@end



#import <Foundation/Foundation.h>

@interface NSMutableArray (InnerBand)

+ (NSMutableArray *)arrayUnretaining;

- (void)sortDiacriticInsensitiveCaseInsensitive;
- (void)sortDiacriticInsensitive;
- (void)sortCaseInsensitive;

- (void)pushObject:(id)obj;
- (id)popObject;
- (id)shiftObject;
- (void)unshiftObject:(id)obj;

- (void)deleteIf:(ib_enum_bool_t)blk;

- (void)shuffle;
- (void)reverse;

@end



#import <Foundation/Foundation.h>

@interface NSMutableString (InnerBand)

- (void)trim;

@end



#import <UIKit/UIKit.h>


@interface NSNumber (InnerBand)

- (NSString *)formattedCurrency;
- (NSString *)formattedFlatCurrency;
- (NSString *)formattedCurrencyWithMinusSign;
- (NSString *)formattedDecimal;
- (NSString *)formattedFlatDecimal;
- (NSString *)formattedSpellOut;
	
@end



#import <UIKit/UIKit.h>


@interface NSObject (InnerBand)

- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (id)performSelector:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2;
- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
- (void)performSelectorInBackground:(SEL)selector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;

@end



#import <Foundation/Foundation.h>


@interface NSString (InnerBand)

- (NSComparisonResult)diacriticInsensitiveCaseInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)diacriticInsensitiveSort:(NSString *)rhs;
- (NSComparisonResult)caseInsensitiveSort:(NSString *)rhs;

- (NSString *)asBundlePath;
- (NSString *)asDocumentsPath;
	
- (BOOL)contains:(NSString *)substring;
- (BOOL)contains:(NSString *)substring options:(NSStringCompareOptions)options;

- (NSString *)trimmedString;

@end



#import <Foundation/Foundation.h>

typedef enum {
    kGTMXMLCharModeEncodeQUOT  = 0,
    kGTMXMLCharModeEncodeAMP   = 1,
    kGTMXMLCharModeEncodeAPOS  = 2,
    kGTMXMLCharModeEncodeLT    = 3,
    kGTMXMLCharModeEncodeGT    = 4,
    kGTMXMLCharModeValid       = 99,
    kGTMXMLCharModeInvalid     = 100,
} IBXMLCharMode;

@interface NSString (XMLEncoding)

- (NSString *)stringWithXMLSanitizingAndEscaping;
- (NSString *)stringWithXMLSanitizing;

@end



#import <Foundation/Foundation.h>

@interface UIColor (Hex)

+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b;
+ (UIColor *)colorWith256Red:(NSInteger)r green:(NSInteger)g blue:(NSInteger)b alpha:(NSInteger)a;

/*usage
 RGBA style hex value
 UIColor *solidColor = [UIColor colorWithRGBA:0xFF0000FF];
 UIColor *alphaColor = [UIColor colorWithRGBA:0xFF000099];
 */
+ (UIColor *) colorWithRGBA:(uint) hex;

/*usage
 ARGB style hex value
 UIColor *alphaColor = [UIColor colorWithHex:0x99FF0000];
 */
+ (UIColor *) colorWithARGB:(uint) hex;

/*usage
 RGB style hex value, alpha set to full
 UIColor *solidColor = [UIColor colorWithHex:0xFF0000];
 */
+ (UIColor *) colorWithRGB:(uint) hex;

/*usage 
 UIColor *solidColor = [UIColor colorWithWeb:@"#FF0000"];
 safe to omit # sign as well
 UIColor *solidColor = [UIColor colorWithWeb:@"FF0000"];
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString;

- (NSString *) hexString;

- (UIColor*) colorBrighterByPercent:(float) percent;
- (UIColor*) colorDarkerByPercent:(float) percent;

@property (nonatomic, readonly) CGFloat r;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, readonly) CGFloat b;
@property (nonatomic, readonly) CGFloat a;

@end



#import <UIKit/UIKit.h>


@interface UIImage (InnerBand)

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;
- (CGRect)convertRect:(CGRect)rect withContentMode:(UIViewContentMode)contentMode;

@end



#import <UIKit/UIKit.h>

@interface UIView (InnerBand)

- (CGFloat)left;
- (void)setLeft:(CGFloat)x;
- (CGFloat)top;
- (void)setTop:(CGFloat)y;
- (CGFloat)right;
- (void)setRight:(CGFloat)right;
- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;
- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;
- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

@property (nonatomic, assign) BOOL visible;

@end



#import <Foundation/Foundation.h>


@interface ViewUtil : NSObject {
}

/**
 This function is very handy for loading an instance of a specified class from a specified NIB
 file.  It's sorta like UIView initWithNibName, but more general purpose.  Very useful for loading
 UITableViewCells from NIB files, e.g.:
 
 MessageCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MessageCell"];
 if (cell == nil) {
 cell = [ViewUtil loadInstanceOfView:[MessageCell class] fromNibNamed:@"MessageCell"];
 }
 **/
+ (id)loadInstanceOfView:(Class)clazz fromNibNamed:(NSString *)name;

@end




@interface BlockBasedDispatchMessage : DispatchMessage {
    void (^inputBlock_)(NSData *);
    NSData *(^outputBlock_)(void);
}

+ (id)messageWithName:(NSString *)name isAsynchronous:(BOOL)isAsync input:(void (^)(NSData *))inputBlock output:(NSData * (^)(void))outputBlock;

@end



#import <Foundation/Foundation.h>

/*
 * 
 * MessageCenter will dispatch an HTTPGetRequestMessage after it processes the URL request you provide it.
 * When specifying a URL, you can provide substitution parameters using the syntax [MYPARAM] and
 * then providing the values for those parameters in the userInfo dictionary.
 *
 * INPUT: none
 * OUTPUT: the HTTP response data on success, nil on error
 *
 * USER INFO:
 *    HTTP_STATUS_CODE - HTTP status code of result
 *
 */

#define HTTP_STATUS_CODE @"HTTP_STATUS_CODE"

@interface HTTPGetRequestMessage : DispatchMessage {
	NSString *_url;
	NSMutableData *_responseData;
	NSMutableDictionary *_headersDict;
    ib_http_proc_t _processBlock;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url processBlock:(ib_http_proc_t)processBlock;

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key;

@end



#import <Foundation/Foundation.h>

#define HTTP_STATUS_CODE @"HTTP_STATUS_CODE"

@interface HTTPPostRequestMessage : DispatchMessage {
	NSString *_url;
    NSString *_body;
	NSMutableData *_responseData;
	NSMutableDictionary *_headersDict;
    ib_http_proc_t _processBlock;
}

+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo url:(NSString *)url body:(NSString *)body processBlock:(ib_http_proc_t)processBlock;

- (void)addHeaderValue:(NSString *)value forKey:(NSString *)key;

@end



#import <Foundation/Foundation.h>

@interface SequencedMessage : DispatchMessage {
	NSMutableArray *_messageSequence;
	NSData *_outputOfLastMessage;
}

- (id)initWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence;
+ (id)messageWithName:(NSString *)name userInfo:(NSDictionary *)userInfo sequence:(NSArray *)messageSequence;

@end

