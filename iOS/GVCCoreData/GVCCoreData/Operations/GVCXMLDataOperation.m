/*
 * GVCXMLDataOperation.m
 * 
 * Created by David Aspinall on 12-05-07. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCXMLDataOperation.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

@interface GVCDataLoadXMLNode : NSObject
@property (strong, nonatomic) NSString *name;
@end

@interface AttributeNode : GVCDataLoadXMLNode
@property (strong, nonatomic) NSString *text;
@end

@interface PredicateNode : GVCDataLoadXMLNode
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *targetAttributeName;
@end


@interface RelationshipNode : GVCDataLoadXMLNode
@property (strong, nonatomic) NSMutableArray *predicates;
- (void)addPredicate:(AttributeNode *)node;
@end

@interface EntityNode : GVCDataLoadXMLNode
@property (strong, nonatomic) NSString *action;
@property (strong, nonatomic) NSMutableArray *attributes;
@property (strong, nonatomic) NSMutableArray *relationships;
- (AttributeNode *)gvcSyncId;
- (BOOL)isDeleteAction;
- (void)addAttribute:(AttributeNode *)node;
- (void)addRelationship:(RelationshipNode *)node;
@end


@interface GVCXMLDataOperation ()
- (void)processEntityNode:(EntityNode *)node;
- (NSManagedObject *)insertRecord:(NSManagedObjectContext *)context forEntity:(EntityNode *)obj;
- (NSManagedObject *)findManagedObjectFor:(EntityNode *)entity;
- (void)updateRecord:(NSManagedObject *)mo withEntity:(EntityNode *)obj;
- (NSManagedObject *)targetObject:(NSRelationshipDescription *)relation inRelationship:(RelationshipNode *)relNode;
@end

@implementation GVCXMLDataOperation

@synthesize loadFile;

- (id)initForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator usingFile:(NSString *)file;
{
	self = [super initForPersistentStoreCoordinator:coordinator];
	if ( self != nil )
	{
        [self setLoadFile:file];
	}
	
    return self;
}

- (void)main
{
	[self initializeCoreData];
    
	[super operationDidStart];
	
	GVCXMLDigester *digest = [[GVCXMLDigester alloc] init];
	[digest addRule:[GVCXMLDigesterRule ruleForCreateObject:@"EntityNode"] forNodeName:@"entity"];
	[digest addRule:[GVCXMLDigesterRule ruleForAttributeMapKeysAndValues:@"name", @"name", @"action", @"action", nil] forNodeName:@"entity"];
	
	[digest addRule:[GVCXMLDigesterRule ruleForCreateObject:@"AttributeNode"] forNodeName:@"attribute"];
	[digest addRule:[GVCXMLDigesterRule ruleForParentChild:@"attribute"] forNodeName:@"attribute"];
	[digest addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"text"] forNodeName:@"attribute"];
	[digest addRule:[GVCXMLDigesterRule ruleForAttributeMapKeysAndValues:@"name", @"name", nil] forNodeName:@"attribute"];
	
	[digest addRule:[GVCXMLDigesterRule ruleForCreateObject:@"RelationshipNode"] forNodeName:@"relationship"];
	[digest addRule:[GVCXMLDigesterRule ruleForParentChild:@"relationship"] forNodeName:@"relationship"];
	[digest addRule:[GVCXMLDigesterRule ruleForAttributeMapKeysAndValues:@"name", @"name", nil] forNodeName:@"relationship"];
	
	[digest addRule:[GVCXMLDigesterRule ruleForCreateObject:@"PredicateNode"] forNodeName:@"predicate"];
	[digest addRule:[GVCXMLDigesterRule ruleForParentChild:@"predicate"] forNodeName:@"predicate"];
	[digest addRule:[GVCXMLDigesterRule ruleForSetPropertyText:@"text"] forNodeName:@"predicate"];
	[digest addRule:[GVCXMLDigesterRule ruleForAttributeMapKeysAndValues:@"type", @"type", @"attribute", @"targetAttributeName", nil] forNodeName:@"predicate"];
	
	[digest setFilename:[self loadFile]];
	[digest parse];
	
	NSObject *digestResults = [digest digestValueForPath:@"data/entity"];
	if ( [digestResults isKindOfClass:[NSArray class]] == YES )
	{
		NSUInteger idx = 0;
		NSArray *castArray = (NSArray *)digestResults;
		for (EntityNode *node in castArray )
		{
			idx ++;
//			[self setProgressPercent:(idx*100)/[castArray count]];
			[self processEntityNode:node];
		}
	}
	else if ( [digestResults isKindOfClass:[EntityNode class]] == YES )
	{
		[self processEntityNode:(EntityNode *)digestResults];
	}
	else
	{
		GVC_ASSERT_LOG( @"Did not parse a valid object %@", digestResults );
	}
	
	[self operationDidFinish];
}

- (void)processEntityNode:(EntityNode *)node
{
	NSManagedObject *mo = [self findManagedObjectFor:node];
	
	if ( [node isDeleteAction] == NO )
	{
		if ( mo == nil )
		{
			mo = [self insertRecord:[self managedObjectContext] forEntity:node];
		}
		
		[self updateRecord:mo withEntity:node];
	}
	else if ( mo != nil )
	{
		[[self managedObjectContext] deleteObject:mo];
	}
    
	NSError *error = nil;
	if ([[self managedObjectContext] hasChanges] == YES)
	{
		if ([[self managedObjectContext] save:&error] == NO)
		{
			[self operationDidFailWithError:error];
			GVC_ASSERT_LOG(@"Save failed: %@\n%@", [error localizedDescription], [error userInfo]);
		} 
	}
}

- (NSManagedObject *)insertRecord:(NSManagedObjectContext *)context forEntity:(EntityNode *)obj
{
	return [NSEntityDescription insertNewObjectForEntityForName:[obj name] inManagedObjectContext:[self managedObjectContext]];
}

- (NSManagedObject *)findManagedObjectFor:(EntityNode *)entity
{
	NSMutableDictionary *qualifier = [NSMutableDictionary dictionaryWithCapacity:[[entity attributes] count]];
	
	AttributeNode *syncId = [entity gvcSyncId];
	if ( syncId != nil )
	{
		[qualifier setValue:[syncId text] forKey:GVCManagedObject_SYNC_ID_ATTRIBUTE];
	}
	else
	{
		for (AttributeNode *attNode in [entity attributes])
		{
			[qualifier setValue:[attNode text] forKey:[attNode name]];
		}
	}
	
	NSEntityDescription *entDesc = [self entityForName:[entity name]];
	
	return [NSManagedObject gvc_findObject:entDesc forKeyValue:qualifier inContext:[self managedObjectContext]];
}

- (void)updateRecord:(NSManagedObject *)mo withEntity:(EntityNode *)obj
{
	for (AttributeNode *attNode in [obj attributes])
	{
		[mo gvc_setConvertedValue:[attNode text] forKey:[attNode name]];
	}
	
	for (RelationshipNode *relNode in [obj relationships])
	{
		NSRelationshipDescription *desc = [[mo entity] gvc_relationshipNamed:[relNode name]];
		if ( desc != nil )
		{
			// find the destination object for the relationship
			NSManagedObject *mymo = [self targetObject:desc inRelationship:relNode];
			if ( mymo != nil )
			{
				NSString *selectorName = nil;
				SEL selector = nil;
                
				if ([desc isToMany] == YES)
				{
					selectorName = GVC_SPRINTF( @"add%@Object:", [[desc name] gvc_StringWithCapitalizedFirstCharacter] );
					selector = NSSelectorFromString(selectorName);
					if ( [mo respondsToSelector:selector] == YES )
					{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
						[mo performSelector:selector withObject:mymo];
#pragma clang diagnostic pop
					}
				}
				else
				{
					[mo setValue:mymo forKey:[desc name]];
				}
			}
		}
	}
}

- (NSManagedObject *)targetObject:(NSRelationshipDescription *)relation inRelationship:(RelationshipNode *)relNode
{
	NSEntityDescription *entity = [relation destinationEntity];
	NSMutableDictionary *qualifier = [NSMutableDictionary dictionaryWithCapacity:0];
	
	for (PredicateNode *predNode in [relNode predicates])
	{
		[qualifier setValue:[predNode text] forKey:[predNode targetAttributeName]];
	}
	
	return [NSManagedObject gvc_findObject:entity forKeyValue:qualifier inContext:[self managedObjectContext]];
}

@end


@implementation GVCDataLoadXMLNode
@synthesize name;
@end

@implementation AttributeNode
@synthesize text;
@end

@implementation PredicateNode
@synthesize text;
@synthesize type;
@synthesize targetAttributeName;
@end


@implementation RelationshipNode
@synthesize predicates;
- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		[self setPredicates:[NSMutableArray arrayWithCapacity:0]];
	}
	return self;
}
- (void)addPredicate:(AttributeNode *)node
{
	[predicates addObject:node];
}
@end

@implementation EntityNode
@synthesize action;
@synthesize attributes;
@synthesize relationships;

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		[self setAttributes:[NSMutableArray arrayWithCapacity:0]];
		[self setRelationships:[NSMutableArray arrayWithCapacity:0]];
	}
	return self;
}
- (AttributeNode *)gvcSyncId
{
	AttributeNode *gvcSyncNode = nil;
	for (AttributeNode *attNode in attributes)
	{
		if ( [[attNode name] isEqualToString:GVCManagedObject_SYNC_ID_ATTRIBUTE] == YES )
		{
			gvcSyncNode = attNode;
			break;
		}
	}
	return gvcSyncNode;
}

- (BOOL)isDeleteAction
{
	return ((gvc_IsEmpty(action) == NO) && ([[action lowercaseString] isEqualToString:@"delete"] == YES));
}

- (void)addAttribute:(AttributeNode *)node;
{
	[attributes addObject:node];
}
- (void)addRelationship:(RelationshipNode *)node;
{
	[relationships addObject:node];
}

- (NSString *)description
{
    return GVC_SPRINTF(@"%@ name='%@'", [super description], [self name]);
}
@end
