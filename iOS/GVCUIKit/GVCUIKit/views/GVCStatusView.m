//
//  GVCStatusView.m
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GVCStatusView.h"
#import "GVCTextLayer.h"
#import "GVCProgressBarLayer.h"
#import "GVCAlertMessageCenter.h"

#import "NSAttributedString+GVCUIKit.h"
#import "UIView+GVCUIKit.h"

@interface GVCStatusView ()
@property (strong, nonatomic) GVCStatusItem *currentItem;
@property (weak, nonatomic) id currentAccessory;
@property (assign, nonatomic) CGRect calculatedViewRect;
@property (assign, nonatomic) CGRect calculatedAccessoryRect;
@property (assign, nonatomic) CGRect calculatedMessageRect;
@end


static float ACCESSOR_MARGIN = 8.0;
//static float TOP_MARGIN = 4.0;
static float BOX_MARGIN = 24.0;
static float MIN_H = 40.0;
static float MIN_W = 160.0;


@implementation GVCStatusView

@synthesize currentItem;
@synthesize messageLayer;
@synthesize progressLayer;
@synthesize imageLayer;
@synthesize activityView;
@synthesize currentAccessory;
@synthesize calculatedViewRect;
@synthesize calculatedAccessoryRect;
@synthesize calculatedMessageRect;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if ( self != nil )
	{
        [self setMessageLayer:[[CATextLayer alloc] init]];
		[messageLayer setContentsScale:[[UIScreen mainScreen] scale]];
		[messageLayer setAnchorPoint:CGPointMake(0, 0)];
        [messageLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [messageLayer setFont:CGFontCreateWithFontName((__bridge CFStringRef)[UIFont boldSystemFontOfSize:14].fontName)];
        
        [messageLayer setFontSize:14];
        [messageLayer setWrapped:YES];
		[[self layer] addSublayer:messageLayer];
        
        [self setProgressLayer:[[GVCProgressBarLayer alloc] init]];
		[progressLayer setContentsScale:[[UIScreen mainScreen] scale]];
		[progressLayer setAnchorPoint:CGPointMake(0, 0)];
        [progressLayer setBackgroundColor:[UIColor clearColor].CGColor];
        [progressLayer setBarProgressColor:[UIColor whiteColor]];
		[[self layer] addSublayer:progressLayer];
        
        [self setActivityView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge]];
        [[self activityView] setHidesWhenStopped:YES];
        
        [self setImageLayer:[[CALayer alloc] init]];
		[imageLayer setAnchorPoint:CGPointMake(0, 0)];
		[[self layer] addSublayer:imageLayer];
        
        [self setBorderColor:[UIColor lightGrayColor]];
        [self setContentColor:[UIColor blueColor]];
        [self setAlpha:0.0];
    }
	
    return self;
}

- (void)calculateViewFrames
{
    CGRect superFrame = [[self superview] bounds];
    CGRect boxRect = CGRectZero;
    CGRect accessoryRect = CGRectZero;
    CGRect messageRect = CGRectZero;
    id accessory = nil;
    
    if ( currentItem != nil )
    {
        //CGSize messageSize = [[currentItem message] sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(MIN_W, MIN_H) lineBreakMode:NSLineBreakByWordWrapping];
        NSAttributedString *attrString = [NSMutableAttributedString gvc_MutableAttributed:[currentItem message] font:[UIFont boldSystemFontOfSize:14] color:[UIColor blackColor] alignment:NSTextAlignmentLeft lineBreakMode:NSLineBreakByWordWrapping];
        CGSize messageSize = [attrString gvc_sizeConstrainedToWidth:MIN_W];
        CGSize accessorySize = CGSizeZero;
        CGSize itemSize = CGSizeZero;
        
        if (([currentItem accessoryPosition] == GVC_StatusItemPosition_LEFT) || ([currentItem accessoryPosition] == GVC_StatusItemPosition_RIGHT))
        {
            // progress bars can only be top or bottom
            if ( [currentItem accessoryType] == GVC_StatusItemAccessory_PROGRESS )
            {
                [currentItem setAccessoryPosition:GVC_StatusItemPosition_BOTTOM];
            }
        }
        
        switch ([currentItem accessoryType]) {
            case GVC_StatusItemAccessory_ACTIVITY:
                accessorySize = CGSizeMake(37, 37);
                accessory = [self activityView];
                
                [[self progressLayer] removeFromSuperlayer];
                [[self imageLayer] removeFromSuperlayer];
                if ( [[self subviews] containsObject:[self activityView]] == NO )
                {
                    [self addSubview:[self activityView]];
                }
                [[self activityView] startAnimating];
                break;
                
            case GVC_StatusItemAccessory_PROGRESS:
                accessorySize = CGSizeMake(MIN_W, 20);
                accessory = [self progressLayer];
                [[self activityView] stopAnimating];
                [[self activityView] removeFromSuperview];
                [[self imageLayer] removeFromSuperlayer];
                
                if ( [[[self layer] sublayers] containsObject:[self progressLayer]] == NO )
                {
                    [[self layer] addSublayer:[self progressLayer]];
                }
                
                break;
                
            case GVC_StatusItemAccessory_IMAGE:
                // size image or scale to max
                accessorySize = [[currentItem image] size];
                accessory = [self imageLayer];
                [[self imageLayer] setContents:(id)[currentItem image].CGImage];
                
                [[self activityView] stopAnimating];
                [[self activityView] removeFromSuperview];
                [[self progressLayer] removeFromSuperlayer];
                
                if ( [[[self layer] sublayers] containsObject:[self imageLayer]] == NO )
                {
                    [[self layer] addSublayer:[self imageLayer]];
                }
                
                break;
                
            case GVC_StatusItemAccessory_NONE:
            default:
                break;
        }
        
        switch ([currentItem accessoryPosition]) {
            case GVC_StatusItemPosition_LEFT:
                itemSize = CGSizeMake(accessorySize.width + messageSize.width + ACCESSOR_MARGIN + BOX_MARGIN, 
                                      MAX(accessorySize.height,messageSize.height) + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                accessoryRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                messageRect = CGRectMake((BOX_MARGIN / 2) + accessorySize.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, messageSize.width, messageSize.height);
                break;
            case GVC_StatusItemPosition_RIGHT:
                itemSize = CGSizeMake(accessorySize.width + messageSize.width + ACCESSOR_MARGIN + BOX_MARGIN, 
                                      MAX(accessorySize.height,messageSize.height) + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                messageRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, messageSize.width, messageSize.height);
                accessoryRect = CGRectMake(BOX_MARGIN / 2 + messageSize.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                break;
                
            case GVC_StatusItemPosition_TOP:
                itemSize = CGSizeMake(MAX(accessorySize.width, messageSize.width) + BOX_MARGIN, 
                                      accessorySize.height + messageSize.height + ACCESSOR_MARGIN + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                accessoryRect = CGRectMake((itemSize.width - accessorySize.width) / 2,
                                           BOX_MARGIN / 2,
                                           accessorySize.width, accessorySize.height);
                messageRect = CGRectMake((itemSize.width - messageSize.width) / 2,
                                         BOX_MARGIN / 2 + ACCESSOR_MARGIN + accessorySize.height,
                                         messageSize.width, messageSize.height);
                break;
            case GVC_StatusItemPosition_BOTTOM:
            default:
                itemSize = CGSizeMake(MAX(accessorySize.width, messageSize.width) + BOX_MARGIN, 
                                      accessorySize.height + messageSize.height + ACCESSOR_MARGIN + BOX_MARGIN);
                itemSize = CGSizeMake(MAX(itemSize.width, MIN_W), MAX(itemSize.height, MIN_H));
                
                messageRect = CGRectMake((itemSize.width - messageSize.width) / 2,
                                         BOX_MARGIN / 2,
                                         messageSize.width, messageSize.height);
                accessoryRect = CGRectMake((itemSize.width - accessorySize.width) / 2,
                                           BOX_MARGIN / 2 + ACCESSOR_MARGIN + messageSize.height,
                                           accessorySize.width, accessorySize.height);
                break;
        }
        
        boxRect = CGRectMake((superFrame.size.width - itemSize.width) / 2, 
                             (superFrame.size.height - itemSize.height) / 2, 
                             itemSize.width, 
                             itemSize.height
                             );
    }
    [self setCurrentAccessory:accessory];
    [self setCalculatedViewRect:[UIView gvc_SharpenRect:boxRect]];
    [self setCalculatedAccessoryRect:[UIView gvc_SharpenRect:accessoryRect]];
    [self setCalculatedMessageRect:[UIView gvc_SharpenRect:messageRect]];
}

- (void)displayItem:(GVCStatusItem *)item
{
    [self setCurrentItem:item];
    [self update];
}

- (void)update
{
	if ([NSThread isMainThread]) 
	{
        [self calculateViewFrames];
        if ( CGRectEqualToRect([self frame], CGRectZero) == YES )
        {
            [self setFrame:calculatedViewRect];
        }

        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:.4 animations:^{ 
                if ( CGRectEqualToRect([self frame], calculatedViewRect) == NO )
                {
                    [self setFrame:calculatedViewRect];
                    [self setNeedsDisplay];
                }
                
                [messageLayer setFrame:calculatedMessageRect];
                [currentAccessory setFrame:calculatedAccessoryRect];
                [self setAlpha:1.0];
            } completion:^(BOOL finished) {
                if (finished == YES) 
                {
                    [[self superview] setUserInteractionEnabled:YES];
                }
            }];
        }];
        
        [[self progressLayer] setProgress:[currentItem progress]];
        [[self progressLayer] setNeedsDisplay];
        [[self messageLayer] setString:[currentItem message]];

        [CATransaction commit];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}

- (void)show
{
    [self setAlpha:0.0];
    [self update];
}

- (void)hide
{
	if ([NSThread isMainThread]) 
	{
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [CATransaction setCompletionBlock:^{
            [UIView animateWithDuration:.6 animations:^{ 
                [self setAlpha:0.0];
            } completion:^(BOOL finished) {
                if (finished == YES) 
                {
                    [[self superview] setUserInteractionEnabled:NO];
                }
            }];
        }];
        
        [CATransaction commit];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(hide) withObject:nil waitUntilDone:NO];
	}
}

- (void)drawRect:(CGRect)rect 
{
//	[self gvc_drawRoundRectangleInRect:rect withRadius:[self cornerRadius] borderWidth:[self borderWidth] color:[self contentColor] borderColor:[self borderColor]];
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rrect = [UIView gvc_SharpenRect:CGRectInset(rect, [self borderWidth]-1, [self borderWidth]-1)];

    CGContextSaveGState(context);
    [self gvc_addRoundRectangleToContext:context inRect:rrect withRadius:[self cornerRadius]];
    CGContextClip(context);
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    UIColor *shineMinor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    NSArray *colors = [NSArray arrayWithObjects:(id)[self contentColor].CGColor, (id)shineMinor.CGColor, nil];
    CGFloat locations[2] = { 0.0, 1.0 };
    
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, locations);
    CGPoint start = CGPointMake(0, rrect.origin.y);
    CGPoint end = CGPointMake(0, rrect.origin.y+(rrect.size.height/3));
    CGContextDrawLinearGradient (context, gradient, start, end, 0);
    
    CGColorSpaceRelease(space);
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
}

@end
