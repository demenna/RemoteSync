//
//  NSManagedObject+GVCCoreData.m
//
//  Created by David Aspinall on 07/09/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "NSManagedObject+GVCCoreData.h"
#import "NSEntityDescription+GVCCoreData.h"

#import "GVCFoundation.h"
#import "GVCManagedObject.h"

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation NSManagedObject (GVCCoreData)

- (void)gvc_setConvertedValue:(id)value forKey:(NSString *)key
{
	GVC_ASSERT( [self entity] != nil, @"No Entity" );
	GVC_ASSERT( [self managedObjectContext] != nil, @"No MOC" );
		
	NSAttributeDescription *attrDesc = [[self entity] gvc_attributeNamed:key];
	
	if ( attrDesc != nil )
	{
		if ((value == nil) || ([value isKindOfClass:[NSNull class]] == true ))
		{
			[self setValue:[NSNull null] forKey:[attrDesc name]];
		}
		else 
		{
			NSNumber *num = nil;
			GVCISO8601DateFormatter *fmt = nil;
			NSDate *date = nil;
			switch ([attrDesc attributeType])
			{
				case NSInteger16AttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSInteger32AttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSInteger64AttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSDecimalAttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSDoubleAttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSFloatAttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(intValue)] == YES)
					{
						num = [NSNumber numberWithInt:[value intValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSStringAttributeType:
						[self setValue:[value description] forKey:[attrDesc name]];
						break;
				case NSBooleanAttributeType:
					if ( [value isKindOfClass:[NSNumber class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(boolValue)] == YES)
					{
						num = [NSNumber numberWithBool:[value boolValue]];
						[self setValue:num forKey:[attrDesc name]];
					}
					break;
				case NSDateAttributeType:
					if ( [value isKindOfClass:[NSDate class]] == YES )
					{
						[self setValue:num forKey:[attrDesc name]];
					}
					else if ( [value respondsToSelector:@selector(date)] == YES)
					{
						[self setValue:[value date] forKey:[attrDesc name]];
					}
					else
					{
						fmt = [[GVCISO8601DateFormatter alloc] init];
						date = [fmt dateFromString:[value description]];
						[self setValue:date forKey:[attrDesc name]];
					}

					break;
				case NSBinaryDataAttributeType:
//					if ( [value isKindOfClass:[NSNumber class]] == YES )
//					{
//						[self setValue:num forKey:[attrDesc name]];
//					}
//					else if ( [value respondsToSelector:@selector(intValue)] == YES)
//					{
//						num = [NSNumber numberWithInt:[value intValue]];
//						[self setValue:num forKey:[attrDesc name]];
//					}
					break;
				default:
					break;
			}
		}
	}
}

+ (NSArray *)gvc_findAllObjects:(NSEntityDescription *)entity forPredicate:(NSPredicate *)pred inContext:(NSManagedObjectContext *)context
{
	GVC_ASSERT(entity != nil, @"Entity is required");
	GVC_ASSERT(context != nil, @"Context is required");

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	[request setPredicate:pred];
	
	NSError *error = nil;
	NSArray *array = [context executeFetchRequest:request error:&error];
	if (error != nil) 
	{
		GVCLogError( @"Error %@", error );
	}
	return array;
}

+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forPredicate:(NSPredicate *)pred inContext:(NSManagedObjectContext *)context
{
	NSManagedObject *mo = nil;

	NSArray *array = [NSManagedObject gvc_findAllObjects:entity forPredicate:pred inContext:context];
	if (gvc_IsEmpty(array) == NO) 
	{
		GVC_ASSERT([array count] == 1, @"Found more than one object matching %@", pred);
		mo = [array objectAtIndex:0];
	}
	
	return mo;	
}


+ (NSArray *)gvc_findAllObjects:(NSEntityDescription *)entity forKeyValue:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
	NSPredicate *pred = nil;
	if ( gvc_IsEmpty(dict) == NO )
	{
		if ( [dict count] == 1 )
		{
			NSString *key = [[dict allKeys] lastObject];
			NSObject *value = [dict valueForKey:key];
			NSAttributeDescription *desc = [entity gvc_attributeNamedKeypath:key];
			
			GVC_ASSERT( desc != nil, @"Failed to find attribute named %@ on entity %@", key, [entity name] );
			if ([desc attributeType] == NSStringAttributeType)
			{
				pred = [NSPredicate predicateWithFormat:@"%K LIKE[c] %@", key, value];
			}
			else
			{
				pred = [NSPredicate predicateWithFormat:@"%K == %@", key, value];
			}
		}
		else
		{
			NSMutableArray *qualifier = [NSMutableArray arrayWithCapacity:[dict count]];
			
			NSArray *keyArray = [dict allKeys];
			for (NSString *key in keyArray)
			{
				NSObject *value = [dict valueForKey:key];
				NSAttributeDescription *desc = [entity gvc_attributeNamedKeypath:key];
				
				GVC_ASSERT( desc != nil, @"Failed to find attribute named %@", key );
				if ([desc attributeType] == NSStringAttributeType)
				{
					[qualifier addObject:[NSPredicate predicateWithFormat:@"%K LIKE[c] %@", key, value]];
				}
				else
				{
					[qualifier addObject:[NSPredicate predicateWithFormat:@"%K == %@", key, value]];
				}
			}
			
			pred = [NSCompoundPredicate andPredicateWithSubpredicates:qualifier];
		}
	}

	return [NSManagedObject gvc_findAllObjects:entity forPredicate:pred inContext:context];
}

+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forKey:(NSString *)key andValue:(id)value inContext:(NSManagedObjectContext *)context
{
	NSDictionary *keyVal = [NSDictionary dictionary];
	if ( key != nil )
	{
		if ( value == nil )
			keyVal = [NSDictionary dictionaryWithObject:[NSNull null] forKey:key];
		else
			keyVal = [NSDictionary dictionaryWithObject:value forKey:key];
	}
	return [NSManagedObject gvc_findObject:entity forKeyValue:keyVal inContext:context];
}

+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forKeyValue:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context
{
	NSManagedObject *mo = nil;
	NSArray *array = [NSManagedObject gvc_findAllObjects:entity forKeyValue:dict inContext:context];
	if (gvc_IsEmpty(array) == NO) 
	{
		GVC_ASSERT([array count] == 1, @"Found more than one object matching %@", dict);
		mo = [array objectAtIndex:0];
	}
	
	return mo;	
}

- (BOOL)gvc_canBeDeleted
{
	if (([[self entity] gvc_attributeNamed:GVCManagedObject_SYNC_ID_ATTRIBUTE] != nil) && ([self valueForKey:GVCManagedObject_SYNC_ID_ATTRIBUTE] != nil))
	{
		return NO;
	}

	return YES;
}

- (NSSet *)gvc_relatedSet:(NSString *)relation withKey:(NSString *)thisKey andValue:(id)thisValue 
{
	NSSet *filtered = nil;

	GVC_ASSERT( (relation != nil), @"No relationship specified [%@]", relation );
	GVC_ASSERT( ([[self entity] gvc_relationshipNamed:relation] != nil), @"Invalid relationship [%@]", relation );

	filtered = [self valueForKey:relation];

	if ( gvc_IsEmpty(thisKey) == NO )
	{
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K=%@", thisKey, thisValue];
		filtered = [filtered filteredSetUsingPredicate:predicate];
	}
	return filtered;
}

- (NSManagedObject *)gvc_relatedObject:(NSString *)relation withKey:(NSString *)thisKey andValue:(id)thisValue
{
	NSSet *filterd = [self gvc_relatedSet:relation withKey:thisKey andValue:thisValue];
	
	GVC_ASSERT([filterd count] <= 1, @"Found multiple records for [%@].%@ = %@", relation, thisKey, thisValue);
	
	return (NSManagedObject *)([filterd count] == 0 ? nil : [filterd anyObject]);
}

- (NSString *)gvc_uppercaseFirstLetterOfAttribute:(NSString *)keypath;
{
	NSAttributeDescription *attDesc = [[self entity] gvc_attributeNamed:keypath];
	NSString *stringIndex = nil;

	if ((attDesc != nil) && ([attDesc attributeType] == NSStringAttributeType))
	{
		NSString *aString = [[self valueForKey:keypath] uppercaseString];
		
		// support UTF-16:
		stringIndex = [aString substringWithRange:[aString rangeOfComposedCharacterSequenceAtIndex:0]];
		
		// OR no UTF-16 support:
		//NSString *stringToReturn = [aString substringToIndex:1];
	}
	
    return stringIndex;
}

- (NSArray *)gvc_sortedRelationshipForKey:(NSString *)key
{
	NSArray *sortedRelationship = nil;
	NSRelationshipDescription *relDesc = [[self entity] gvc_relationshipNamed:key];
	if ((relDesc != nil) && ([relDesc isToMany] == YES))
	{
		NSEntityDescription *destinationEntity = [relDesc destinationEntity];
		sortedRelationship = [(NSSet *)[self valueForKey:key] allObjects];
		
		NSObject *defaultSort = [destinationEntity gvc_defaultSortDescriptor];
		if ( defaultSort != nil )
		{
			sortedRelationship = [sortedRelationship sortedArrayUsingDescriptors:[NSArray arrayWithObject:defaultSort]];
		}
	}

	return sortedRelationship;
}


@end
