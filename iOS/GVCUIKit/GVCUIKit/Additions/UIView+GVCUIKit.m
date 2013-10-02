/*
 * UIView+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UIView+GVCUIKit.h"
#import "GVCFoundation.h"

@implementation UIView (GVCUIKit)


+ (CGPoint)gvc_SharpenPoint:(CGPoint)point
{
    return CGPointMake(floorf(point.x), floorf(point.y));
}

+ (CGSize)gvc_SharpenSize:(CGSize)size
{
    return CGSizeMake(floorf(size.width), floorf(size.height));
}

+ (CGRect)gvc_SharpenRect:(CGRect)rect
{
    return CGRectMake(floorf(rect.origin.x), floorf(rect.origin.y), floorf(rect.size.width), floorf(rect.size.height));
}

- (CGRect)gvc_rectForString:(NSString *)contents atOrigin:(CGPoint)origin constrainedToSize:(CGSize)constrainedSize forFont:(UIFont *)font
{
	GVC_ASSERT( (origin.x >= 0.0) && (origin.y >= 0.0), @"Origin point is invalid" );
	GVC_ASSERT( font != nil, @"Unable to calculate string size without a valid font" );
	
	CGFloat x = origin.x;
	CGFloat y = origin.y;
	CGFloat width = 0.0;
	CGFloat height = 0.0;
	
	if ( gvc_IsEmpty(contents) == NO)
	{
		CGSize textSize = [contents sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:NSLineBreakByWordWrapping];
		width = textSize.width;
		height = textSize.height + 2.0;			
	}
	return CGRectMake(x, y, width, height);
}

- (void)gvc_addRoundRectangleToContext:(CGContextRef)context inRect:(CGRect)rect withRadius:(CGFloat)radius
{
	CGRect rrect = [UIView gvc_SharpenRect:rect];
	
	CGFloat minx = floorf(CGRectGetMinX(rrect)), midx = floorf(CGRectGetMidX(rrect)), maxx = floorf(CGRectGetMaxX(rrect));
	CGFloat miny = floorf(CGRectGetMinY(rrect)), midy = floorf(CGRectGetMidY(rrect)), maxy = floorf(CGRectGetMaxY(rrect));
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
}


- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color set];
    [self gvc_addRoundRectangleToContext:context inRect:rect withRadius:radius];
	CGContextDrawPath(context, kCGPathFill);
}

- (void)gvc_drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)rad borderWidth:(CGFloat)thickness color:(UIColor*)color borderColor:(UIColor*)border
{
	if ( color == nil )
		color = [UIColor darkGrayColor];
		
	if ( border == nil )
		border = [UIColor whiteColor];

	CGContextRef context = UIGraphicsGetCurrentContext();
	CGRect rrect = [UIView gvc_SharpenRect:CGRectInset(rect, thickness/2, thickness/2)];

	// fill
    [color set];
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:rad];
	CGContextDrawPath(context, kCGPathFill);
    
    // border
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:rad];
	CGContextSetStrokeColorWithColor(context, [border CGColor]);
	CGContextSetLineWidth(context, thickness);
	CGContextDrawPath(context, kCGPathStroke);
}

- (CGFloat)gvc_heightForCell
{
    return [self bounds].size.height;
}

@end
