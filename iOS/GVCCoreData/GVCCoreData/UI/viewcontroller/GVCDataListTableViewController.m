//
//  DACoreDataTableViewController.m
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDataListTableViewController.h"
#import "GVCFoundation.h"
#import "GVCCoreData.h"

@implementation GVCDataListTableViewController

@synthesize fetchedResultsController;
@synthesize allowsListEdit;
@synthesize allowsListInsert;

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) 
	{
		[self setAllowsListEdit:YES];
		[self setAllowsListInsert:YES];
	}
	return self;
}

#pragma mark -
#pragma mark View lifecycle


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


- (void)configureNewObject:(NSManagedObject *)obj
{
	GVC_SUBCLASS_RESPONSIBLE;
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

- (void)navigateToEditDetailViewFor:(NSManagedObject *)obj
{
}


- (void)navigateToDetailViewFor:(NSManagedObject *)obj
{
}

- (void)navigateToAccessoryViewFor:(NSManagedObject *)obj
{
}

- (UITableViewCell *)configuredCellForTableView:(UITableView *)tv andData:(NSManagedObject *)obj
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

- (void)viewDidLoad 
{
    [super viewDidLoad];    
}

- (void)viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
    [self reload:self];
}

- (void)viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	
	// Set up the edit and add buttons.
    if ([self navigationItem] != nil)
	{
		if (([self isListEditable] == YES) || ([self isListInsertable] == YES))
			[[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
	}
}
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

- (UIBarButtonItem *)addButtonItem
{
	return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewObject:)];
}


#pragma mark -
#pragma mark Add a new object

- (IBAction)addNewObject:(id)sender
{
	if ( [self isListInsertable] == YES )
	{
		[self navigateToDetailViewFor:[self insertNewObject]];
	}
}

- (NSManagedObject *)insertNewObjectForSection:(id <NSFetchedResultsSectionInfo> )section
{
	NSManagedObject *newObj = [self insertNewObject];
	if ( section != nil )
	{
		
	}
	return newObj;
}

- (NSManagedObject *)insertNewObject 
{
	// Create a new instance of the entity managed by the fetched results controller.
	NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
	NSEntityDescription *entity = [[[self fetchedResultsController] fetchRequest] entity];
	NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
	
	// If appropriate, configure the new managed object.
	[self configureNewObject:newManagedObject];
	
	// Save the context.
//    NSError *error = nil;
//	DAAssert(![context save:&error], @"Save failed: %@\n%@", [error localizedDescription], [error userInfo]);
	
	return newManagedObject;
}


#pragma mark -
#pragma mark editing toggle
- (void)setEditing:(BOOL)editing animated:(BOOL)animated 
{
	if (([self allowsListEdit] == YES) || ([self allowsListInsert] == YES))
	{
		[super setEditing:editing animated:animated];
		
		if ( [self navigationItem] != nil )
			[[self navigationItem] setHidesBackButton:editing animated:YES];
		
		if ( [self allowsListInsert] == YES )
		{
			NSArray *sections = [[self fetchedResultsController] sections];
			NSInteger sectionCount = [sections count];
			NSMutableArray *addPaths = [NSMutableArray arrayWithCapacity:sectionCount];
			
			for ( NSInteger cnt = 0; cnt < sectionCount ; cnt ++ )
			{
				id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:cnt];
				NSIndexPath *addPath = [NSIndexPath indexPathForRow:[sectionInfo numberOfObjects] inSection:cnt];
				[addPaths addObject:addPath];
			}
			
			[[self tableView] beginUpdates];
			if (editing == YES) 
			{
				[[self tableView] insertRowsAtIndexPaths:addPaths withRowAnimation:UITableViewRowAnimationTop];
			}
			else 
			{
				[[self tableView] deleteRowsAtIndexPaths:addPaths withRowAnimation:UITableViewRowAnimationTop];
			}
			
			[[self tableView] endUpdates];
		}
		
		[[self tableView] setEditing:editing];
		[[self tableView] setAllowsSelectionDuringEditing:YES];
	}
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

    UITableViewCell *cell = nil;
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
			
			cell = [self configuredCellForTableView:tableView andData:managedObject];
			if ( cell == nil )
			{
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) 
				{
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				}
				[[cell textLabel] setText:[managedObject description]];
			}
		}
		else
		{
			cell = [self configuredCellForTableView:tableView andData:nil];
			if ( cell == nil )
			{
				cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (cell == nil) 
				{
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				}

				NSString *addCellTitle = [self tableView:tableView titleForHeaderInSection:[indexPath section]];
				if ( gvc_IsEmpty(addCellTitle) == YES )
					addCellTitle = [self rootEntityName];
				
				NSString *addName = GVC_LocalizedClassString(addCellTitle ,@"ADD" );
				[[cell textLabel] setText:GVC_LocalizedString( addName, @"Add" )];
			}
		}
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	if ( [self isValidIndexPathForFetch:indexPath] == YES )
	{
		if ( [self isEditing] == YES )
		{
			[self navigateToEditDetailViewFor:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
		}
		else
		{
			[self navigateToDetailViewFor:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
		}
	}
	else
	{
		id <NSFetchedResultsSectionInfo> sectionInfo = [[[self fetchedResultsController] sections] objectAtIndex:[indexPath section]];
		[self setEditing:NO animated:YES];
		NSManagedObject *newObj = [self insertNewObjectForSection:sectionInfo];
		[self navigateToEditDetailViewFor:newObj];
	}
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	if ( [self isValidIndexPathForFetch:indexPath] == YES )
	{
		[self navigateToAccessoryViewFor:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
	}
}

- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
	{
        // Delete the managed object for the given index path
		NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
		[context deleteObject:[[self fetchedResultsController] objectAtIndexPath:indexPath]];
		
		// Save the context.
		NSError *error = nil;
		if (![context save:&error]) 
		{
			/*
			 Replace this implementation with code to handle the error appropriately.
			 
			 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
			 */
			GVCLogInfo(@"Unresolved error %@, %@", error, [error userInfo]);
			abort();
		}
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) 
	{
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
		NSEntityDescription *entity = [[[self fetchedResultsController] fetchRequest] entity];
		NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
		
		// If appropriate, configure the new managed object.
		[self configureNewObject:newManagedObject];
		[self navigateToDetailViewFor:newManagedObject];
	}
}

- (BOOL)isListEditable
{
	return allowsListEdit;
}

- (BOOL)isListInsertable
{
	return allowsListInsert;
}

- (BOOL)isValidIndexPathForFetch:(NSIndexPath *)indexPath
{
	BOOL valid = NO;
	NSFetchedResultsController *fetch = [self fetchedResultsController];
	NSInteger secCount = [[fetch sections] count];

	if ( [indexPath section] < secCount )
	{
		// in a valid section
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetch sections] objectAtIndex:[indexPath section]];
		NSInteger rowCount = [sectionInfo numberOfObjects];
		
		if ( [indexPath row] < rowCount )
		{
			valid = YES;
		}
	}
	return valid;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tv editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	
	// No editing style if not editing or the index path is nil.
    if ([self isEditing] == YES)
	{
		// Determine the editing style based on whether the cell is a placeholder for adding content or already 
		// existing content. Existing content can be deleted.
		if ( [self isValidIndexPathForFetch:indexPath] == YES )
		{
			style = UITableViewCellEditingStyleDelete;
		}
		else 
		{
			style = UITableViewCellEditingStyleInsert;
		}
	}
    return style;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // The table view should not be re-orderable.
    return NO;
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

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
	// Relinquish ownership of any cached data, images, etc that aren't in use.
}


@end
