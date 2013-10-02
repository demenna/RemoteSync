//
//  GVCAlertMessageCenter.h
//  HL7Domain
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <dispatch/dispatch.h>

#import "GVCFoundation.h"

typedef enum {
	GVC_StatusItemPosition_TOP = 0,
	GVC_StatusItemPosition_BOTTOM,
	GVC_StatusItemPosition_LEFT,
	GVC_StatusItemPosition_RIGHT
} GVC_StatusItemPosition;

typedef enum {
	GVC_StatusItemAccessory_NONE = 0,
	GVC_StatusItemAccessory_PROGRESS,
	GVC_StatusItemAccessory_ACTIVITY,
	GVC_StatusItemAccessory_IMAGE
} GVC_StatusItemAccessory;


@interface GVCStatusItem : NSObject
@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) float progress;

@property (nonatomic, assign) GVC_StatusItemPosition accessoryPosition;
@property (nonatomic, assign) GVC_StatusItemAccessory accessoryType;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) UIActivityIndicatorViewStyle activityStyle;
@end


@interface GVCAlertMessageCenter : UIViewController 

GVC_SINGLETON_HEADER(GVCAlertMessageCenter);


- (void) startAlertWithMessage:(NSString *)message;
- (void) stopAlert;

- (void)enqueueMessage:(NSString *)message;
- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type;
- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type position:(GVC_StatusItemPosition)pos;
- (void)enqueue:(GVCStatusItem *)item;
- (void)clearQueue;

@end
