//
//  GVCBadgeView.m
//  Test
//
//  Created by David Aspinall on 11-03-15.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCBadgeView.h"

#import <QuartzCore/QuartzCore.h>
#import "GVCFoundation.h"

@implementation GVCBadgeView

@synthesize text;
@synthesize badgeColor;
@synthesize textFont;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
	{
        [self setBackgroundColor:[UIColor clearColor]];
		[[self layer] setMasksToBounds:YES];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    [self setBackgroundColor:[UIColor clearColor]];
	[[self layer] setMasksToBounds:YES];
}

- (void)setText:(NSString *)str
{
	text = str;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect 
{
    if ( text == nil )
        text = [NSString gvc_EmptyString];
    
	if ( text != nil )
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		if (badgeColor == nil)
		{
			[self setBadgeColor:[UIColor colorWithRed:0.53 green:0.6 blue:0.738 alpha:1.]];
		}
		
		if ( textFont == nil )
		{
			[self setTextFont:[UIFont boldSystemFontOfSize:13.]];
		}

		CGSize badgeTextSize = [text sizeWithFont:textFont];
		CGRect badgeViewFrame = CGRectIntegral(CGRectMake(MAX(rect.size.width - badgeTextSize.width - 14, 0), 
										   (rect.size.height - badgeTextSize.height - 4) / 2, 
										   MIN(badgeTextSize.width + 14, rect.size.width), 
										   MIN(badgeTextSize.height + 4, rect.size.height)));
		
			//badgeViewFrame = (badgeViewFrame);

		CGContextSaveGState(context);	
		CGContextSetFillColorWithColor(context, [badgeColor CGColor]);
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.width - badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI / 2, M_PI * 3 / 2, YES);
		CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI * 3 / 2, M_PI / 2, YES);
		CGContextAddPath(context, path);
		CGContextDrawPath(context, kCGPathFill);
		CFRelease(path);
		CGContextRestoreGState(context);
		
		CGContextSaveGState(context);	
		CGContextSetBlendMode(context, kCGBlendModeClear);
		[text drawInRect:CGRectInset(badgeViewFrame, 7, 2) withFont:textFont];
		CGContextRestoreGState(context);
	}
}

- (IBAction)updateBadgeText:(id)sender 
{
    NSLog(@"updateBadgeText :%@", sender);
    if ( [sender isKindOfClass:[UITextField class]] == YES )
    {
        [self setText:[(UITextField *)sender text]];
    }
    else if ([sender isKindOfClass:[UISlider class]] == YES ) 
    {
        UISlider *slider = (UISlider *)sender;
        float min = [slider minimumValue];
        float max = [slider maximumValue];
        float val = [slider value];
        
        int progress = ((val - min) / (max - min)) * 100;
        [self setText:GVC_SPRINTF(@"%d %%", progress)];
    }

}

@end
