// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SyncChangeset.h instead.

#import <CoreData/CoreData.h>
// #import "GVCFoundation.h"

#import "GVCManagedObject.h"

GVC_DEFINE_EXTERN_STR(SyncChangeset_ENTITY_NAME)


GVC_DEFINE_EXTERN_STR(SyncChangeset_Attribute_updatedDate)

GVC_DEFINE_EXTERN_STR(SyncChangeset_Attribute_uuid)


GVC_DEFINE_EXTERN_STR(SyncChangeset_Relationship_changes)


@class SyncChangeValue;




@interface SyncChangesetID : NSManagedObjectID {}
@end

@interface _SyncChangeset : GVCManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SyncChangesetID*)objectID;



@property (nonatomic, strong) NSDate* updatedDate;

//- (BOOL)validateUpdatedDate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, strong) NSString* uuid;

//- (BOOL)validateUuid:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet* changes;
- (NSMutableSet*)changesSet;




@end

@interface _SyncChangeset (CoreDataGeneratedAccessors)

- (void)addChanges:(NSSet*)value_;
- (void)removeChanges:(NSSet*)value_;
- (void)addChangesObject:(SyncChangeValue*)value_;
- (void)removeChangesObject:(SyncChangeValue*)value_;

@end

@interface _SyncChangeset (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveUpdatedDate;
- (void)setPrimitiveUpdatedDate:(NSDate*)value;




- (NSString*)primitiveUuid;
- (void)setPrimitiveUuid:(NSString*)value;





- (NSMutableSet*)primitiveChanges;
- (void)setPrimitiveChanges:(NSMutableSet*)value;


@end
