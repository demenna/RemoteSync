// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncChangeset.m instead.

#import "_SyncChangeset.h"

GVC_DEFINE_STRVALUE(SyncChangeset_ENTITY_NAME, SyncChangeset)

GVC_DEFINE_STRVALUE(SyncChangeset_Attribute_updatedDate, updatedDate)
GVC_DEFINE_STRVALUE(SyncChangeset_Attribute_uuid, uuid)

GVC_DEFINE_STRVALUE(SyncChangeset_Relationship_changes, changes)

@implementation SyncChangesetID
@end

@implementation _SyncChangeset

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:SyncChangeset_ENTITY_NAME inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return SyncChangeset_ENTITY_NAME;
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:SyncChangeset_ENTITY_NAME inManagedObjectContext:moc_];
}

- (SyncChangesetID*)objectID {
	return (SyncChangesetID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic updatedDate;






@dynamic uuid;






@dynamic changes;

	
- (NSMutableSet*)changesSet {
	[self willAccessValueForKey:SyncChangeset_Relationship_changes];
	NSMutableSet *result = [self mutableSetValueForKey:SyncChangeset_Relationship_changes];
	[self didAccessValueForKey:SyncChangeset_Relationship_changes];
	return result;
}
	





@end
