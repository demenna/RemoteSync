//
//  GVCManagedObjectTableViewController.m
//  GVCCoreData
//
//  Created by David Aspinall on 12-06-14.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCManagedObjectTableViewController.h"
#import "NSEntityDescription+GVCCoreData.h"

#import "GVCFoundation.h"

@interface GVCManagedObjectTableViewController ()
@property (strong, nonatomic) NSMutableArray *displayModel;
@property (strong, nonatomic, readwrite) NSManagedObject *managedObj;
@end

@implementation GVCManagedObjectTableViewController

@synthesize managedObj;
@synthesize displayModel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self != nil)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark CoreData
- (NSManagedObjectContext *)managedObjectContext
{
	return [managedObj managedObjectContext];
}

- (NSEntityDescription *)entityDescription
{
    return [[self managedObj] entity];
}

- (void)configureForManagedObject:(NSManagedObject *)mo withSections:(NSArray *)sections
{
    [self setManagedObj:mo];
    if ( displayModel == nil )
    {
        [self setDisplayModel:[[NSMutableArray alloc] initWithCapacity:10]];
    }
    
    [[self displayModel] removeAllObjects];
    if ( gvc_IsEmpty(sections) == YES )
    {
        
    }
    else
    {
        [[self displayModel] addObjectsFromArray:sections];
    }
}

- (void)addDisplaySection:(GVCManagedObjectTableViewSection *)section
{
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
    return [[self displayModel] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    GVCManagedObjectTableViewSection *moSection = nil;
    if ( [[self displayModel] count] > section )
    {
        moSection = [[self displayModel] objectAtIndex:section];
    }
	return [moSection sectionName];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
//    NSArray *sectionName = nil;
//    if ( [[self displayModel] count] > section )
//    {
//        sectionName = [[[self displayModel] allKeys] objectAtIndex:section];
//    }
//	return sectionName;
    return 0;
}

@end



@implementation GVCManagedObjectTableViewSection

@synthesize sectionName;
@synthesize properties;

- (id)initWithName:(NSString *)aname
{
    self = [super init];
    if ( self != nil )
    {
        [self setSectionName:aname];
    }
    return self;
}

- (id)initWithName:(NSString *)aname forProperties:(NSArray *)propertyList
{
    self = [super init];
    if ( self != nil )
    {
        [self setSectionName:aname];
        if ( gvc_IsEmpty(propertyList) == NO )
        {
            for (NSObject *propObj in propertyList)
            {
//                if ( [propObj in
            }
        }
    }
    return self;    
}
- (void)addProperty:(NSPropertyDescription *)aProp
{
    if ( properties == nil )
    {
        [self setProperties:[[NSMutableArray alloc] init]];
    }
    [[self properties] addObject:aProp];
}

@end