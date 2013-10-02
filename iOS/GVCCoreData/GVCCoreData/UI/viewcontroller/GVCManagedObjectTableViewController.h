//
//  GVCManagedObjectTableViewController.h
//
//  Created by David Aspinall on 12-06-14.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "GVCUIKit.h"
#import "GVCUITableViewController.h"

@class GVCManagedObjectTableViewSection;

@interface GVCManagedObjectTableViewController : GVCUITableViewController

@property (strong, nonatomic, readonly) NSManagedObject *managedObj;

- (void)configureForManagedObject:(NSManagedObject *)mo withSections:(NSArray *)sections;

- (NSManagedObjectContext *)managedObjectContext;
- (NSEntityDescription *)entityDescription;

- (void)addDisplaySection:(GVCManagedObjectTableViewSection *)section;

//- (void)groupProperty:(NSString *)propertyName inSection:(NSString *)sectionName;
//- (void)groupAttribute:(NSAttributeDescription *)property inSection:(NSString *)sectionName;
//- (void)groupToOne:(NSRelationshipDescription *)property inSection:(NSString *)sectionName;
//- (void)groupToMany:(NSRelationshipDescription *)property inSection:(NSString *)sectionName;

@end

@interface GVCManagedObjectTableViewSection : NSObject

- (id)initWithName:(NSString *)aname;
- (id)initWithName:(NSString *)aname forProperties:(NSArray *)propertyList;
- (void)addProperty:(NSPropertyDescription *)aProp;

@property (strong, nonatomic) NSString *sectionName;
@property (strong, nonatomic) NSMutableArray *properties;


@end