// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncEntity.m instead.

#import "_SyncEntity.h"

GVC_DEFINE_STRVALUE(SyncEntity_ENTITY_NAME, SyncEntity)

GVC_DEFINE_STRVALUE(SyncEntity_Attribute_dataToken, dataToken)
GVC_DEFINE_STRVALUE(SyncEntity_Attribute_name, name)
GVC_DEFINE_STRVALUE(SyncEntity_Attribute_status, status)
GVC_DEFINE_STRVALUE(SyncEntity_Attribute_updatedDate, updatedDate)
GVC_DEFINE_STRVALUE(SyncEntity_Attribute_uuid, uuid)

GVC_DEFINE_STRVALUE(SyncEntity_Relationship_changes, changes)
GVC_DEFINE_STRVALUE(SyncEntity_Relationship_toManyChanges, toManyChanges)
GVC_DEFINE_STRVALUE(SyncEntity_Relationship_toOneChanges, toOneChanges)

@implementation SyncEntityID
@end

@implementation _SyncEntity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:SyncEntity_ENTITY_NAME inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return SyncEntity_ENTITY_NAME;
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:SyncEntity_ENTITY_NAME inManagedObjectContext:moc_];
}

- (SyncEntityID*)objectID {
	return (SyncEntityID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic dataToken;






@dynamic name;






@dynamic status;






@dynamic updatedDate;






@dynamic uuid;






@dynamic changes;

	
- (NSMutableSet*)changesSet {
	[self willAccessValueForKey:SyncEntity_Relationship_changes];
	NSMutableSet *result = [self mutableSetValueForKey:SyncEntity_Relationship_changes];
	[self didAccessValueForKey:SyncEntity_Relationship_changes];
	return result;
}
	

@dynamic toManyChanges;

	
- (NSMutableSet*)toManyChangesSet {
	[self willAccessValueForKey:SyncEntity_Relationship_toManyChanges];
	NSMutableSet *result = [self mutableSetValueForKey:SyncEntity_Relationship_toManyChanges];
	[self didAccessValueForKey:SyncEntity_Relationship_toManyChanges];
	return result;
}
	

@dynamic toOneChanges;

	
- (NSMutableSet*)toOneChangesSet {
	[self willAccessValueForKey:SyncEntity_Relationship_toOneChanges];
	NSMutableSet *result = [self mutableSetValueForKey:SyncEntity_Relationship_toOneChanges];
	[self didAccessValueForKey:SyncEntity_Relationship_toOneChanges];
	return result;
}
	





@end
