//
//  GVCProgressBarLayer.h
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <QuartzCore/CALayer.h>

@interface GVCProgressBarLayer : CALayer

// progress value in range of 0 to 1
@property (assign, nonatomic) CGFloat progress; 

@property (assign, nonatomic) CGFloat borderRadius;
@property (assign, nonatomic) CGFloat barRadius;
@property (assign, nonatomic) CGFloat barInset;

@property (strong, nonatomic) UIColor *barProgressColor;

@end
