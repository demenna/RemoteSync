//
//  SyncXMLProperty.m
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "SyncXMLProperty.h"

#import "GVCFoundation.h"
#import "SyncXMLStatus.h"

@implementation SyncXMLProperty

@synthesize name;
@synthesize value;
@synthesize relations;


- (void)addRelation:(NSObject *)val
{
	if ( relations == nil )
	{
		[self setRelations:[NSMutableArray arrayWithCapacity:1]];
	}
	[relations addObject:val];
}

- (NSString *)description
{
	return GVC_SPRINTF(@"%@ [%@] %@", name, value, relations);
}


@end
