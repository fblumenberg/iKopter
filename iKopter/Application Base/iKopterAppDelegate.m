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

#import "iKopterAppDelegate.h"
#import "MKConnectionController.h"
#import "DropboxSDK.h"
#import "IKDropboxLoginController.h"

// Here we import the Dropbox credentials. You have to get your own to compile.
#import "ExternalData.h"

#ifndef kDROPBOX_CONSUMER_KEY
#define kDROPBOX_CONSUMER_KEY @"<YOUR CONSUMER KEY>"
#endif

#ifndef kDROPBOX_CONSUMER_SECRET
#define kDROPBOX_CONSUMER_SECRET @"<YOUR CONSUMER SECRET>"
#endif

#undef ql_component
#define ql_component lcl_cApplication


@interface iKopterAppDelegate () <DBSessionDelegate>

@end


@implementation iKopterAppDelegate

@synthesize window=_window;
@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;
@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  // Override point for customization after application launch.
  // Add the navigation controller's view to the window and display.
  self.window.rootViewController = self.navigationController;
  [self.window makeKeyAndVisible];
  
  // Load the default values for the user defaults
  NSString* pathToUserDefaultsValues = [[NSBundle mainBundle]
                                        pathForResource:@"userDefaults" 
                                        ofType:@"plist"];
  NSDictionary* userDefaultsValues = [NSDictionary dictionaryWithContentsOfFile:pathToUserDefaultsValues];
  
  // Set them in the standard user defaults
  [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValues];

  NSLog(@"Def:%@",[[NSUserDefaults standardUserDefaults]dictionaryRepresentation]);

  
  
  qlinfo(@"Initializing the crash log manager");
  [[BWQuincyManager sharedQuincyManager] setSubmissionURL:@"http://frankblumenberg.de/crashlog/crash_v200.php"];
  [[BWQuincyManager sharedQuincyManager] setDelegate:self];
  
  
  [self saveContext];
  
  // Set these variables before launching the app
  NSString* consumerKey = kDROPBOX_CONSUMER_KEY;
	NSString* consumerSecret = kDROPBOX_CONSUMER_SECRET;
	
	// Look below where the DBSession is created to understand how to use DBSession in your app
	
	NSString* errorMsg = nil;
	if ([consumerKey rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer key correctly";
	} else if ([consumerSecret rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
		errorMsg = @"Make sure you set the consumer secret correctly";
	}
	
	DBSession* session = 
  [[DBSession alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
	session.delegate = self; // DBSessionDelegate methods allow you to handle re-authenticating
	[DBSession setSharedSession:session];
  [session release];
	
	if (errorMsg != nil) {
		[[[[UIAlertView alloc]
		   initWithTitle:@"Error Configuring Session" message:errorMsg 
		   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
		  autorelease]
		 show];
	}
  
  
  
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  [[MKConnectionController sharedMKConnectionController] stop];

  self.navigationController.delegate = nil;
  [self.navigationController popToRootViewControllerAnimated:NO]; 

  [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Saves changes in the application's managed object context before the application terminates.
  [self saveContext];
}

- (void)dealloc
{
  [_window release];
  [_navigationController release];
  [__managedObjectContext release];
  [__managedObjectModel release];
  [__persistentStoreCoordinator release];
  [super dealloc];
}

#pragma mark CrashReportSenderDelegate

-(void)connectionOpened {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}


-(void)connectionClosed {
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)saveContext
{
  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil)
  {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
    {
      /*
       Replace this implementation with code to handle the error appropriately.
       
       abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
       */
      qlcritical(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    } 
  }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
  if (__managedObjectContext != nil)
  {
    return __managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil)
  {
    __managedObjectContext = [[NSManagedObjectContext alloc] init];
    [__managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
  if (__managedObjectModel != nil)
  {
    return __managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iKopter" withExtension:@"momd"];
  
  qlinfo(@"URL for managed model %@",modelURL);
  __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
  return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (__persistentStoreCoordinator != nil)
  {
    return __persistentStoreCoordinator;
  }

  NSURL *storeURL = [NSURL fileURLWithPath:TTPathForDocumentsResource(@"ikopter.sqlite")];
  qlinfo(@"URL for core data store %@",storeURL);

  NSError *error = nil;
  __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
  {
    /*
     Replace this implementation with code to handle the error appropriately.
     
     abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
     
     Typical reasons for an error here include:
     * The persistent store is not accessible;
     * The schema for the persistent store is incompatible with current managed object model.
     Check the error message to determine what the actual problem was.
     
     
     If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
     
     If you encounter schema incompatibility errors during development, you can reduce their frequency by:
     * Simply deleting the existing store:
     [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
     
     * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
     [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
     
     Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
     
     */
    qlcritical(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }    
  
  return __persistentStoreCoordinator;
}

#pragma mark DBSessionDelegate methods

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	IKDropboxLoginController* loginController = [[IKDropboxLoginController new] autorelease];
	[loginController presentFromController:self.navigationController];
}

@end
