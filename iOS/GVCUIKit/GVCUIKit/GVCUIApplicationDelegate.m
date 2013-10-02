//
//  DAApplicationDelegate.m
//
//  Created by David Aspinall on 10-01-23.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUIApplicationDelegate.h"
#import "GVCFoundation.h"

@interface GVCUIApplicationDelegate ()
@property (strong, nonatomic, readwrite) NSOperationQueue *operationQueue;
@end

@implementation GVCUIApplicationDelegate

@synthesize window;
@synthesize operationQueue;

- (NSString *)applicationName
{
	return [NSBundle gvc_MainBundleName];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    // set uncaught exception handler - from GVCFoundation/GVCFunctions
    NSSetUncaughtExceptionHandler(&gvc_UncaughtException);
    
    // initialize the operation queue
    [self setOperationQueue:[[NSOperationQueue alloc] init]];

    [[GVCConfiguration sharedGVCConfiguration] setOperationQueue:[self operationQueue]];
    [[GVCConfiguration sharedGVCConfiguration] reloadConfiguration];

    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 
    {
//        UISplitViewController *splitViewController = (UISplitViewController *)[self window] rootViewController;
//        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
//        splitViewController.delegate = (id)navigationController.topViewController;
//        
//        UINavigationController *masterNavigationController = [splitViewController.viewControllers objectAtIndex:0];
//        GVCMasterViewController *controller = (GVCMasterViewController *)masterNavigationController.topViewController;
//        controller.managedObjectContext = self.managedObjectContext;
    } else {
//        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        GVCMasterViewController *controller = (GVCMasterViewController *)navigationController.topViewController;
//        controller.managedObjectContext = self.managedObjectContext;
    }

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsPath
{
	NSFileManager *filemgr = [NSFileManager defaultManager];
	return [filemgr gvc_documentsDirectoryPath];
}

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsURL
{
	NSFileManager *filemgr = [NSFileManager defaultManager];
	return [filemgr gvc_documentsDirectoryURL];
}

- (NSArray *)applicationResourcesOfType:(NSString *)extension inDirectory:(NSString *)subfolder
{
	GVC_ASSERT( (gvc_IsEmpty(extension) == YES) || (gvc_IsEmpty(subfolder) == YES), @"Finding resources requires an extension or a subfolder" );
	return [[NSBundle bundleForClass:[self class]] pathsForResourcesOfType:extension inDirectory:subfolder];
}

- (NSString *)applicationResourcePathForName:(NSString *)apath ofType:(NSString *)extension inDirectory:(NSString *)subfolder
{
	GVC_ASSERT( gvc_IsEmpty(apath) == NO, @"Finding resources requires an a path" );
	return [[NSBundle bundleForClass:[self class]] pathForResource:apath ofType:extension inDirectory:subfolder];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application 
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


@end

