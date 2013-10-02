#import "_SyncChangeValue.h"

@interface SyncChangeValue : _SyncChangeValue {}

- (void)setValueForObject:(NSManagedObject *)mo andAttribute:(NSAttributeDescription *)prop;

- (void)setValueForObject:(NSManagedObject *)mo andToOne:(NSRelationshipDescription *)prop;

- (void)setValueForObject:(NSManagedObject *)mo andToMany:(NSRelationshipDescription *)prop;

@end
