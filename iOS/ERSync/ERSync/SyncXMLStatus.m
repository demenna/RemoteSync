//
//  SyncXMLStatus.m
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-28.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "SyncXMLStatus.h"

#import "GVCFoundation.h"

@implementation SyncXMLStatus

+ (NSDate *)dateFromString:(NSString *)string
{
	NSDate *date = nil;
	if ( gvc_IsEmpty(string) == NO )
	{
		date = [NSDate gvc_DateFromISO8601:string];
	}
	return date;
}

@synthesize principalUUID;
@synthesize lastSyncString;

- (NSDate *)lastSync
{
	return [SyncXMLStatus dateFromString:lastSyncString];
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ [principalUUID=%@] [lastSync=%@]", GVC_CLASSNAME(self), principalUUID, lastSyncString);
}
@end
