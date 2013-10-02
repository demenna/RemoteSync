/*
 * UIView+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UIView (GVCUIKit)

+ (CGPoint)gvc_SharpenPoint:(CGPoint)point;
+ (CGSize)gvc_SharpenSize:(CGSize)size;
+ (CGRect)gvc_SharpenRect:(CGRect)rect;

- (CGRect)gvc_rectForString:(NSString *)contents atOrigin:(CGPoint)origin constrainedToSize:(CGSize)constrainedSize forFont:(UIFont *)font;

- (void)gvc_addRoundRectangleToContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color;
- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border;

- (CGFloat)gvc_heightForCell;

@end
