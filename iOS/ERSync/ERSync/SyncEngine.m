//
//  SyncEngine.m
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "SyncEngine.h"

//#import "GVCFoundation.h"
//#import "GVCCoreData.h"

#import "SyncEntity.h"
#import "SyncChangeset.h"
#import "SyncChangeValue.h"

@interface SyncEngine ()
@property (strong, nonatomic) NSMutableArray *syncEntities;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSOperationQueue *queue;
@end

@implementation SyncEngine

@synthesize active;
@synthesize syncEntities;
@synthesize managedObjectContext;
@synthesize queue;

- (id)initWithEditingContext:(NSManagedObjectContext *)context
{
    self = [super init];
    if (self) 
	{
		active = YES;
		
			// our own MOC
		[self setManagedObjectContext:[[NSManagedObjectContext alloc] init]];
		[[self managedObjectContext] setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
		
		[self setSyncEntities:[[NSMutableArray alloc] initWithCapacity:10]];

			// but we listen to the user's mo
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:) name:NSManagedObjectContextDidSaveNotification object:context];
    }
    return self;
}

- (void)addSupportedEntity:(NSString *)entityName
{
	[syncEntities addObject:entityName];
}

- (NSArray *)syncEntities
{
	return syncEntities;
}


- (SyncChangeset *)processDeleted:(NSSet *)changes inChangeset:(SyncChangeset *)set
{
	for (NSManagedObject *mo in changes)
	{
		NSEntityDescription *nsEntityDesc = [mo entity];
		if ( [syncEntities containsObject:[nsEntityDesc name]] == YES )
		{
			SyncEntity *existing = [SyncEntity entityForNSManagedObjectID:[mo objectID] context:managedObjectContext];
			if ( existing == nil )
			{
				NSURL *oidURL = [[mo objectID] URIRepresentation];
				existing = [SyncEntity insertInManagedObjectContext:managedObjectContext];
				[existing setDataToken:[oidURL absoluteString]];		
				[existing setName:[nsEntityDesc name]];
			}

			[existing setStatus:@"delete"];
			[existing setUpdatedDate:[NSDate date]];

			if (gvc_IsEmpty([existing changes]) == NO)
			{
				for ( SyncChangeValue *cv in [existing changes] )
				{
					[managedObjectContext deleteObject:cv];
				}
			}
			[managedObjectContext save:nil];
		}
	}
	return set;
}

- (SyncChangeset *)processInserted:(NSSet *)changes inChangeset:(SyncChangeset *)set
{
		// first pass, ensure we have SyncEntities for all inserted records
	for (NSManagedObject *mo in changes)
	{
		NSEntityDescription *nsEntityDesc = [mo entity];
		if ( [syncEntities containsObject:[nsEntityDesc name]] == YES )
		{
			if ( set == nil )
			{
				set = [SyncChangeset insertInManagedObjectContext:managedObjectContext];
				[set setUpdatedDate:[NSDate date]];
			}
			
			SyncEntity *existing = [SyncEntity entityForNSManagedObjectID:[mo objectID] context:managedObjectContext];
			if ( existing == nil )
			{
				NSURL *oidURL = [[mo objectID] URIRepresentation];
				existing = [SyncEntity insertInManagedObjectContext:managedObjectContext];
				[existing setStatus:@"insert"];
				[existing setDataToken:[oidURL absoluteString]];		
				[existing setName:[nsEntityDesc name]];
				[existing setUpdatedDate:[NSDate date]];
			}
		}
	}

	for (NSManagedObject *mo in changes)
	{
		NSEntityDescription *nsEntityDesc = [mo entity];
		if ( [syncEntities containsObject:[nsEntityDesc name]] == YES )
		{
			SyncEntity *existing = [SyncEntity entityForNSManagedObjectID:[mo objectID] context:managedObjectContext];
			for (NSPropertyDescription *prop in [nsEntityDesc properties])
			{
				SyncChangeValue *cv = [existing findOrCreateChangeValueFor:prop];
				[cv setChangeset:set];
				if ( [prop isKindOfClass:[NSAttributeDescription class]] == YES )
				{
						// 
					[cv setValueForObject:mo andAttribute:(NSAttributeDescription *)prop];
				}
				else
				{
					NSRelationshipDescription *rel = (NSRelationshipDescription *)prop;
					if ( [rel isToMany] == NO )
					{
						[cv setValueForObject:mo andToOne:rel];
					}
					else
					{
						[cv setValueForObject:mo andToMany:rel];
					}
				}
			}
			[managedObjectContext save:nil];
		}
	}
	return set;
}

- (SyncChangeset *)processUpdated:(NSSet *)changes inChangeset:(SyncChangeset *)set
{
	for (NSManagedObject *mo in changes)
	{
		NSEntityDescription *nsEntityDesc = [mo entity];
		if ( [syncEntities containsObject:[nsEntityDesc name]] == YES )
		{
			if ( set == nil )
			{
				set = [SyncChangeset insertInManagedObjectContext:managedObjectContext];
				[set setUpdatedDate:[NSDate date]];
					//				[set setUuid:[NSString stringWithUUID]];
			}
			
			SyncEntity *existing = [SyncEntity entityForNSManagedObjectID:[mo objectID] context:managedObjectContext];
			if ( existing == nil )
			{
				NSURL *oidURL = [[mo objectID] URIRepresentation];
				existing = [SyncEntity insertInManagedObjectContext:managedObjectContext];
				[existing setDataToken:[oidURL absoluteString]];		
					//[existing setUuid:[NSString stringWithUUID]];
				[existing setName:[nsEntityDesc name]];
				[existing setUpdatedDate:[NSDate date]];
			}
			[existing setStatus:@"update"];
			
			for (NSPropertyDescription *prop in [nsEntityDesc properties])
			{
				SyncChangeValue *cv = [existing findOrCreateChangeValueFor:prop];
				[cv setChangeset:set];
				if ( [prop isKindOfClass:[NSAttributeDescription class]] == YES )
				{
						// 
					[cv setValueForObject:mo andAttribute:(NSAttributeDescription *)prop];
				}
				else
				{
					NSRelationshipDescription *rel = (NSRelationshipDescription *)prop;
					if ( [rel isToMany] == NO )
					{
						[cv setValueForObject:mo andToOne:rel];
					}
					else
					{
						[cv setValueForObject:mo andToMany:rel];
					}
				}
			}
			[managedObjectContext save:nil];
		}
	}
	return set;
}
- (void)contextDidSave:(NSNotification*)notification 
{
	if ( active == YES )
	{
		SyncChangeset *set = nil;
		NSDictionary *info = [notification userInfo];
		
		set = [self processDeleted:[info valueForKey:@"deleted"] inChangeset:set];
		set = [self processInserted:[info valueForKey:@"inserted"] inChangeset:set];
		set = [self processUpdated:[info valueForKey:@"updated"] inChangeset:set];
	}
}


#pragma mark - sync initiation methods

@end
