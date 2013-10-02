//
//  NSManagedObjectContext+GVCCoreData.m
//
//  Created by David Aspinall on 13/05/08.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "NSManagedObjectContext+GVCCoreData.h"
#import "GVCFoundation.h"


@implementation NSManagedObjectContext(GVCCoreData)

- (NSManagedObject *)gvc_objectWithURI:(NSURL *)uri
{
	NSManagedObject *mobj = nil;
    NSManagedObjectID *objectID = [[self persistentStoreCoordinator] managedObjectIDForURIRepresentation:uri];
    
    if (objectID != nil)
    {
		NSManagedObject *objectForID = [self objectWithID:objectID];
		if ([objectForID isFault] == false)
		{
			mobj = objectForID;
		}
		else
		{
			NSFetchRequest *request = [[NSFetchRequest alloc] init];
			[request setEntity:[objectID entity]];
			
			NSPredicate *predicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForEvaluatedObject] rightExpression:[NSExpression expressionForConstantValue:objectForID] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:0];
			[request setPredicate:predicate];
			
			NSArray *results = [self executeFetchRequest:request error:nil];
			if ( [results count] > 0 )
			{
				mobj = [results objectAtIndex:0];
			}
		}
    }
    

    return mobj;
}


- (NSFetchRequest *)gvc_fetchRequestForEntityName:(NSString *)anEntity
{
	NSEntityDescription *entity = [NSEntityDescription entityForName:anEntity inManagedObjectContext:self];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	return request;
}

- (NSSet *)gvc_fetchObjectsForEntityName:(NSString *)newEntityName withPredicate:(id)stringOrPredicate, ...
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:newEntityName inManagedObjectContext:self];
	
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (stringOrPredicate != nil)
    {
        NSPredicate *predicate;
        if ([stringOrPredicate isKindOfClass:[NSString class]])
        {
            va_list variadicArguments;
            va_start(variadicArguments, stringOrPredicate);
            predicate = [NSPredicate predicateWithFormat:stringOrPredicate arguments:variadicArguments];
            va_end(variadicArguments);
        }
        else if ([stringOrPredicate isKindOfClass:[NSPredicate class]])
        {
            predicate = (NSPredicate *)stringOrPredicate;
        }
		else
		{
			GVC_ASSERT([stringOrPredicate isKindOfClass:[NSPredicate class]], @"Second parameter passed to %s is of unexpected class %@", sel_getName(_cmd), GVC_CLASSNAME(stringOrPredicate));
		}
        [request setPredicate:predicate];
    }
	
    NSError *error = nil;
    NSArray *results = [self executeFetchRequest:request error:&error];
    if (error != nil)
    {
        [NSException raise:NSGenericException format:@"%@", [error description]];
    }
    
    return [NSSet setWithArray:results];
}

@end
