/*
 * GVCXMLParsingModel.h
 * 
 * Created by David Aspinall on 12-03-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

@class GVCStack;

typedef enum
{
	GVC_XML_ContentType_COMMENT,
	GVC_XML_ContentType_ATTRIBUTE,
	GVC_XML_ContentType_PROCESSING,
	GVC_XML_ContentType_TEXT,
	GVC_XML_ContentType_NAMESPACE,
	GVC_XML_ContentType_SIMPLE,
	GVC_XML_ContentType_CONTAINER
} GVC_XML_ContentType;

typedef enum {
	GVC_XML_AttributeType_UNDECLARED = 0,
	GVC_XML_AttributeType_CDATA = 1,
	GVC_XML_AttributeType_ID = 2,
	GVC_XML_AttributeType_IDREF = 3,
	GVC_XML_AttributeType_IDREFS = 4,
	GVC_XML_AttributeType_ENTIRY = 5,
	GVC_XML_AttributeType_ENTITIES = 6,
	GVC_XML_AttributeType_NMTOKEN = 7,
	GVC_XML_AttributeType_NMTOKENS = 8,
	GVC_XML_AttributeType_NOTATION = 9,
	GVC_XML_AttributeType_ENUMERATED = 10
} GVC_XML_AttributeType;


@protocol GVCXMLContent <NSObject>
-(GVC_XML_ContentType)xmlType;
@end

@protocol GVCXMLNamespaceDeclaration <GVCXMLContent>
+ (id <GVCXMLNamespaceDeclaration>)namespaceForPrefix:(NSString *)pfx andURI:(NSString *)u;
- (NSString *)qualifiedPrefix;
- (NSString *)prefix;
- (NSString *)uri;
- (NSString *)qualifiedNameInNamespace:(NSString *)localname;
@end


@protocol GVCXMLTextContent <GVCXMLContent>
@property (readwrite, strong, nonatomic) NSString *text;

- (void)appendText:(NSString *)value;
- (void)appendTextWithFormat:(NSString*)fmt, ...;
- (NSString *)normalizedText;
@end

@protocol GVCXMLNamedContent <NSObject>
@property (readwrite, strong, nonatomic) NSString *localname;
@property (readwrite, strong, nonatomic) id <GVCXMLNamespaceDeclaration> defaultNamespace;

- (NSString *)qualifiedName;
@end

@protocol GVCXMLAttributeContent <GVCXMLNamedContent>
@property (readwrite, strong, nonatomic) NSString *attributeValue;
@property (assign, nonatomic) GVC_XML_AttributeType type;
@end

@protocol GVCXMLNamespaceContent <GVCXMLContent>
- (void)addDeclaredNamespace:(id <GVCXMLNamespaceDeclaration>)v;
- (NSArray *)declaredNamespaces;
@end

@protocol GVCXMLAttributeContainer <GVCXMLContent>
- (NSArray *)attributes;
- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb;
- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns;
- (void)addAttributesFromArray:(NSArray *)attArray;
- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key;
@end



@protocol GVCXMLDocumentTypeDeclaration <GVCXMLContent>
- (void)setElementName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID forInternalSubset:(NSString *)internalSubset;

@property (readwrite, strong, nonatomic) NSString *elementName;
@property (readwrite, strong, nonatomic) NSString *publicID;
@property (readwrite, strong, nonatomic) NSString *systemID;
@property (readwrite, strong, nonatomic) NSString *internalSubset;
@end


@protocol GVCXMLProcessingInstructionsNode <GVCXMLContent>
@property (readwrite, strong, nonatomic) NSString *target;
@property (readwrite, strong, nonatomic) NSString *data;
@end


@protocol GVCXMLCommentNode <GVCXMLContent, GVCXMLTextContent>
@end

@protocol GVCXMLNamedNode <GVCXMLContent, GVCXMLNamedContent, GVCXMLNamespaceContent>
- (NSArray *)attributes;
- (void)addAttribute:(id <GVCXMLAttributeContent>)attrb;
- (void)addAttribute:(NSString *)attrb withValue:(NSString *)attval inNamespace:(id <GVCXMLNamespaceDeclaration>)ns;
- (void)addAttributesFromArray:(NSArray *)attArray;
- (id <GVCXMLAttributeContent>)attributeForName:(NSString *)key;
@end

@protocol GVCXMLContainerNode <GVCXMLContent>
- (NSArray *)children;
- (id <GVCXMLContent>)addContent:(id <GVCXMLContent>) child;
@end


@protocol GVCXMLDocumentNode <GVCXMLContent, GVCXMLContainerNode>
@property (readwrite, strong, nonatomic) id <GVCXMLDocumentTypeDeclaration> documentType;
@property (readwrite, strong, nonatomic) NSString *baseURL;
@end

