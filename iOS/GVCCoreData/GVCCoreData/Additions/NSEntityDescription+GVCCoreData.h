//
//  NSEntityDescription+GVCCoreData.h
//
//  Created by David Aspinall on 24/08/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>



/**
 * $Date: 2009-09-08 22:51:18 -0400 (Tue, 08 Sep 2009) $
 * $Rev: 36 $
 * $Author: david $
*/
@interface NSEntityDescription (GVCCoreData)

- (NSString *)gvc_localizedName;
- (NSString *)gvc_localizedNameForProperty:(NSString *)propname;

- (NSString *)gvc_localizedErrorString:(NSString *)errorMessage;

- (NSSortDescriptor *)gvc_defaultSortDescriptor;
- (NSPredicate *)gvc_predicateForProperty:(NSString *)key andValue:(NSObject *)val;

- (NSPropertyDescription *)gvc_propertyNamed:(NSString *)attributeName;

- (NSAttributeDescription *)gvc_attributeNamed:(NSString *)attributeName;
- (NSRelationshipDescription *)gvc_relationshipNamed:(NSString *)attributeName;

- (NSAttributeDescription *)gvc_attributeNamedKeypath:(NSString *)attributePath;
- (NSRelationshipDescription *)gvc_relationshipNamedKeypath:(NSString *)relationPath;

- (NSArray *)gvc_allAttributes;
- (NSArray *)gvc_allRelationships;

@end
