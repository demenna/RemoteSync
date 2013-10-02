#import "SyncChangeValue.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

#import "SyncEntity.h"

@implementation SyncChangeValue


- (void)setValueForObject:(NSManagedObject *)mo andAttribute:(NSAttributeDescription *)prop
{
	NSObject *aval = [mo valueForKey:[prop name]];
	
	if ( aval == nil )
	{
		[self setValue:@"null"];
	}
	switch ( [prop attributeType] )
	{
		case NSInteger16AttributeType:
		case NSInteger32AttributeType:
		case NSInteger64AttributeType:
		case NSDecimalAttributeType:
		case NSDoubleAttributeType:
		case NSFloatAttributeType:
			[self setValue:(NSString *)[aval description]];
			[self setValueType:@"N"];
			break;
		case NSStringAttributeType:
			[self setValue:(NSString *)aval];
			[self setValueType:@"S"];
			break;
		case NSBooleanAttributeType:
				//			[[self setValue:[aval boolValue] ? @"true" : @"false"] ];
			[self setValue:(NSString *)[aval description]];
			[self setValueType:@"B"];
			break;
		case NSDateAttributeType:
			[self setValue:[(NSDate *)aval gvc_iso8601StringValue]];
			[self setValueType:@"T"];
			break;
		case NSBinaryDataAttributeType:
			[self setValueType:@"X"];
			break;
		case NSTransformableAttributeType:
			[self setValueType:@"X"];
			break;
		case NSObjectIDAttributeType:
			[self setValueType:@"X"];
			break;
			
	}
}

- (void)setValueForObject:(NSManagedObject *)mo andToOne:(NSRelationshipDescription *)prop
{
	NSManagedObject *destination = [mo valueForKey:[prop name]];
	SyncEntity *ent = [SyncEntity entityForNSManagedObjectID:[destination objectID] context:[self managedObjectContext]];
	[self setValue:nil];
	[self setToOne:ent];
	[self setValueType:@"O"];
}

- (void)setValueForObject:(NSManagedObject *)mo andToMany:(NSRelationshipDescription *)prop
{
	NSSet *destArray = [mo valueForKey:[prop name]];
	for (NSManagedObject *destination in destArray)
	{
		SyncEntity *ent = [SyncEntity entityForNSManagedObjectID:[destination objectID] context:[self managedObjectContext]];
		if ( [[self toMany] containsObject:ent] == NO )
			[self addToManyObject:ent];
	}
	
	[self setValue:nil];
	[self setValueType:@"M"];
}

@end
