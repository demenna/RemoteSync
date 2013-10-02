/*
 * GVCDataFormSection.m
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCDataFormSection.h"

@interface GVCDataFormSection ()
@property (strong, nonatomic) NSMutableArray *formFieldArray;
@end

@implementation GVCDataFormSection

@synthesize headerText;
@synthesize footerText;
@synthesize model;
@synthesize formFieldArray;


- (id)initWithHeader:(NSString *)head andFooter:(NSString *)footer
{
	self = [super init];
	if ( self != nil )
	{
        [self setHeaderText:head];
        [self setFooterText:footer];
	}
	
    return self;
}

#pragma mark - field management
- (GVCDataFormField *)addFormField:(GVCDataFormField *)formField
{
    GVC_ASSERT_NOT_NIL(formField);
    
    if ( formFieldArray == nil )
    {
        [self setFormFieldArray:[[NSMutableArray alloc] initWithCapacity:10]];
    }
    
    [[self formFieldArray] addObject:formField];
    return formField;
}

- (GVCDataFormField *)addFormFieldWithKeypath:(NSString *)kp labelKey:(NSString *)lk
{
    GVCDataFormField *formField = [[GVCDataFormField alloc] initWithKeypath:kp labelKey:lk];
    return [self addFormField:formField];
}

- (GVCDataFormField *)addFormField:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk
{
    GVCDataFormField *formField = [[GVCDataFormField alloc] initType:t withKeypath:kp labelKey:lk];
    return [self addFormField:formField];
}

- (GVCDataFormField *)addImmutableFormField:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk
{
    GVCDataFormField *formField = [[GVCDataFormField alloc] initType:t withKeypath:kp labelKey:lk];
    [formField setMutable:NO];
    return [self addFormField:formField];
}


- (NSArray *)formFields
{
    NSArray *ff = [NSArray array];
    if ( [self formFieldArray] != nil )
    {
        ff = [[self formFieldArray] copy];
    }
    return ff;
}

- (GVCDataFormField *)formFieldAtIndex:(NSUInteger)idx
{
    GVCDataFormField *formField = nil;
    if ( idx < [[self formFieldArray] count] )
    {
        formField = [[self formFieldArray] objectAtIndex:idx];
    }
    return formField;
}

- (NSUInteger)formFieldCount 
{
	return [[self formFieldArray] count];
}

@end
