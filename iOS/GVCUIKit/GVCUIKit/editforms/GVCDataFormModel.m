/*
 * GVCDataFormModel.m
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCDataFormModel.h"
#import "GVCDataFormSection.h"
#import "GVCDataFormField.h"

@interface GVCDataFormModel ()
@property (strong, nonatomic) NSMutableArray *sectionArray;
@end

@implementation GVCDataFormModel

@synthesize dataObject;
@synthesize sectionArray;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
	}
	
    return self;
}

- (NSArray *)sections
{
    NSArray *retVal = [NSArray array];
    if (sectionArray != nil)
    {
        retVal = [sectionArray copy];
    }
    return retVal;
}

- (GVCDataFormSection *)addSection:(GVCDataFormSection *)section
{
    GVC_ASSERT_NOT_NIL(section);
    if ( sectionArray == nil )
    {
        [self setSectionArray:[[NSMutableArray alloc] initWithCapacity:10]];
    }
    
    [[self sectionArray] addObject:section];
    [section setModel:self];
    
    return section;
}

- (GVCDataFormSection *)addSectionWithHeader:(NSString *)head andFooter:(NSString *)footer
{
    GVCDataFormSection *section = [[GVCDataFormSection alloc] initWithHeader:head andFooter:footer];
    return [self addSection:section];
}

#pragma mark - meta section
- (NSUInteger)sectionCount 
{
	return [[self sections] count];
}

- (GVCDataFormSection *)sectionAtIndex:(NSUInteger)idx
{
    GVCDataFormSection *section = nil;
    if ( idx < [[self sectionArray] count] )
    {
        section = [[self sectionArray] objectAtIndex:idx];
    }
    return section;
}

- (GVCDataFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
    GVCDataFormField *formField = nil;
    GVCDataFormSection *section = [self sectionAtIndex:[indexPath section]];
    if ( section != nil )
    {
        formField = [section formFieldAtIndex:[indexPath row]];
    }
    return formField;
}

- (NSUInteger)numberOfFormFieldsInSection:(NSInteger)idx 
{
	GVCDataFormSection *section = [self sectionAtIndex:idx];
	return (section != nil) ? [section formFieldCount] : 0;
}

#pragma mark - data kvc
- (id)dataValueForField:(GVCDataFormField *)field
{
    id value = nil;
    if ( [self dataObject] != nil)
    {
        value = [[self dataObject] valueForKeyPath:[field keypath]];
    }
    return value;
}

- (void)setValue:(id)value forField:(GVCDataFormField *)field
{
    if ( [self dataObject] != nil )
    {
        [[self dataObject] setValue:value forKeyPath:[field keypath]];
    }
}

@end
