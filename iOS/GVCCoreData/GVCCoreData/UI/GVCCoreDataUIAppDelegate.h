/*
 * GVCCoreDataUIAppDelegate.h
 * 
 * Created by David Aspinall on 12-04-12. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUIKit.h"
#import "GVCDataOperation.h"

@interface GVCCoreDataUIAppDelegate : GVCUIApplicationDelegate

@property (nonatomic, strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSArray *)modelLoadedOperations:(NSString *)name;

/* NSNotification contains changes to be saved in main thead */
- (void)saveContext;
- (void)mergeChanges:(NSNotification*)notification;
- (GVCDataSavedOperationBlock)defaultOperationDidSaveBlock;

@end
