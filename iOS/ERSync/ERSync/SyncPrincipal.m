#import "SyncPrincipal.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

@implementation SyncPrincipal

+ (SyncPrincipal *)pseudoSingletonInContext:(NSManagedObjectContext *)context
{
	NSArray *all = [NSManagedObject gvc_findAllObjects:[self entityInManagedObjectContext:context] forKeyValue:nil inContext:context];
	
	return (( [all count] == 1 ) ? [all lastObject] : nil );
}

- (NSString *)formattedLastSync
{
	NSString *fmtted = nil;
	if ( [self lastSync] != nil )
	{
		NSDate *ls = [self lastSync];
		GVCLogError(@"ls %@", ls);
		fmtted = [[self lastSync] gvc_iso8601StringValue];
	}
	return fmtted;
}

@end
