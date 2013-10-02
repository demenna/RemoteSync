/*
 * GVCUIViewSearchableTableController.h
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GVCUIKit.h"

@interface GVCUIViewSearchableTableController : GVCUIViewWithTableController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (assign, nonatomic) BOOL searchIsActive;
@property (strong, nonatomic) NSArray *filteredListContent;

- (NSManagedObjectContext *)managedObjectContext;

- (NSString *)rootEntityName;
- (NSString *)sectionKeypath;
- (NSString *)labelKey;
- (NSString *)detailKey;
- (NSString *)indexKey;

- (NSPredicate *)filterPredicate;
- (void)setFilterPredicate:(NSPredicate *)predicate;

- (NSArray *)sortDescriptors;

#pragma mark - Search
- (NSArray *)scopeKeys;

@end
