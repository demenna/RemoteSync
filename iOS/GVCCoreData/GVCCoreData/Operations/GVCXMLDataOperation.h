/*
 * GVCXMLDataOperation.h
 * 
 * Created by David Aspinall on 12-05-07. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCDataOperation.h"

@interface GVCXMLDataOperation : GVCDataOperation

- (id)initForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator usingFile:(NSString *)file;

@property (strong, nonatomic) NSString *loadFile;

@end
