// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncChangeValue.h instead.

#import <CoreData/CoreData.h>
#import "GVCFoundation.h"

#import "GVCManagedObject.h"

GVC_DEFINE_EXTERN_STR(SyncChangeValue_ENTITY_NAME)


GVC_DEFINE_EXTERN_STR(SyncChangeValue_Attribute_name)

GVC_DEFINE_EXTERN_STR(SyncChangeValue_Attribute_value)

GVC_DEFINE_EXTERN_STR(SyncChangeValue_Attribute_valueType)


GVC_DEFINE_EXTERN_STR(SyncChangeValue_Relationship_changeset)

GVC_DEFINE_EXTERN_STR(SyncChangeValue_Relationship_syncEntity)

GVC_DEFINE_EXTERN_STR(SyncChangeValue_Relationship_toMany)

GVC_DEFINE_EXTERN_STR(SyncChangeValue_Relationship_toOne)


@class SyncChangeset;
@class SyncEntity;
@class SyncEntity;
@class SyncEntity;





@interface SyncChangeValueID : NSManagedObjectID {}
@end

@interface _SyncChangeValue : GVCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SyncChangeValueID*)objectID;



@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* value;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* valueType;

//- (BOOL)validateValueType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) SyncChangeset* changeset;
//- (BOOL)validateChangeset:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) SyncEntity* syncEntity;
//- (BOOL)validateSyncEntity:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSSet* toMany;
- (NSMutableSet*)toManySet;



@property (nonatomic, strong) SyncEntity* toOne;
//- (BOOL)validateToOne:(id*)value_ error:(NSError**)error_;




@end

@interface _SyncChangeValue (CoreDataGeneratedAccessors)

- (void)addToMany:(NSSet*)value_;
- (void)removeToMany:(NSSet*)value_;
- (void)addToManyObject:(SyncEntity*)value_;
- (void)removeToManyObject:(SyncEntity*)value_;

@end

@interface _SyncChangeValue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;




- (NSString*)primitiveValueType;
- (void)setPrimitiveValueType:(NSString*)value;





- (SyncChangeset*)primitiveChangeset;
- (void)setPrimitiveChangeset:(SyncChangeset*)value;



- (SyncEntity*)primitiveSyncEntity;
- (void)setPrimitiveSyncEntity:(SyncEntity*)value;



- (NSMutableSet*)primitiveToMany;
- (void)setPrimitiveToMany:(NSMutableSet*)value;



- (SyncEntity*)primitiveToOne;
- (void)setPrimitiveToOne:(SyncEntity*)value;


@end
