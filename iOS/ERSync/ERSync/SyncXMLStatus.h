//
//  SyncXMLStatus.h
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-28.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncXMLStatus : NSObject

+ (NSDate *)dateFromString:(NSString *)string;

@property (strong, nonatomic) NSString *principalUUID;
@property (strong, nonatomic) NSString *lastSyncString;
- (NSDate *)lastSync;

@end
