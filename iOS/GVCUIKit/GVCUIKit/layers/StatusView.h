/*
 * StatusView.h
 * 
 * Created by David Aspinall on 12-04-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCRoundBorderView.h"

#import <QuartzCore/CALayer.h>
#import <QuartzCore/CATextLayer.h>

@class GVCTextLayer;
@class GVCProgressBarLayer;
@class GVCStatusItem;

@interface StatusView : GVCRoundBorderView

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CATextLayer *messageLayer;
@property (nonatomic, strong) GVCProgressBarLayer *progressLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)displayItem:(GVCStatusItem *)item;

@end
