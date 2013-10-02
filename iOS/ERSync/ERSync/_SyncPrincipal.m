// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncPrincipal.m instead.

#import "_SyncPrincipal.h"

GVC_DEFINE_STRVALUE(SyncPrincipal_ENTITY_NAME, SyncPrincipal)

GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_lastSync, lastSync)
GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_password, password)
GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_principalId, principalId)
GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_site, site)
GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_username, username)
GVC_DEFINE_STRVALUE(SyncPrincipal_Attribute_uuid, uuid)


@implementation SyncPrincipalID
@end

@implementation _SyncPrincipal

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:SyncPrincipal_ENTITY_NAME inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return SyncPrincipal_ENTITY_NAME;
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:SyncPrincipal_ENTITY_NAME inManagedObjectContext:moc_];
}

- (SyncPrincipalID*)objectID {
	return (SyncPrincipalID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic lastSync;






@dynamic password;






@dynamic principalId;






@dynamic site;






@dynamic username;






@dynamic uuid;










@end
