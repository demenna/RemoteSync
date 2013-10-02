/*
 * GVCDataFormSection.h
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFoundation.h"

#import "GVCDataFormField.h"
#import "GVCDataFormModel.h"

@interface GVCDataFormSection : NSObject

- (id)initWithHeader:(NSString *)head andFooter:(NSString *)footer;

@property (strong, nonatomic) NSString *headerText;
@property (strong, nonatomic) NSString *footerText;
@property (weak, nonatomic) GVCDataFormModel *model;

- (NSArray *)formFields;
- (GVCDataFormField *)addFormField:(GVCDataFormField *)formField;
- (GVCDataFormField *)addFormFieldWithKeypath:(NSString *)kp labelKey:(NSString *)lk;
- (GVCDataFormField *)addFormField:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk;
- (GVCDataFormField *)addImmutableFormField:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk;

- (NSUInteger)formFieldCount;
- (GVCDataFormField *)formFieldAtIndex:(NSUInteger)idx;

@end
