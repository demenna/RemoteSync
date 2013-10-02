//
//  DADataOperation.m
//
//  Created by David Aspinall on 10-01-31.
//  Copyright 2012 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDataOperation.h"

@interface GVCDataOperation ()
@property (strong, nonatomic, readwrite) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, readwrite) NSManagedObjectContext *managedObjectContext;

- (void)contextDidSave:(NSNotification*)notification;
@end

@implementation GVCDataOperation

@synthesize managedObjectContext;
@synthesize contextDidSaveBlock;
@synthesize persistentStoreCoordinator;

- initForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	self = [super init];
	if (self != nil) 
	{
        [self setPersistentStoreCoordinator:coordinator];
	}
	return self;
}

- (void)initializeCoreData
{
    GVC_ASSERT([self isExecuting] == YES, @"Should only be called when the operation is executing");
    GVC_ASSERT([self persistentStoreCoordinator] != nil, @"Persistent Store Coordinator is not set");
    GVC_ASSERT(managedObjectContext == nil, @"ManagedObjectContext is already initialized");
    
	[self setManagedObjectContext:[[NSManagedObjectContext alloc] init]];
	[[self managedObjectContext] setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:[self managedObjectContext]];
}

- (void)saveContext
{
    NSError *moError = nil;
    if (([[self managedObjectContext] hasChanges] == YES) && ([[self managedObjectContext] save:&moError] == NO))
    {
        GVC_ASSERT_LOG(@"Save failed: %@\n%@", [moError localizedDescription], [moError userInfo]);
        [self operationDidFailWithError:moError];
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
	GVC_ASSERT(managedObjectContext != nil, @"Managed Object Context is not initialized, use method -initializeCoreData in -main" );
	return managedObjectContext;
}

- (GVC_Operation_Type)operationType
{
	return GVC_Operation_Type_CORE_DATA;
}

- (void)contextDidSave:(NSNotification*)notification 
{
	[self performSelectorOnMainThread:@selector(contextDidSaveOnMainThread:) withObject:notification waitUntilDone:[NSThread isMainThread]];
}

- (void)contextDidSaveOnMainThread:(NSNotification*)notification 
{
    GVC_ASSERT( [NSThread isMainThread] == YES, @"Should only be called on main thread" );
    
    if ( nil != contextDidSaveBlock )
    {
        contextDidSaveBlock(self, notification);
    }
}

- (NSEntityDescription *)entityForName:(NSString *)name
{
	return [NSEntityDescription entityForName:name inManagedObjectContext:[self managedObjectContext]];
}

@end
