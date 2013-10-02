//
//  NSManagedObjectContext+GVCCoreData.h
//
//  Created by David Aspinall on 13/05/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NSManagedObjectContext(GVCCoreData)

- (NSManagedObject *)gvc_objectWithURI:(NSURL *)uri;

- (NSFetchRequest *)gvc_fetchRequestForEntityName:(NSString *)anEntity;

- (NSSet *)gvc_fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...;

@end
