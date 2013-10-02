#import "_SyncEntity.h"

@interface SyncEntity : _SyncEntity {}

+ (SyncEntity *)entityForUUID:(NSString *)uid context:(NSManagedObjectContext *)context;
+ (SyncEntity *)entityForURI:(NSString *)uri context:(NSManagedObjectContext *)context;
+ (SyncEntity *)entityForURL:(NSURL *)uri context:(NSManagedObjectContext *)context;
+ (SyncEntity *)entityForNSManagedObjectID:(NSManagedObjectID *)id context:(NSManagedObjectContext *)context;

- (NSManagedObject *)businessObject;
- (void)setBusinessObject:(NSManagedObject *)obj;

- (SyncChangeValue *)findOrCreateChangeValueFor:(NSPropertyDescription *)prop;

@end
