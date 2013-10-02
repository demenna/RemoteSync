//
//  NSManagedObject+GVCCoreData.h
//
//  Created by David Aspinall on 07/09/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


/**
 * $Date: 2009-09-08 22:51:18 -0400 (Tue, 08 Sep 2009) $
 * $Rev: 36 $
 * $Author: david $
*/
@interface NSManagedObject (GVCCoreData)

+ (NSArray *)gvc_findAllObjects:(NSEntityDescription *)entity forPredicate:(NSPredicate *)pred inContext:(NSManagedObjectContext *)context;
+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forPredicate:(NSPredicate *)pred inContext:(NSManagedObjectContext *)context;

+ (NSArray *)gvc_findAllObjects:(NSEntityDescription *)entity forKeyValue:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forKey:(NSString *)key andValue:(id)value inContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)gvc_findObject:(NSEntityDescription *)entity forKeyValue:(NSDictionary *)dict inContext:(NSManagedObjectContext *)context;

- (void)gvc_setConvertedValue:(id)value forKey:(NSString *)key;

- (BOOL)gvc_canBeDeleted;

- (NSSet *)gvc_relatedSet:(NSString *)relation withKey:(NSString *)thisKey andValue:(id)thisValue;

- (NSManagedObject *)gvc_relatedObject:(NSString *)relation withKey:(NSString *)thisKey andValue:(id)thisValue;

- (NSString *)gvc_uppercaseFirstLetterOfAttribute:(NSString *)keypath;

- (NSArray *)gvc_sortedRelationshipForKey:(NSString *)key;

@end
