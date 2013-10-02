/*
 * UITextView+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UITextView+GVCUIKit.h"

@implementation UITextView (GVCUIKit)

- (CGFloat)gvc_heightForCell;
{
    CGFloat height = 0.0;
    CGFloat boundWidth = [self bounds].size.width;
    if (boundWidth > 0.0)
    {
        CGSize size = [[self text] sizeWithFont:[self font] constrainedToSize:CGSizeMake(boundWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        height = MAX(size.height + 12, height);
        if ( height > 150 )
            NSLog(@"err");
        
    }
    return height;
}

@end
