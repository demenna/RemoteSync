/*
 * GVCUIViewWithTableController.m
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUIViewWithTableController.h"
#import "UITableViewCell+GVCUIKit.h"
#import "GVCFoundation.h"

@implementation GVCUIViewWithTableController

@synthesize tableView;

- (IBAction)reload:(id)sender
{
	[[self tableView] reloadData];
}

- (void)viewDidAppear:(BOOL)animated 
{
    [super viewDidAppear:animated];
    
	// set default title
	[[self tableView] reloadData];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	[[self tableView] setAutoresizesSubviews:YES];
}

#pragma mark - keyboard resize
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [self tableView] != nil)
	{
		UIEdgeInsets e = UIEdgeInsetsMake(0, 0, bounds.size.height, 0);
		
		[[self tableView] setContentInset:e];
		[[self tableView] setScrollIndicatorInsets:e];
//        [[self tableView] scrollToRowAtIndexPath:[[self tableView] indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionTop animated:animated];
	}
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [self tableView] != nil)
	{
		[[self tableView] setContentInset:UIEdgeInsetsZero];
		[[self tableView] setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
}

#pragma mark - Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
	GVC_SUBCLASS_RESPONSIBLE;
	return nil;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	GVC_SUBCLASS_RESPONSIBLE;
    return nil;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
	// Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tv canEditRowAtIndexPath:(NSIndexPath *)indexPath 
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
 {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tv moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tv canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//	if ( [cell isKindOfClass:[GVCUITableViewCell class]] == YES )
//	{
//		[(GVCUITableViewCell *)cell setUseDarkBackground:([indexPath row] % 2 == 0)];
//	}
//}

- (CGFloat)tableView:(UITableView*)tv heightForRowAtIndexPath:(NSIndexPath*)indexPath 
{
	UITableViewCell *cell = [self tableView:tv cellForRowAtIndexPath:indexPath];
    return [cell gvc_heightForCell];
}



@end
