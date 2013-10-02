//
//  GVCXMLDigester.m
//
//  Created by David Aspinall on 11-02-04.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLDigester.h"

#import "GVCMacros.h"
#import "GVCFunctions.h"
#import "GVCStack.h"
#import "GVCStringWriter.h"
#import "GVCLogger.h"

#import "GVCXMLGenerator.h"
#import "GVCXMLDigesterRule.h"
#import "GVCXMLDigesterRuleManager.h"
#import "GVCXMLDigesterRuleset.h"
#import "GVCXMLDigesterAttributeMapRule.h"
#import "GVCXMLDigesterPairAttributeTextRule.h"

#import "NSDictionary+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "NSArray+GVCFoundation.h"

@interface GVCXMLDigester ()
@property (strong, nonatomic, readwrite) NSMutableDictionary *digestDictionary;
@property (strong, nonatomic) GVCXMLDigesterRuleManager *digestRuleManager;
@property (strong, nonatomic) GVCStack *currentNodeStack;
@end

@implementation GVCXMLDigester

@synthesize digestDictionary;
@synthesize digestRuleManager;
@synthesize currentNodeStack;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		[self setDigestRuleManager:[[GVCXMLDigesterRuleManager alloc] initForDigester:self]];
		[self resetParser];
	}
	return self;
}

+ (GVCXMLDigester *)digesterWithConfiguration:(NSString *)path
{
	GVCXMLDigester *newInstance = nil;
	GVCXMLDigester *irony = [[GVCXMLDigester alloc] init];
	[irony setFilename:path];
	
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigester"] forNodeName:@"digester"];
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObject:@"GVCXMLDigesterRuleset"] forNodeName:@"ruleset"];
	[irony addRule:[GVCXMLDigesterRule ruleForCreateObjectFromAttribute:@"class_type"] forNodeName:@"rule"];
    
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"ruleset"]  forNodeName:@"ruleset"];
	[irony addRule:[GVCXMLDigesterRule ruleForParentChild:@"rule"]  forNodeName:@"rule"];
	
	GVCXMLDigesterAttributeMapRule *rulesetPatternRule = [[GVCXMLDigesterAttributeMapRule alloc] initWithKeysAndValues:@"pattern", @"pattern", @"nodeName", @"nodeName", @"nodePath", @"nodePath", nil];
	[irony addRule:rulesetPatternRule forNodeName:@"ruleset"];
	
	GVCXMLDigesterAttributeMapRule *attrRule = [[GVCXMLDigesterAttributeMapRule alloc] init];
	[attrRule setTryToAssignAll:YES];
	[irony addRule:attrRule forNodeName:@"rule"];
	
	GVCXMLDigesterPairAttributeTextRule *pairRule = [[GVCXMLDigesterPairAttributeTextRule alloc] initWithPropertyName:@"map" andAttributeName:@"attributeName"];
	[irony addRule:pairRule forNodeName:@"map"];
	
	[irony parse];
	if ([irony status] == GVC_XML_ParserDelegateStatus_SUCCESS )
	{
		newInstance = [irony digestValueForPath:@"digester"];
	}
	return newInstance;
}

- (NSArray *)digestKeys
{
    return [digestDictionary allKeys];
}

- (id)digestValueForPath:(NSString *)key
{
	GVC_ASSERT_VALID_STRING( key );
	return [digestDictionary valueForKey:key];
}

- (void)resetParser
{
	[super resetParser];
	
	[self setCurrentNodeStack:[[GVCStack alloc] init]];
	[self setDigestDictionary:[NSMutableDictionary dictionary]];
}

- (void)pushNodeObject:(id)anObject
{
	if ( [currentNodeStack isEmpty] == YES )
	{
		NSString *epath = [self elementPath];
		if ( [digestDictionary objectForKey:epath] != nil )
		{
			NSObject *value = [digestDictionary objectForKey:epath];
			if ( [value isKindOfClass:[NSMutableArray class]] == YES )
				[(NSMutableArray *)value addObject:anObject];
			else
			{
				NSMutableArray *newValue = [NSMutableArray arrayWithObjects:value, anObject, nil];
				[digestDictionary setObject:newValue forKey:[self elementPath]];
			}
		}
		else
		{
			[digestDictionary setObject:anObject forKey:epath];
		}
	}
	
	[currentNodeStack pushObject:anObject];
}

- (id)popNodeObject
{
	return [currentNodeStack popObject];
}

- (id)peekNodeObject
{
	return [currentNodeStack peekObject];
}

- (id)peekNodeObjectAtIndex:(NSUInteger)idx
{
	return [currentNodeStack peekObjectAtIndex:idx];
}

- (NSString *)elementPath
{
	return [[elementNameStack allObjects] componentsJoinedByString:@"/"];
}

/**
 * returns the current text with whitespace trimed from the prefix and suffix .. or nil
 */
- (NSString *)currentTrimmedTextString
{
    NSString  *trimed = [[self currentTextString] gvc_TrimWhitespaceAndNewline];
    return (gvc_IsEmpty(trimed) ? nil : trimed);
}

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
	[super parserDidStartDocument:parser];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
	[super parserDidEndDocument:parser];
	
	// TODO: loop through all rules and send [rule finishDigest];
}

- (NSMutableArray *)rulesForCurrentPath
{
	// check for rules for the current path
	NSArray *path_rules = [[self digestRuleManager] rulesForNodePath:[self elementPath]];
	// check for rules for the current elementName
	NSArray *node_rules = [[self digestRuleManager] rulesForNodeName:[self currentNodeName]];
	// check for patterns
	NSArray *pattern_rules = [[self digestRuleManager] rulesForMatch:[self elementPath]];
    NSMutableArray *rules = [NSMutableArray arrayWithCapacity:2];
    
    if ( gvc_IsEmpty(node_rules) == NO )
    {
        [rules addObjectsFromArray:node_rules];
    }
    if ( gvc_IsEmpty(path_rules) == NO )
    {
        [rules addObjectsFromArray:path_rules];
    }
    if ( gvc_IsEmpty(pattern_rules) == NO )
    {
        [rules addObjectsFromArray:pattern_rules];
    }
    return rules;
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
    {
        NSMutableArray *rules = [self rulesForCurrentPath];
        if ( gvc_IsEmpty(rules) == NO )
        {
            [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:YES];
            for (GVCXMLDigesterRule *rule in rules) 
            {
                [rule didFindCharacters:[self currentTrimmedTextString]];
            }
        }
    }
    
	[super parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
	
    NSMutableArray *rules = [self rulesForCurrentPath];
    if ( gvc_IsEmpty(rules) == NO )
    {
        [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:YES];
		for (GVCXMLDigesterRule *rule in rules) 
		{
			if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
				[rule didFindCharacters:[self currentTrimmedTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didStartElement:elementName attributes:attributeDict];
		}
	}
    else
    {
        GVCLogError(@"No digest rules for node %@", [self elementPath] );
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSMutableArray *rules = [self rulesForCurrentPath];
    if ( gvc_IsEmpty(rules) == NO )
    {
        [rules gvc_sortWithOrderingKey:GVC_PROPERTY(rulePriority) ascending:NO];
		for (GVCXMLDigesterRule *rule in rules)
		{
			if (gvc_IsEmpty([self currentTrimmedTextString]) == NO)
				[rule didFindCharacters:[self currentTrimmedTextString]];
			if (gvc_IsEmpty([self currentCDATA]) == NO)
				[rule didFindCDATA:[self currentCDATA]];
			[rule didEndElement:elementName];
		}
	}

	[super parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodeName:(NSString *)node_name
{
	[[self digestRuleManager] addRule:rule forNodeName:node_name];
}

- (void)addRule:(GVCXMLDigesterRule *)rule forNodePath:(NSString *)node_name
{
	[[self digestRuleManager] addRule:rule forNodePath:node_name];
}

- (void) addRule:(GVCXMLDigesterRule *)rule forPattern:(NSString *)pattern
{
	[[self digestRuleManager] addRule:rule forPattern:pattern];
}

- (void)addRuleset:(GVCXMLDigesterRuleset *)set
{
    if ( gvc_IsEmpty([set nodeName]) == NO )
    {
        [[self digestRuleManager] addRuleList:[set rules] forNodeName:[set nodeName]];
    }
    else if ( gvc_IsEmpty([set nodePath]) == NO )
    {
        [[self digestRuleManager] addRuleList:[set rules] forNodePath:[set nodePath]];
    }
    else
    {
        [[self digestRuleManager] addRuleList:[set rules] forPattern:[set pattern]];
    }
}

- (NSString *)description
{
    GVCStringWriter *stringWriter = [[GVCStringWriter alloc] init];
    GVCXMLGenerator *generator = [[GVCXMLGenerator alloc] initWithWriter:stringWriter andFormat:GVC_XML_GeneratorFormat_PRETTY];
    [generator open];
	[generator openElement:@"digester"];
    [[self digestRuleManager] writeConfiguration:generator];
    
	[generator openElement:@"currentDigest"];
    if ( gvc_IsEmpty(digestDictionary) == NO )
    {
        [generator writeText:[digestDictionary description]];
    }
	[generator closeElement];

    if ( [[self currentNodeStack] count] > 0 )
    {
        [generator openElement:@"currentNodeStack" inNamespace:nil withAttributeKeyValues:@"elementPath", [self elementPath]];
        [generator writeText:[currentNodeStack description]];
        [generator closeElement];
    }

    [generator closeElement];
    
    [generator closeDocument];
    return [stringWriter string];
}

- (void)writeConfiguration:(GVCXMLGenerator *)outputGenerator
{
	[outputGenerator openDocumentWithDeclaration:YES andEncoding:YES];
	[outputGenerator openElement:@"digester"];
    [[self digestRuleManager] writeConfiguration:outputGenerator];
	[outputGenerator closeElement];
    [outputGenerator closeDocument];
}

@end
