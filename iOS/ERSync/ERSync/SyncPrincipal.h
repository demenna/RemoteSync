#import "_SyncPrincipal.h"

@interface SyncPrincipal : _SyncPrincipal {}

+ (SyncPrincipal *)pseudoSingletonInContext:(NSManagedObjectContext *)context;

- (NSString *)formattedLastSync;

@end
