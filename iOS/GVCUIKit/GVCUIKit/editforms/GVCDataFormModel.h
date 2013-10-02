/*
 * GVCDataFormModel.h
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFoundation.h"

@class GVCDataFormSection;
@class GVCDataFormField;

@interface GVCDataFormModel : NSObject

@property (strong, nonatomic) NSObject *dataObject;

- (NSArray *)sections;
- (GVCDataFormSection *)addSection:(GVCDataFormSection *)section;
- (GVCDataFormSection *)addSectionWithHeader:(NSString *)head andFooter:(NSString *)footer;

- (NSUInteger)sectionCount;
- (GVCDataFormSection *)sectionAtIndex:(NSUInteger)idx;
- (GVCDataFormField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (NSUInteger)numberOfFormFieldsInSection:(NSInteger)idx;

- (id)dataValueForField:(GVCDataFormField *)field;
- (void)setValue:(id)value forField:(GVCDataFormField *)field;
@end
