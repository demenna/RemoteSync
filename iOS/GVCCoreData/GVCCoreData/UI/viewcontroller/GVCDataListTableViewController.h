//
//  DACoreDataTableViewController.h
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GVCUIKit.h"

@interface GVCDataListTableViewController : GVCUITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL allowsListEdit;
@property (nonatomic, assign) BOOL allowsListInsert;

- (NSManagedObjectContext *)managedObjectContext;

- (NSString *)rootEntityName;
- (NSString *)sectionKeypath;
- (NSString *)labelKey;
- (NSString *)detailKey;
- (NSString *)indexKey;

- (NSPredicate *)filterPredicate;
- (void)setFilterPredicate:(NSPredicate *)predicate;

- (NSArray *)sortDescriptors;

- (BOOL)isListEditable;
- (BOOL)isListInsertable;
- (BOOL)isValidIndexPathForFetch:(NSIndexPath *)indexPath;

- (UITableViewCell *)configuredCellForTableView:(UITableView *)tv andData:(NSManagedObject *)obj;

- (NSManagedObject *)insertNewObject;
- (NSManagedObject *)insertNewObjectForSection:(id <NSFetchedResultsSectionInfo> )section;
- (void)configureNewObject:(NSManagedObject *)obj;

- (void)navigateToDetailViewFor:(NSManagedObject *)obj;

- (IBAction)addNewObject:(id)sender;

@end
