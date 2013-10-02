/*
 *  DADataFunctions.c
 *
 *  Created by David Aspinall on 10-06-12.
 *  Copyright 2010 Global Village Consulting Inc. All rights reserved.
 *
 */

#include "GVCDataFunctions.h"

/*
 The localized value will default to '<propertyname> <context> for attributes an example
 Accounting_Transaction_name_placeholder = "Name Placeholder"; 
 */
NSString *gvc_DefaultValueForProperty(NSPropertyDescription *property, NSString *contextOfUse)
{
    NSString *defaultValue = nil;
    if ( property != nil )
	{
        if ( gvc_IsEmpty(contextOfUse) == NO )
        {
            defaultValue = GVC_SPRINTF( @"%@ %@", [property name], contextOfUse);
        }
        else
        {
            defaultValue = GVC_SPRINTF( @"%@", [property name]);
        }
	}

    return defaultValue;
}

NSString *gvc_LocalizedPropertyLabelWithDefault(NSPropertyDescription *property, NSString *contextOfUse, NSString *defaultValue)
{
	NSString *key = nil;
	if ( property != nil )
	{
		NSEntityDescription *entity = [property entity];
		key = GVC_DOMAIN_KEY([entity name], [property name]);
        if ( gvc_IsEmpty(contextOfUse) == NO )
        {
            key = GVC_DOMAIN_KEY(key, contextOfUse);
        }
	}
	
	return (key != nil ? GVC_LocalizedString(key, defaultValue) : nil );
}

NSString *gvc_LocalizedPropertyLabelForContext(NSPropertyDescription *property, NSString *context)
{
    return gvc_LocalizedPropertyLabelWithDefault(property, context, gvc_DefaultValueForProperty(property, context));
}

NSString *gvc_LocalizedAttributeLabel(NSAttributeDescription *attribute)
{
	return gvc_LocalizedPropertyLabelForContext(attribute, @"label");
}

NSString *gvc_LocalizedAttributePlaceholder(NSAttributeDescription *attribute)
{
	return gvc_LocalizedPropertyLabelForContext(attribute, @"placeholder");
}

NSString *gvc_LocalizedRelationshipLabel(NSRelationshipDescription *relationship)
{
	return gvc_LocalizedPropertyLabelForContext(relationship, @"label");
}

NSString *gvc_LocalizedRelationshipAddLabel(NSRelationshipDescription *relationship)
{
	return gvc_LocalizedPropertyLabelForContext(relationship, @"add");
}
