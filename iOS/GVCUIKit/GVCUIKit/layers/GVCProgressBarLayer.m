//
//  GVCProgressBarLayer.m
//  HL7Domain
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCProgressBarLayer.h"
#import <QuartzCore/QuartzCore.h>

#import "UIView+GVCUIKit.h"

@implementation GVCProgressBarLayer

@synthesize progress;
@synthesize barProgressColor;

@synthesize borderRadius;
@synthesize borderWidth;
@synthesize barRadius;
@synthesize barInset;

- (id)init
{
    self = [super init];
	if (self != nil)
    {
        // borderRadius:8. borderWidth:2. barRadius:5. barInset:3
		[self setProgress:(CGFloat)0.0];
		[self setBorderRadius:(CGFloat)8.0];
		[self setBorderWidth:(CGFloat)2.0];
		[self setBarRadius:(CGFloat)5.0];
		[self setBarInset:(CGFloat)3.0];
        
        [self setBorderColor:[UIColor clearColor].CGColor];
	}
	return self;
}

- (void) setProgress:(float)p
{
	p = MIN(MAX(0.0,p),1.0);
	
	if ((p > 0.0) && (p < 0.04)) 
		p = 0.04;

	if (p != progress)
	{
		progress = p;
	}
}

- (void)drawInContext:(CGContextRef)context 
{
	UIGraphicsPushContext(context);
	if (progress >= 0) 
    {
        CGRect rrect = [UIView gvc_SharpenRect:CGRectInset([self bounds], borderWidth/2, borderWidth/2)];
        CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
        CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
        
        // draw the border line
        CGContextMoveToPoint(context, minx, midy);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, borderRadius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, borderRadius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, borderRadius);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, borderRadius);
        CGContextClosePath(context);
        // CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
        CGContextSetStrokeColorWithColor(context, [barProgressColor CGColor]);
        CGContextSetLineWidth(context, borderWidth);
        CGContextDrawPath(context, kCGPathStroke);
        
        // draw the progress bar
        rrect = [UIView gvc_SharpenRect:CGRectInset(rrect, barInset, barInset)];
        rrect.size.width = rrect.size.width * [self progress];
        minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
        miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
        CGContextMoveToPoint(context, minx, midy);
        CGContextAddArcToPoint(context, minx, miny, midx, miny, barRadius);
        CGContextAddArcToPoint(context, maxx, miny, maxx, midy, barRadius);
        CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, barRadius);
        CGContextAddArcToPoint(context, minx, maxy, minx, midy, barRadius);
        CGContextClosePath(context);
        // CGContextSetRGBFillColor(context,1, 1, 1, 1);
        CGContextSetFillColorWithColor( context, [barProgressColor CGColor] );
        
        CGContextDrawPath(context, kCGPathFill);
	}
	UIGraphicsPopContext();
}

- (IBAction)updateProgress:(id)sender 
{
    if ([sender isKindOfClass:[UISlider class]] == YES ) 
    {
        UISlider *slider = (UISlider *)sender;
        float min = [slider minimumValue];
        float max = [slider maximumValue];
        float val = [slider value];
        
        [self setProgress:((val - min) / (max - min))];
    }
}

@end
