//
//  GVCStatusView.h
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CATextLayer.h>

#import "GVCRoundBorderView.h"

@class GVCTextLayer;
@class GVCProgressBarLayer;
@class GVCStatusItem;

@interface GVCStatusView : GVCRoundBorderView 

- (id)initWithFrame:(CGRect)frame;

@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) CATextLayer *messageLayer;
@property (nonatomic, strong) GVCProgressBarLayer *progressLayer;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

- (void)displayItem:(GVCStatusItem *)item;
- (void)show;
- (void)update;
- (void)hide;

@end
