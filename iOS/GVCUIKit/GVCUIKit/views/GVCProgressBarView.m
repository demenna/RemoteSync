//
//  GVCProgressBarView.m
//  HL7Domain
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCProgressBarView.h"
#import <QuartzCore/QuartzCore.h>


@implementation GVCProgressBarView

@synthesize progress;
@synthesize barProgressColor;

+ (GVCProgressBarView *)standardWhiteProgressView
{
	CGRect rect = CGRectMake(0, 0, 210, 20);
	return [[GVCProgressBarView alloc] initWithFrame:rect];
}

+ (GVCProgressBarView *)standardDarkGreyProgressView
{
	GVCProgressBarView *progBar = [GVCProgressBarView standardWhiteProgressView];
	[progBar setBarProgressColor:[UIColor darkGrayColor]];
	return progBar;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
		progress = 0;
		[self setBackgroundColor:[UIColor clearColor]];
		[self setBarProgressColor:[UIColor whiteColor]];
    }
    return self;
}

- (void) setProgress:(float)p
{
	p = MIN(MAX(0.0,p),1.0);
	
	if ((p > 0.0) && (p < 0.08)) 
		p = 0.08;

	if (p != progress)
	{
		progress = p;
		[self setNeedsDisplay];
	}
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setBackgroundColor:[UIColor clearColor]];
	[[self layer] setMasksToBounds:YES];
}

- (void) drawRect:(CGRect)rect borderRadius:(CGFloat)rad borderWidth:(CGFloat)thickness barRadius:(CGFloat)barRadius barInset:(CGFloat)barInset
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGRect rrect = CGRectInset(rect,thickness, thickness);
	CGFloat radius = rad;
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	// CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
	CGContextSetStrokeColorWithColor(context, [barProgressColor CGColor]);
	CGContextSetLineWidth(context, thickness);
	CGContextDrawPath(context, kCGPathStroke);

	radius = barRadius;
	
	rrect = CGRectInset(rrect, barInset, barInset);
	rrect.size.width = rrect.size.width * [self progress];
	minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	// CGContextSetRGBFillColor(context,1, 1, 1, 1);
	CGContextSetFillColorWithColor( context, [barProgressColor CGColor] );
	
	CGContextDrawPath(context, kCGPathFill);
}

- (void) drawRect:(CGRect)rect 
{
	[self drawRect:rect borderRadius:8. borderWidth:2. barRadius:5. barInset:3];
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
