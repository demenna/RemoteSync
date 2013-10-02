/*
 * GVCCoreDataUIAppDelegate.m
 * 
 * Created by David Aspinall on 12-04-12. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCCoreDataUIAppDelegate.h"
#import "GVCFoundation.h"
#import "GVCXMLDataOperation.h"

@interface GVCCoreDataUIAppDelegate ()
@property (nonatomic, strong, readwrite) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readwrite) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end

@implementation GVCCoreDataUIAppDelegate

@synthesize managedObjectModel;
@synthesize managedObjectContext;
@synthesize persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
    BOOL success = [super application:application didFinishLaunchingWithOptions:launchOptions];
    if ( success == YES )
    {
        // create a store for each model
        GVCLogInfo( @"application:(UIApplication *)application didFinishLaunchingWithOptions");
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *modelPaths = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd" inDirectory:nil];
        NSMutableDictionary *allModels = [[NSMutableDictionary alloc] initWithCapacity:[modelPaths count]];
        
        // pass 1, collect and validate the modelss
        for ( NSString *momdPath in modelPaths )
        {
            NSString *modelName = [[momdPath lastPathComponent] stringByDeletingPathExtension];
            NSURL *modelURL = [NSURL fileURLWithPath:momdPath];
            NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
            NSArray *hl7Entities = [model entitiesForConfiguration:modelName];
            GVC_ASSERT([[model entities] gvc_isEqualToArrayInAnyOrder:hl7Entities], @"Configuration for %@ does not include all entities", modelName);
            
            GVC_ASSERT([allModels objectForKey:modelName] == nil, @"Loaded duplicate model named %@", modelName);
            [allModels setObject:model forKey:modelName];
        }
        
//            // force model to migrate now, does not work when models are combined
//            NSError *err = nil;
//            NSURL *storeURL = [NSURL fileURLWithPath:modelSQL];
//            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
//            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
//            NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:modelName URL:storeURL options:options error:&err];
//            if (store == nil)
//            {
//                GVC_ASSERT(NO, @"Failed to allocate persistent/migrate store for %@.  Error %@ UserInfo %@", storeURL, [err localizedDescription], [err userInfo]);
//            }
//        }
        
        if ( [allModels count] > 0 )
        {
            NSManagedObjectModel *superModel = [NSManagedObjectModel modelByMergingModels:[allModels allValues]];
            NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:superModel];
            NSManagedObjectContext *moContext = [[NSManagedObjectContext alloc] init];
            [moContext setPersistentStoreCoordinator:coordinator];
            
            // TODO: check for database version and upgrade
            // maybe each model should have a version and a ModelUpgrade class
            // example [BucketsModel upgradeDatabase:moc];
            // [self upgradeDatabase];
            // [moContext setUndoManager:[[NSUndoManager  alloc] init]];
            [moContext setUndoManager:nil];
            
            // set the stack
            [self setManagedObjectModel:superModel];
            [self setPersistentStoreCoordinator:coordinator];
            [self setManagedObjectContext:moContext];
            
            // create one store sqlite file for each model
            // pass 2, install and migrate any seed data

            NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
            for (NSString *modelName in [allModels allKeys])
            {
                NSError *err = nil;
                // copy in sample data files if they exist
                NSURL *storeURL = [[GVCDirectory DocumentDirectory] fullURLForFile:GVC_SPRINTF(@"%@.sqlite", modelName)];
                
                if ( [fileManager fileExistsAtPath:[storeURL path]] == NO )
                {
                    // copy in sample database 
                    NSString *sample = [[NSBundle mainBundle] pathForResource:modelName ofType:@"sqlite"];
                    if ( gvc_IsEmpty(sample) == NO )
                    {
                        GVCLogInfo( @"Installing database %@", sample);
                        [fileManager copyItemAtPath:sample toPath:[storeURL path] error:nil];

                        // Create one coordinator that just migrates, but isn't used.
                        // This will just handle the migration, without any configuration or else ...
                        NSPersistentStore* tmpStore = [coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&err];
                        // And remove it !
                        [coordinator removePersistentStore:tmpStore error:&err];
                    }
                }

                // NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSReadOnlyPersistentStoreOption, nil];
                if ([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:modelName URL:storeURL options:nil error:&err] == nil)
                {
                    GVC_ASSERT(NO, @"Failed to allocate persistent store for %@.  Error %@", storeURL, [err description]);
                }
            }
            
            // last pass, load any additional data files for each model
            for (NSString *modelName in [allModels allKeys])
            {
                NSArray *operations = [self modelLoadedOperations:modelName];
                [[self operationQueue] addOperations:operations waitUntilFinished:NO];
            }
        }
    }

    return success;
}

- (GVCDataSavedOperationBlock)defaultOperationDidSaveBlock
{
    return ^(GVCOperation *operation, NSNotification *notification) {
        [self mergeChanges:notification];
    };
}

/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application 
{
	[self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application 
{
    [self saveContext];
}

#pragma mark -
#pragma mark Core Data stack

- (NSArray *)modelLoadedOperations:(NSString *)modelName
{
    NSArray *arrayOfOperations = nil;
    NSString *dataFile = GVC_SPRINTF(@"%@_initial_data", modelName);
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:dataFile ofType:@"xml"];
    GVCLogError( @"Looking for data named %@.xml", dataFile );
    if ( [[NSFileManager defaultManager] fileExistsAtPath:dataPath] == YES )
    {
        GVCLogError( @"  Found %@", dataPath );
        GVCXMLDataOperation *op = [[GVCXMLDataOperation alloc] initForPersistentStoreCoordinator:[self persistentStoreCoordinator] usingFile:dataPath];
        arrayOfOperations = [NSArray arrayWithObject:op];
    }
    return arrayOfOperations;
}

- (void)saveContext 
{
    NSError *error = nil;
    if (([[self managedObjectContext] hasChanges] == YES) && ([[self managedObjectContext] save:&error] == NO))
    {
        GVC_ASSERT_LOG(@"Save failed: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}


- (void)mergeChanges:(NSNotification*)notification
{
	GVC_ASSERT([NSThread mainThread], @"Not on the main thread");
	
    if ([self managedObjectContext] != nil) 
	{
		[[self managedObjectContext] mergeChangesFromContextDidSaveNotification:notification];
    }
}


@end
