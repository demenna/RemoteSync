//
//  GVCTextLayer.h
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <QuartzCore/CALayer.h>

@interface GVCTextLayer : CALayer

@property (strong, nonatomic) NSString *displayText;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textShadowColor;

@end
