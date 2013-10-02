// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncEntity.h instead.

#import <CoreData/CoreData.h>
#import "GVCFoundation.h"

#import "GVCManagedObject.h"

GVC_DEFINE_EXTERN_STR(SyncEntity_ENTITY_NAME)


GVC_DEFINE_EXTERN_STR(SyncEntity_Attribute_dataToken)

GVC_DEFINE_EXTERN_STR(SyncEntity_Attribute_name)

GVC_DEFINE_EXTERN_STR(SyncEntity_Attribute_status)

GVC_DEFINE_EXTERN_STR(SyncEntity_Attribute_updatedDate)

GVC_DEFINE_EXTERN_STR(SyncEntity_Attribute_uuid)


GVC_DEFINE_EXTERN_STR(SyncEntity_Relationship_changes)

GVC_DEFINE_EXTERN_STR(SyncEntity_Relationship_toManyChanges)

GVC_DEFINE_EXTERN_STR(SyncEntity_Relationship_toOneChanges)


@class SyncChangeValue;
@class SyncChangeValue;
@class SyncChangeValue;







@interface SyncEntityID : NSManagedObjectID {}
@end

@interface _SyncEntity : GVCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SyncEntityID*)objectID;



@property (nonatomic, strong) NSString* dataToken;

//- (BOOL)validateDataToken:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* status;

//- (BOOL)validateStatus:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSDate* updatedDate;

//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* changes;
- (NSMutableSet*)changesSet;



@property (nonatomic, strong) NSSet* toManyChanges;
- (NSMutableSet*)toManyChangesSet;



@property (nonatomic, strong) NSSet* toOneChanges;
- (NSMutableSet*)toOneChangesSet;




@end

@interface _SyncEntity (CoreDataGeneratedAccessors)

- (void)addChanges:(NSSet*)value_;
- (void)removeChanges:(NSSet*)value_;
- (void)addChangesObject:(SyncChangeValue*)value_;
- (void)removeChangesObject:(SyncChangeValue*)value_;

- (void)addToManyChanges:(NSSet*)value_;
- (void)removeToManyChanges:(NSSet*)value_;
- (void)addToManyChangesObject:(SyncChangeValue*)value_;
- (void)removeToManyChangesObject:(SyncChangeValue*)value_;

- (void)addToOneChanges:(NSSet*)value_;
- (void)removeToOneChanges:(NSSet*)value_;
- (void)addToOneChangesObject:(SyncChangeValue*)value_;
- (void)removeToOneChangesObject:(SyncChangeValue*)value_;

@end

@interface _SyncEntity (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveDataToken;
- (void)setPrimitiveDataToken:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveStatus;
- (void)setPrimitiveStatus:(NSString*)value;




- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;




- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;





- (NSMutableSet*)primitiveChanges;
- (void)setPrimitiveChanges:(NSMutableSet*)value;



- (NSMutableSet*)primitiveToManyChanges;
- (void)setPrimitiveToManyChanges:(NSMutableSet*)value;



- (NSMutableSet*)primitiveToOneChanges;
- (void)setPrimitiveToOneChanges:(NSMutableSet*)value;


@end
