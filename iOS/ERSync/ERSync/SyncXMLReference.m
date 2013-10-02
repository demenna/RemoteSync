//
//  SyncXMLReference.m
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "SyncXMLReference.h"

#import "GVCFoundation.h"
#import "SyncXMLStatus.h"

@implementation SyncXMLReference

@synthesize recordName;
@synthesize updatedDateString;
@synthesize recordStatus;
@synthesize recordUUID;

- (NSDate *)updatedDate
{
	return [SyncXMLStatus dateFromString:updatedDateString];
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ [recordUUID=%@] [recordStatus=%@] [updatedDate=%@]", recordName, recordUUID, recordStatus, updatedDateString);
}

@end
