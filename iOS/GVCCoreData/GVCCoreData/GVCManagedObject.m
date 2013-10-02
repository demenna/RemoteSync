//
//  DAManagedObject.m
//
//  Created by David Aspinall on 13/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCManagedObject.h"
#import "NSManagedObject+GVCCoreData.h"
#import "NSEntityDescription+GVCCoreData.h"

GVC_DEFINE_STRVALUE(GVCManagedObject_SYNC_ID_ATTRIBUTE		, gvcSyncId);
GVC_DEFINE_STRVALUE(GVCManagedObject_SYNC_SRC_ATTRIBUTE		, gvcSyncSource);

GVC_DEFINE_STRVALUE(GVCManagedObject_NAME_ATTRIBUTE			, name);
GVC_DEFINE_STRVALUE(GVCManagedObject_SORT_ORDER_ATTRIBUTE	, sortOrder);

GVC_DEFINE_STRVALUE(GVCManagedObject_UUID_ATTRIBUTE			, uuid);
GVC_DEFINE_STRVALUE(GVCManagedObject_CREATED_DATE_ATTRIBUTE	, createdDate);
GVC_DEFINE_STRVALUE(GVCManagedObject_UPDATED_DATE_ATTRIBUTE	, updatedDate);

/**
 * $Date: 2009-01-20 16:28:51 -0500 (Tue, 20 Jan 2009) $
 * $Rev: 121 $
 * $Author: david $
*/
@implementation GVCManagedObject

- (id)init
{
	self = [super init];
	if (self != nil)
	{
	}
	return self;
}

/** Implementation */

- (void)awakeFromInsert
{
	[super awakeFromInsert];
	
	if ( [[self entity] gvc_attributeNamed:GVCManagedObject_CREATED_DATE_ATTRIBUTE] != nil )
	{
		[self setValue:[NSDate date] forKey:GVCManagedObject_CREATED_DATE_ATTRIBUTE];
	}

	if ( [[self entity] gvc_attributeNamed:GVCManagedObject_UUID_ATTRIBUTE] != nil )
	{
		[self setValue:[NSString gvc_StringWithUUID] forKey:GVCManagedObject_UUID_ATTRIBUTE];
	}
}

@end
