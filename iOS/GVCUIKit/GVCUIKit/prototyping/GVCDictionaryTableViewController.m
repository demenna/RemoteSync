//
//  DemoTableDictionaryController.m
//
//  Created by David Aspinall on 10-02-24.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDictionaryTableViewController.h"

GVC_DEFINE_STRVALUE( GVCDictionaryTableViewController_image, image);
GVC_DEFINE_STRVALUE( GVCDictionaryTableViewController_label, label);
GVC_DEFINE_STRVALUE( GVCDictionaryTableViewController_note, note);
GVC_DEFINE_STRVALUE( GVCDictionaryTableViewController_id, ident);

@implementation GVCDictionaryTableViewController

@synthesize demoData;

+ (NSString *)imageKey
{
	return GVCDictionaryTableViewController_image;
}

+ (NSString *)labelKey
{
	return GVCDictionaryTableViewController_label;
}

+ (NSString *)noteKey
{
	return GVCDictionaryTableViewController_note;
}

+ (NSString *)identityKey
{
	return GVCDictionaryTableViewController_id;
}


- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super initWithStyle:style];
	if (self != nil) 
	{
	}
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	if ( [self demoData] == nil )
		[self setDemoData:[NSMutableDictionary dictionaryWithCapacity:1]];
}

- (void)didReceiveMemoryWarning 
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
}

#pragma mark - demo data
- (NSArray *)sectionNames
{
	return [[demoData allKeys] gvc_sortedStringArray];
}
            

- (NSString *)sectionNameAtIndex:(NSUInteger)idx
{
	return [[self sectionNames] objectAtIndex:idx];
}

- (NSArray *)sectionAtIndex:(NSUInteger)idx
{
	return [self rowsForSectionName:[self sectionNameAtIndex:idx]];
}

- (NSDictionary *)rowAtIndexPath:(NSIndexPath *)indexPath
{
	NSArray *rowArray = [self sectionAtIndex:[indexPath section]];
	return [rowArray objectAtIndex:[indexPath row]];
}


- (NSMutableArray *)addSectionForName:(NSString *)section
{
	NSMutableArray *rows = [demoData objectForKey:section];
	if ( rows == nil )
	{
		rows = [NSMutableArray arrayWithCapacity:1];
		[demoData setObject:rows forKey:section];
	}
	return rows;
}

- (NSArray *)rowsForSectionName:(NSString *)section
{
	if ( gvc_IsEmpty(section) == YES )
		section = GVC_UNKNOWN_LABEL;

	return [demoData objectForKey:section];
}

- (NSMutableDictionary *)addRowWithImage:(NSString *)img label:(NSString *)lbl note:(NSString *)note toSection:(NSString *)section
{
	return [self addRowWithImage:img label:lbl note:note toSection:section withId:nil];
}

- (NSMutableDictionary *)addRowWithImage:(NSString *)img label:(NSString *)lbl note:(NSString *)note toSection:(NSString *)section withId:(NSString *)ident
{
	NSMutableDictionary *row = [NSMutableDictionary dictionaryWithCapacity:3];
	if ( img != nil )
		[row setObject:img forKey:GVCDictionaryTableViewController_image];
	if ( lbl != nil )
		[row setObject:lbl forKey:GVCDictionaryTableViewController_label];
	if ( note != nil )
		[row setObject:note forKey:GVCDictionaryTableViewController_note];
	
	if ( ident == nil )
	{
		NSArray *rows = [self rowsForSectionName:section];
		NSInteger count = [rows count];
		ident = GVC_SPRINTF(@"%@_%d", section, count+1);
	}
	[row setObject:ident forKey:GVCDictionaryTableViewController_id];

	[self addRow:row toSection:section];
	return row;
}

- (NSMutableDictionary *)addRow:(NSDictionary *)rowData toSection:(NSString *)section
{
	NSMutableDictionary *row = [NSMutableDictionary dictionaryWithCapacity:3];

	if (rowData != nil)
	{
		[row setDictionary:rowData];
		
		if ( gvc_IsEmpty(section) == YES )
			section = GVC_UNKNOWN_LABEL;
		
		[[self addSectionForName:section] addObject:rowData];
	}
	return row;
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
	NSArray *keyArray = [demoData allKeys];
    return (gvc_IsEmpty(keyArray) ? 0 : [keyArray count]);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	return [self sectionNameAtIndex:section];
}


	// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	NSArray *sectionArray = [self sectionAtIndex:section];
    return (gvc_IsEmpty(sectionArray) ? 0 : [sectionArray count]);
}


	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
	NSArray *rowArray = [self sectionAtIndex:[indexPath section]];
	NSDictionary *row = [rowArray objectAtIndex:[indexPath row]];

	[[cell textLabel] setText:[row objectForKey:GVCDictionaryTableViewController_label]];
	[[cell detailTextLabel] setText:[row objectForKey:GVCDictionaryTableViewController_note]];
	[[cell imageView] setImage:[UIImage imageNamed:[row objectForKey:GVCDictionaryTableViewController_image]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
    return cell;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
}


- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return NO;
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return NO;
}



@end
