//
//  SyncXMLReference.h
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncXMLReference : NSObject 

@property (strong, nonatomic) NSString *updatedDateString;
- (NSDate *)updatedDate;

@property (strong, nonatomic) NSString *recordName;
@property (strong, nonatomic) NSString *recordStatus;
@property (strong, nonatomic) NSString *recordUUID;

@end
