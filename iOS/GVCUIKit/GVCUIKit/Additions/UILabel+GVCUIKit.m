/*
 * UILabel+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-26. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UILabel+GVCUIKit.h"

@implementation UILabel (GVCUIKit)

- (CGFloat)gvc_heightForCell;
{
    CGFloat height = 0.0;
    CGFloat boundWidth = [self bounds].size.width;
    if (([self numberOfLines] != 1) && (boundWidth > 0.0))
    {
        CGSize size = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake(boundWidth, CGFLOAT_MAX) lineBreakMode:[self lineBreakMode]];
        height = MAX(size.height + 12, height);
        if ( height > 100 )
            NSLog(@"err");

    }
    return height;
}

@end
