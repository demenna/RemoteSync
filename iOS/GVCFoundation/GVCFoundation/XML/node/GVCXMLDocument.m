//
//  DAXMLDocument.m
//
//  Created by David Aspinall on 21/01/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCXMLParsingModel.h"

#import "GVCXMLDocType.h"
#import "GVCXMLDocument.h"
#import "GVCXMLGenericNode.h"
#import "GVCXMLNamespace.h"
#import "GVCFunctions.h"
#import "GVCXMLGenerator.h"

#import "GVCStack.h"
#import "NSString+GVCFoundation.h"

@implementation GVCXMLDocument

@synthesize documentType;
@synthesize nodeStack;
@synthesize baseURL;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		nodeStack = [[GVCStack alloc] init];
	}
	return self;
}

-(GVC_XML_ContentType)xmlType
{
	return GVC_XML_ContentType_CONTAINER;
}

- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child
{
	[nodeStack pushObject:child];
	return child;
}

- (id <GVCXMLContent>)addContentNodeFor:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSArray *)attributeList
{
	GVCXMLGenericNode *node = [[GVCXMLGenericNode alloc] init];
	[node setLocalname:elementName];
	[node setDefaultNamespace:[GVCXMLNamespace namespaceForPrefix:[qName gvc_XMLPrefixFromQualifiedName] andURI:namespaceURI]];
	[node addAttributesFromArray:attributeList];
	
	return [self addContent:node];
}

- (NSArray *)children
{
	return [nodeStack allObjects];
}

- (NSString *)description
{
	NSMutableString *buffer = [NSMutableString stringWithFormat:@"<%@>", NSStringFromClass([self class])];

	if ( [self documentType] != nil )
	{
		[buffer appendFormat:@"\n%@", [[self documentType] description]];
	}
	
	NSArray *allChildren = [nodeStack allObjects];
	if ( gvc_IsEmpty(allChildren) == NO )
	{
		[buffer appendString:@"\n"];

		id <GVCXMLContent> child = nil;
		for (child in allChildren)
		{
			[buffer appendString:[child description]];
		}
	}
	[buffer appendString:@"\n"];
	return buffer;
}

@end
