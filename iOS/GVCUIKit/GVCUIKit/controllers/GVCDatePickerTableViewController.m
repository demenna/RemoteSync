//
//  GVCDatePickerTable.m
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCDatePickerTableViewController.h"
#import "GVCFoundation.h"
#import "UITableViewCell+GVCUIKit.h"
#import "GVCUITableViewCell.h"

@implementation GVCDatePickerTableViewController

@synthesize datePicker;
@synthesize labelKey;
@synthesize detailKey;
@synthesize currentDate;
@synthesize gvcTableView;
@synthesize minimumDate;
@synthesize maximumDate;

- (IBAction)dateChanged:sender
{
	[self setCurrentDate:[datePicker date]];
	if ( [self callbackDelegate] != nil )
	{
		[[self callbackDelegate] setValue:[self currentDate] forKey:[self labelKey]];
	}
    [[self gvcTableView] reloadData];
}

- (void)loadView
{
    [super loadView];
    
    [self setView:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
	
    UITableView *theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 35.0, 320.0, 150.0) style:UITableViewStyleGrouped];
    theTableView.delegate = self;
    theTableView.dataSource = self;
    [[self view] addSubview:theTableView];
	[self setGvcTableView:theTableView];
	
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 200.0, 0.0, 0.0)];
    [theDatePicker setDatePickerMode:UIDatePickerModeDate];
    [self setDatePicker:theDatePicker];
	
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    [[self view] addSubview:datePicker];
	[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated 
{
    if (currentDate != nil)
        [self.datePicker setDate:currentDate animated:YES];	
    else 
        [self.datePicker setDate:[NSDate date] animated:YES];
	
	[datePicker sizeToFit];
	[datePicker setMinimumDate:[self minimumDate]];
	[datePicker setMaximumDate:[self maximumDate]];

    [[self gvcTableView] reloadData];
	[self setHidesBottomBarWhenPushed:YES];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

#pragma mark - Table View Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;	
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath  
{
    UITableViewCell *cell = [GVCUITableViewCell gvc_CellWithStyle:UITableViewCellStyleValue2 forTableView:tv];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[cell textLabel] setNumberOfLines:0];
    [[cell detailTextLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    [[cell detailTextLabel] setNumberOfLines:0];
	
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
	[[cell textLabel] setText:GVC_LocalizedString(labelKey, labelKey)];
	[[cell detailTextLabel] setText:[formatter stringFromDate:[self.datePicker date]]];
    
    return cell;
}

@end

