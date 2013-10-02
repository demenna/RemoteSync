/*
 * GVCDataFormField.m
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCDataFormField.h"

@interface GVCDataFormField ()

@end

@implementation GVCDataFormField

@synthesize type;
@synthesize keypath;
@synthesize localizedLabelKey;
@synthesize nullable;
@synthesize mutable;

- (id)initWithKeypath:(NSString *)kp labelKey:(NSString *)lk
{
    return [self initType:GVCDataFormFieldType_STRING withKeypath:kp labelKey:lk];
}
- (id)initType:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk;
{
	self = [super init];
	if ( self != nil )
	{
        GVC_ASSERT(kp != nil, @"Keypath cannot be nil");
        [self setType:t];
        [self setKeypath:kp];
        [self setLocalizedLabelKey:lk];
        [self setNullable:YES];
        [self setMutable:YES];
	}
	
    return self;
}

@end
