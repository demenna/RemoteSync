#import "SyncEntity.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

#import "SyncChangeValue.h"

@implementation SyncEntity

+ (SyncEntity *)entityForUUID:(NSString *)uid context:(NSManagedObjectContext *)context;
{
	GVC_ASSERT_VALID_STRING(uid);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", SyncEntity_Attribute_uuid, uid];
	
	return (SyncEntity *)[NSManagedObject gvc_findObject:[self entityInManagedObjectContext:context] forPredicate:pred inContext:context];
}

+ (SyncEntity *)entityForURI:(NSString *)uri context:(NSManagedObjectContext *)context;
{
	GVC_ASSERT_VALID_STRING(uri);
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", SyncEntity_Attribute_dataToken, uri];
	
	return (SyncEntity *)[NSManagedObject gvc_findObject:[self entityInManagedObjectContext:context] forPredicate:pred inContext:context];
}

+ (SyncEntity *)entityForURL:(NSURL *)uri context:(NSManagedObjectContext *)context;
{
	return [self entityForURI:[uri absoluteString] context:context];
}

+ (SyncEntity *)entityForNSManagedObjectID:(NSManagedObjectID *)id context:(NSManagedObjectContext *)context;
{
	return [self entityForURL:[id URIRepresentation] context:context];
}

- (NSManagedObject *)businessObject
{
	NSManagedObject *mo = nil;
	@try {
		mo = [[self managedObjectContext] gvc_objectWithURI:[NSURL URLWithString:[self dataToken]]];
	}
	@catch (NSException *exception) 
	{
		GVCLogError(@"Failed to find MO for entity %@", self);
	}
	return mo;
}

- (void)setBusinessObject:(NSManagedObject *)obj
{
	GVC_ASSERT( obj != nil, @"Cannot be nil object");
	GVC_ASSERT( [[obj objectID] isTemporaryID] == NO, @"Cannot be a temporary managed object");
	GVC_ASSERT( [self dataToken] == nil, @"Cannot change a reference");
	
	@try {
		NSURL *oidURL = [[obj objectID] URIRepresentation];
		[self setDataToken:[oidURL absoluteString]];
	}
	@catch (NSException *exception) 
	{
		GVCLogError(@"Failed to find MO for entity %@", self);
	}
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ token=%@ uuid=%@", GVC_CLASSNAME(self), [self dataToken], [self uuid]);
}

- (SyncChangeValue *)findOrCreateChangeValueFor:(NSPropertyDescription *)prop
{
	NSPredicate *namePred = [NSPredicate predicateWithFormat:@"name = %@", [prop name]];
	NSSet *matches = [[self changes] filteredSetUsingPredicate:namePred];
	
	SyncChangeValue *cv = nil;
	if ( [matches count] == 1 )
	{
		cv = [matches anyObject];
	}
	else
	{
		cv = [SyncChangeValue insertInManagedObjectContext:[self managedObjectContext]];
		[cv setName:[prop name]];
		[cv setSyncEntity:self];
			//[cv setValueType:[prop valueType]];
	}
	return cv;
}


@end
