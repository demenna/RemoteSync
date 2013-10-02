/*
 * GVCUIViewSearchableTableController.m
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUIViewSearchableTableController.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

@implementation GVCUIViewSearchableTableController

@synthesize fetchedResultsController;
@synthesize searchBar;
@synthesize filteredListContent;
@synthesize searchIsActive;

#pragma mark -
#pragma mark View lifecycle
- (void)viewDidLoad 
{
    [super viewDidLoad];    
    
	[[self searchBar] setShowsCancelButton:YES];  
}

- (NSEntityDescription *)rootEntity
{
	GVC_ASSERT([self rootEntityName] != nil, @"Root entity name is not specified" );
	return [NSEntityDescription entityForName:[self rootEntityName] inManagedObjectContext:[self managedObjectContext]];
}

- (NSString *)rootEntityName
{
	GVC_SUBCLASS_RESPONSIBLE;
	return nil;
}

- (NSString *)viewTitleKey
{
	return [self rootEntityName];
}

- (NSArray *)sortDescriptors
{
	NSMutableArray *sort = nil; 
	
	sort = [NSMutableArray arrayWithCapacity:3];
	
	if (([self sectionKeypath] != nil) && ([[self rootEntity] gvc_attributeNamed:[self sectionKeypath]] != nil))
	{
        NSSortDescriptor *lblDescriptor = [[NSSortDescriptor alloc] initWithKey:[self sectionKeypath] ascending:YES];
		[sort addObject:lblDescriptor];
	}
	
	if (([self labelKey] != nil) && ([[self rootEntity] gvc_attributeNamed:[self labelKey]] != nil))
	{
        NSSortDescriptor *lblDescriptor = [[NSSortDescriptor alloc] initWithKey:[self labelKey] ascending:YES];
		[sort addObject:lblDescriptor];
	}
	
	if (([self detailKey] != nil) && ([[self rootEntity] gvc_attributeNamed:[self detailKey]] != nil))
	{
		NSSortDescriptor *lblDescriptor = [[NSSortDescriptor alloc] initWithKey:[self detailKey] ascending:YES];
		[sort addObject:lblDescriptor];
	}	
	
	return ([sort count] > 0 ? sort : nil);
}

- (NSPredicate *)filterPredicate
{
	return nil;
}

- (NSString *)sectionKeypath
{
	return nil;
}

- (NSString *)labelKey
{
	return nil;
}

- (NSString *)detailKey
{
	return nil;
}

- (NSString *)indexKey
{
	return nil;
}

- (NSManagedObjectContext *)managedObjectContext
{
	NSManagedObjectContext *managedObjectContext = nil;
    
    id <UIApplicationDelegate> appdel = [[UIApplication sharedApplication] delegate];
    if ( [appdel isKindOfClass:[GVCCoreDataUIAppDelegate class]] == YES )
    {
        managedObjectContext = [(GVCCoreDataUIAppDelegate *)appdel managedObjectContext];
	}
	return managedObjectContext;
}

#pragma mark -
#pragma mark Table view methods

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	NSArray *indexList = nil;
	if ( [self sectionKeypath] != nil )
	{
		indexList = [[self fetchedResultsController] sectionIndexTitles];
	}
	return indexList;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)idx
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:idx];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
	NSInteger count = [[[self fetchedResultsController] sections] count];
	if (([self isEditing] == YES) && (count == 0))
		count++;
    
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	NSArray *list = [[self fetchedResultsController] sections];
	NSInteger rowCount = 0;
	if ( section < [list count] )
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [list objectAtIndex:section];
		rowCount = [sectionInfo numberOfObjects];
	}
    return rowCount + ([self isEditing] ? 1 : 0);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	NSArray *list = [[self fetchedResultsController] sections];
	NSString *secName = nil;
	if ( section < [list count] )
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [list objectAtIndex:section];
		secName = [sectionInfo name];
	}
	else if ( [self isEditing] == YES )
	{
		secName = GVC_LocalizedClassString([self rootEntityName], @"ADD" );
	}
    
    return secName;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"CoreDataTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == [self tableView]) 
    {
        // normal table view population
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    else if (tableView == [[self searchDisplayController] searchResultsTableView])
    {
        // search view population
        if (cell == nil) 
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }

	NSInteger secCount = [[[self fetchedResultsController] sections] count];
	
	if ( [indexPath section] < secCount )
	{
		// in a valid section
		id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:[indexPath section]];
		NSInteger rowCount = [sectionInfo numberOfObjects];
		
		if ( [indexPath row] < rowCount )
		{
			// valid row
			// Configure the cell.
			NSManagedObject *managedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [[cell textLabel] setText:[managedObject description]];
		}
	}
	
    return cell;
}

#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController 
{
    if (([self rootEntityName] != nil) && (fetchedResultsController == nil)) 
	{
		/*
		 Set up the fetched results controller.
		 */
		// Create the fetch request for the entity.
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		// Edit the entity name as appropriate.
		NSEntityDescription *entity = [NSEntityDescription entityForName:[self rootEntityName] inManagedObjectContext:[self managedObjectContext]];
		[fetchRequest setEntity:entity];
		
		// Set the batch size to a suitable number.
		[fetchRequest setFetchBatchSize:20];
		
		// Edit the sort key as appropriate.
		NSArray *sortDescriptors = [self sortDescriptors];
		if ( sortDescriptors == nil )
		{
			NSObject *defaultSort = [entity gvc_defaultSortDescriptor];
			if ( defaultSort != nil )
			{
				sortDescriptors = [NSArray arrayWithObject:defaultSort];
			}
		}
        
		if ( sortDescriptors != nil )
			[fetchRequest setSortDescriptors:sortDescriptors];
		
		NSPredicate *predicate = [self filterPredicate];
		if ( predicate != nil )
			[fetchRequest setPredicate:predicate];
		
		// Edit the section name key path and cache name if appropriate.
		// nil for section name key path means "no sections".
		//NSString *cacheName = NSStringFromClass([self class]);
        //		[NSFetchedResultsController c];
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:[self sectionKeypath] cacheName:nil];
		aFetchedResultsController.delegate = self;
		[self setFetchedResultsController:aFetchedResultsController];
		
		NSError *error = nil;
		if ([fetchedResultsController performFetch:&error] == NO) 
		{
			GVCLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
		}
		
    }
    
	return fetchedResultsController;
}    

- (void)setFilterPredicate:(NSPredicate *)predicate;
{
	[[[self fetchedResultsController] fetchRequest] setPredicate:predicate];
	
	NSError *error = nil;
	if ([[self fetchedResultsController] performFetch:&error] == NO) 
	{
		GVCLogError(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);
	}           
	[self.tableView reloadData];
}


// NSFetchedResultsControllerDelegate method to notify the delegate that all section and object changes have been processed. 
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller 
{
	// In the simplest, most efficient, case, reload the table view.
	[[self tableView] reloadData];
}

#pragma mark - Search methods
- (NSArray *)scopeKeys
{
	return nil;
}

#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [NSFetchedResultsController deleteCacheWithName:GVC_CLASSNAME(self)];
	if (gvc_IsEmpty(searchString) == NO )
	{
        if ( gvc_IsEmpty([[self searchBar] scopeButtonTitles]) == NO)
        {
            // simple case, use the scope keys to create a predicate
            NSString *scopeKp = [[self scopeKeys] objectAtIndex:[[self searchBar] selectedScopeButtonIndex]];

            [[[self fetchedResultsController] fetchRequest] setPredicate:[NSPredicate predicateWithFormat:@"%K contains[cd] %@", scopeKp, searchString]];
        }
        else if ( gvc_IsEmpty([self scopeKeys]) == NO )
        {
            NSMutableArray *predArray = [[NSMutableArray alloc] initWithCapacity:3];
            for (NSString *kp in [self scopeKeys])
            {
                [predArray addObject:[NSPredicate predicateWithFormat:@"%K contains[cd] %@", kp, searchString]];
            }
            
            [[[self fetchedResultsController] fetchRequest] setPredicate:[NSCompoundPredicate orPredicateWithSubpredicates:predArray]];
        }
        else if ( gvc_IsEmpty([self labelKey]) == NO )
        {
            [[[self fetchedResultsController] fetchRequest] setPredicate:[NSPredicate predicateWithFormat:@"%K contains[cd] %@", [self labelKey], searchString]];
        }
        else 
        {
            GVC_ASSERT(NO, @"Unable to filter search, no scope or label keypaths");
        }
		
		NSError *error = nil;
		if ([[self fetchedResultsController] performFetch:&error] == NO) 
		{
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);
		}           
	}
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    return [self searchDisplayController:controller shouldReloadTableForSearchString:[[self searchBar] text]];
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller 
{
	self.searchIsActive = YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller 
{
	self.searchIsActive = NO;
	[self setFilterPredicate:[self filterPredicate]];
}

@end
