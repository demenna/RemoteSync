/*
 * UIDevice+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

@interface UIDevice (UIDeviceGVCUIKit)

@property(readonly) NSString *gvc_userInterfaceIdiomString;
@property(readonly) NSString *gvc_phoneNumber;
@property(readonly) double gvc_availableMemory;

@end

