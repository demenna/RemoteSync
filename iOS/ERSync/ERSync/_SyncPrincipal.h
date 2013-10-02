// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncPrincipal.h instead.

#import <CoreData/CoreData.h>
#import "GVCFoundation.h"

#import "GVCManagedObject.h"

GVC_DEFINE_EXTERN_STR(SyncPrincipal_ENTITY_NAME)


GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_lastSync)

GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_password)

GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_principalId)

GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_site)

GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_username)

GVC_DEFINE_EXTERN_STR(SyncPrincipal_Attribute_uuid)











@interface SyncPrincipalID : NSManagedObjectID {}
@end

@interface _SyncPrincipal : GVCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SyncPrincipalID*)objectID;



@property (nonatomic, strong) NSDate* lastSync;

//- (BOOL)validateLastSync:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* password;

//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* principalId;

//- (BOOL)validatePrincipalId:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* site;

//- (BOOL)validateSite:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;





@end

@interface _SyncPrincipal (CoreDataGeneratedAccessors)

@end

@interface _SyncPrincipal (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveLastSync;
- (void)setPrimitiveLastSync:(NSDate*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSString*)primitivePrincipalId;
- (void)setPrimitivePrincipalId:(NSString*)value;




- (NSString*)primitiveSite;
- (void)setPrimitiveSite:(NSString*)value;




- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;




- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;




@end
