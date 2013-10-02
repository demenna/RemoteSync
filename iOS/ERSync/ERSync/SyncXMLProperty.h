//
//  SyncXMLProperty.h
//  MobileNoteSync
//
//  Created by David Aspinall on 11-06-29.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncXMLProperty : NSObject 

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *value;

@property (strong, nonatomic) NSMutableArray *relations;

- (void)addRelation:(NSObject *)val;

@end
