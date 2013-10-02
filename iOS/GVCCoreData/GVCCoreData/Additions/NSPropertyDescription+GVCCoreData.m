/*
 * NSPropertyDescription+GVCCoreData.m
 * 
 * Created by David Aspinall on 12-05-07. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "NSPropertyDescription+GVCCoreData.h"
#import "GVCFoundation.h"

@implementation NSPropertyDescription (GVCCoreData)

- (NSString *)gvc_localizedName
{
    NSDictionary *dictionary = [[[self entity] managedObjectModel] localizationDictionary];

    // get the general use label
    NSString *generalKey = GVC_SPRINTF(@"Property/%@", [self name]);
    NSString *generalName = [dictionary objectForKey:generalKey];

    // get the specific use label
    NSString *specificKey = GVC_SPRINTF(@"Property/%@/Entity/%@", [self name], [[self entity] name]);
    NSString *specificName = [dictionary objectForKey:specificKey];

    NSString *localizedName = specificName;
    if ( gvc_IsEmpty(localizedName) == YES )
    {
        localizedName = generalName;
        if ( gvc_IsEmpty(localizedName) == YES )
        {
            localizedName = GVC_LocalizedString(specificKey, [self name]);
        }
    }
    return (localizedName ? localizedName : [self name]);
}

@end
