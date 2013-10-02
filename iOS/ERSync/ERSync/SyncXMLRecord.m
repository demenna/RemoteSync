//
//  SyncXMLRecord.m
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-28.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "SyncXMLRecord.h"

#import "GVCFoundation.h"
#import "SyncXMLStatus.h"
#import "SyncXMLProperty.h"

@implementation SyncXMLRecord

@synthesize recordName;
@synthesize updatedDateString;
@synthesize recordStatus;
@synthesize recordUUID;
@synthesize attrbutes;

- (NSDate *)updatedDate
{
	return [SyncXMLStatus dateFromString:updatedDateString];
}

- (void)addAttribute:(SyncXMLProperty *)val
{
	if ( attrbutes == nil )
	{
		[self setAttrbutes:[NSMutableDictionary dictionaryWithCapacity:1]];
	}
	[attrbutes setObject:val forKey:[val name]];
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ [recordUUID=%@] [recordStatus=%@] [updatedDate=%@] %@", recordName, recordUUID, recordStatus, updatedDateString, attrbutes);
}

@end
