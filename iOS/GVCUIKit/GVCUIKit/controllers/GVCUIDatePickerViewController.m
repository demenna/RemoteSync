//
//  GVCUIDatePickerViewController.m
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCUIDatePickerViewController.h"
#import "GVCFoundation.h"

@implementation GVCUIDatePickerViewController

@synthesize datePicker;
@synthesize mode;
@synthesize minimumDate;
@synthesize maximumDate;
@synthesize currentDate;

@synthesize callbackKey;

- (id) initWithMode:(UIDatePickerMode) m
{
	self = [super init];
	if (self != nil) 
	{
		[self setMode:m];
        [self setCallbackKey:@"dateOfBirth"];
        [self setDatePicker:[[UIDatePicker alloc] init]];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [[self view] addSubview:datePicker];
	}
	return self;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[datePicker setDatePickerMode:mode];
	[datePicker setMinimumDate:[self minimumDate]];
	[datePicker setMaximumDate:[self maximumDate]];

    if ( [self currentDate] != nil )
        [datePicker setDate:[self currentDate]];
}

- (void)viewDidLoad 
{
	[super viewDidLoad];
	[datePicker sizeToFit];
}

- (IBAction)dateChanged:sender
{
    [self setCurrentDate:[[self datePicker] date]];
	if ( [self callbackDelegate] != nil )
	{
        if ( gvc_IsEmpty([self callbackKey]) == YES )
        {
            [self setCallbackKey:@"dateOfBirth"];
        }
        
        if ( [[self callbackDelegate] conformsToProtocol:@protocol(GVCUIDatePickerCallbackProtocol)]  == YES )
        {
            [(id <GVCUIDatePickerCallbackProtocol>)[self callbackDelegate] setDate:[self currentDate] forKey:[self callbackKey]];
        }
        else 
        {
            [[self callbackDelegate] setValue:[self currentDate] forKey:[self callbackKey]];
        }
	}
}

@end
