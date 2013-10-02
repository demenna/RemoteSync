/*
 * GVCDataFormField.h
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCFoundation.h"

typedef enum {
    GVCDataFormFieldType_STRING,
	GVCDataFormFieldType_PASSWORD,
    GVCDataFormFieldType_URL,
    GVCDataFormFieldType_DATE,
    GVCDataFormFieldType_INT,
    GVCDataFormFieldType_FLOAT,
    GVCDataFormFieldType_BUTTON,
    GVCDataFormFieldType_CUSTOM
} GVCDataFormFieldType;

@interface GVCDataFormField : NSObject

@property (assign, nonatomic) GVCDataFormFieldType type;
@property (strong, nonatomic) NSString *keypath;
@property (strong, nonatomic) NSString *localizedLabelKey;
@property (assign, nonatomic, getter=isNullable) BOOL nullable;
@property (assign, nonatomic, getter=isMutable) BOOL mutable;

- (id)initWithKeypath:(NSString *)kp labelKey:(NSString *)lk;
- (id)initType:(GVCDataFormFieldType)t withKeypath:(NSString *)kp labelKey:(NSString *)lk;

@end
