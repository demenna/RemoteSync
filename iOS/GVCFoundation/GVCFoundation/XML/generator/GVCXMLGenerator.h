/*
 * GVCXMLGenerator.h
 * 
 * Created by David Aspinall on 12-03-06. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCTextGenerator.h"
#import "GVCXMLParsingModel.h"

typedef enum 
{
	GVC_XML_GeneratorFormat_PRESERVE,
	GVC_XML_GeneratorFormat_COMPACT,
	GVC_XML_GeneratorFormat_PRETTY
} GVC_XML_GeneratorFormat;

@interface GVCXMLGenerator : GVCTextGenerator

- initWithWriter:(id <GVCWriter>)wrter;
- initWithWriter:(id <GVCWriter>)wrter andFormat:(GVC_XML_GeneratorFormat)fmt;

- (void)setXmlEncoding:(NSStringEncoding)anEncoding;
- (NSStringEncoding)xmlEncoding;

- (void)openDocumentWithDeclaration:(BOOL)includeDeclaration andEncoding:(BOOL)includeEncoding;
- (void)closeDocument;

- (void)writeDoctype:(NSString *)rootElement identifiers:(NSString *)publicIdentifier system:(NSString *)systemIdentifier;
- (void)writeDoctype:(NSString *)rootElement identifiers:(NSString *)publicIdentifier system:(NSString *)systemIdentifier internalSubset:(NSString *)subset;

- (void)writeProcessingInstruction:(NSString *)target instructions:(NSString *)instructions;

- (void)writeText:(NSString *)text;

- (void)openElement:(NSString *)name;
- (void)openElement:(NSString *)name inlineMode:(BOOL)isInline;
- (void)openElement:(NSString *)name inNamespacePrefix:(NSString *)prefix forURI:(NSString *)uri;
- (void)openElement:(NSString *)name inNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue;

- (void)openElement:(NSString *)name inNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue withAttributeKeyValues:(NSString *)key, ...;
- (void)openElement:(NSString *)name inNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue withAttributes:(NSDictionary *)attributeDict;

- (void)writeElement:(NSString *)name withText:(NSString *)text;
- (void)writeElement:(NSString *)name inNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue withAttributeKeyValues:(NSString *)key, ...;
- (void)writeElement:(NSString *)name inNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue withAttributes:(NSDictionary *)attributeDict;
- (void)writeElement:(NSString *)nodeName withAttributeKey:(NSString *)key value:(NSString *)value;
- (void)writeElement:(NSString *)nodeName withAttributeKey:(NSString *)key value:(NSString *)value text:(NSString *)text;

- (void)appendAttribute:(NSString *)key forValue:(NSString *)value;
- (void)appendAttribute:(NSString *)key inNamespacePrefix:(NSString *)prefix forValue:(NSString *)value;
- (void)declareNamespace:(NSString *)prefix forURI:(NSString *)uri;
- (void)declareNamespace:(id <GVCXMLNamespaceDeclaration>)nmspValue;

- (void)closeElement;

- (void)writeComment:(NSString *)name;

- (void)writeCDATA:(NSString *)text;
- (void)startCDATA;
- (void)endCDATA;

@end
