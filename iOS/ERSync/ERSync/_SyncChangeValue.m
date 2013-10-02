// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncChangeValue.m instead.

#import "_SyncChangeValue.h"

GVC_DEFINE_STRVALUE(SyncChangeValue_ENTITY_NAME, SyncChangeValue)

GVC_DEFINE_STRVALUE(SyncChangeValue_Attribute_name, name)
GVC_DEFINE_STRVALUE(SyncChangeValue_Attribute_value, value)
GVC_DEFINE_STRVALUE(SyncChangeValue_Attribute_valueType, valueType)

GVC_DEFINE_STRVALUE(SyncChangeValue_Relationship_changeset, changeset)
GVC_DEFINE_STRVALUE(SyncChangeValue_Relationship_syncEntity, syncEntity)
GVC_DEFINE_STRVALUE(SyncChangeValue_Relationship_toMany, toMany)
GVC_DEFINE_STRVALUE(SyncChangeValue_Relationship_toOne, toOne)

@implementation SyncChangeValueID
@end

@implementation _SyncChangeValue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:SyncChangeValue_ENTITY_NAME inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return SyncChangeValue_ENTITY_NAME;
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:SyncChangeValue_ENTITY_NAME inManagedObjectContext:moc_];
}

- (SyncChangeValueID*)objectID {
	return (SyncChangeValueID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic value;






@dynamic valueType;






@dynamic changeset;

	

@dynamic syncEntity;

	

@dynamic toMany;

	
- (NSMutableSet*)toManySet {
	[self willAccessValueForKey:SyncChangeValue_Relationship_toMany];
	NSMutableSet *result = [self mutableSetValueForKey:SyncChangeValue_Relationship_toMany];
	[self didAccessValueForKey:SyncChangeValue_Relationship_toMany];
	return result;
}
	

@dynamic toOne;

	





@end
