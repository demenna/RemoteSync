//
//  SyncXMLRecord.h
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-28.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncXMLRecord : NSObject 

@property (strong, nonatomic) NSString *updatedDateString;
- (NSDate *)updatedDate;

@property (strong, nonatomic) NSString *recordName;
@property (strong, nonatomic) NSString *recordStatus;
@property (strong, nonatomic) NSString *recordUUID;
@property (strong, nonatomic) NSMutableDictionary *attrbutes;

- (void)addAttribute:(NSObject *)val;

@end
