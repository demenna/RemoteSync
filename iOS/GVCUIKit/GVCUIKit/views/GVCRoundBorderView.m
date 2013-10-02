//
//  GVCRoundBorderView.m
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCRoundBorderView.h"

#import <QuartzCore/QuartzCore.h>
#import "GVCFoundation.h"

#import "UIColor+GVCUIKit.h"
#import "UIView+GVCUIKit.h"

@implementation GVCRoundBorderView

@synthesize borderColor;
@synthesize contentColor;

@synthesize borderWidth;
@synthesize cornerRadius;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) 
	{
        // Initialization code.
		[self setBackgroundColor:[UIColor clearColor]];
		[self setBorderColor:[UIColor whiteColor]];
		[self setContentColor:[UIColor darkGrayColor]];
		
		[self setBorderWidth:2];
		[self setCornerRadius:10];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder 
{
    self = [super initWithCoder:coder];
    if (self != nil) 
	{
		[self setContentColor:[self backgroundColor]];
		[self setBorderColor:[[self backgroundColor] gvc_reverseColor]];

		[self setBackgroundColor:[UIColor clearColor]];
		
		[self setBorderWidth:5];
		[self setCornerRadius:10];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setBackgroundColor:[UIColor clearColor]];
	[[self layer] setMasksToBounds:YES];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	[self gvc_drawRoundRectangleInRect:rect withRadius:[self cornerRadius] borderWidth:[self borderWidth] color:[self contentColor] borderColor:[self borderColor]];
}


@end
