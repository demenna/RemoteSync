/*
 * StatusView.m
 * 
 * Created by David Aspinall on 12-04-17. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */


#import "StatusView.h"
#import "GVCTextLayer.h"
#import "GVCProgressBarLayer.h"
#import "GVCAlertMessageCenter.h"

#import "NSAttributedString+GVCUIKit.h"

@interface StatusView ()
@property (strong, nonatomic) GVCStatusItem *currentItem;
@end

@implementation StatusView

@synthesize currentItem;
@synthesize messageLayer;
@synthesize progressLayer;
@synthesize imageLayer;
@synthesize activityView;

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
    }
	
    return self;
}

- (CGSize)sizeForItem:(GVCStatusItem *)item
{
    CGSize fullSize = CGSizeZero;

    fullSize = CGSizeMake(280, 148);
    
    return fullSize;
}

static float ACCESSOR_MARGIN = 8.0;
static float BOX_MARGIN = 24.0;
static float MIN_H = 40.0;
static float MIN_W = 160.0;

- (void)layoutSubviews
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
                itemSize = CGSizeMake(floorf(accessorySize.width + messageSize.width + ACCESSOR_MARGIN + BOX_MARGIN), floorf(MAX(accessorySize.height,messageSize.height) + BOX_MARGIN));
                itemSize = CGSizeMake(floorf(MAX(itemSize.width, MIN_W)), floorf(MAX(itemSize.height, MIN_H)));

                accessoryRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                messageRect = CGRectMake((BOX_MARGIN / 2) + accessorySize.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, messageSize.width, messageSize.height);
                break;
            case GVC_StatusItemPosition_RIGHT:
                itemSize = CGSizeMake(floorf(accessorySize.width + messageSize.width + ACCESSOR_MARGIN + BOX_MARGIN), floorf(MAX(accessorySize.height,messageSize.height) + BOX_MARGIN));
                itemSize = CGSizeMake(floorf(MAX(itemSize.width, MIN_W)), floorf(MAX(itemSize.height, MIN_H)));

                messageRect = CGRectMake(BOX_MARGIN / 2, BOX_MARGIN / 2, messageSize.width, messageSize.height);
                accessoryRect = CGRectMake(BOX_MARGIN / 2 + messageSize.width + ACCESSOR_MARGIN, BOX_MARGIN / 2, accessorySize.width, accessorySize.height);
                break;

            case GVC_StatusItemPosition_TOP:
                itemSize = CGSizeMake(floorf(MAX(accessorySize.width, messageSize.width) + BOX_MARGIN), floorf(accessorySize.height + messageSize.height + ACCESSOR_MARGIN + BOX_MARGIN));
                itemSize = CGSizeMake(floorf(MAX(itemSize.width, MIN_W)), floorf(MAX(itemSize.height, MIN_H)));

                accessoryRect = CGRectMake(floorf((itemSize.width - accessorySize.width) / 2),
                                           BOX_MARGIN / 2,
                                           accessorySize.width, accessorySize.height);
                messageRect = CGRectMake(floorf((itemSize.width - messageSize.width) / 2),
                                           BOX_MARGIN / 2 + ACCESSOR_MARGIN + accessorySize.height,
                                           messageSize.width, messageSize.height);
                break;
            case GVC_StatusItemPosition_BOTTOM:
            default:
                itemSize = CGSizeMake(floorf(MAX(accessorySize.width, messageSize.width) + BOX_MARGIN), floorf(accessorySize.height + messageSize.height + ACCESSOR_MARGIN + BOX_MARGIN));
                itemSize = CGSizeMake(floorf(MAX(itemSize.width, MIN_W)), floorf(MAX(itemSize.height, MIN_H)));

                messageRect = CGRectMake(floorf((itemSize.width - messageSize.width) / 2),
                                         BOX_MARGIN / 2,
                                         messageSize.width, messageSize.height);
                accessoryRect = CGRectMake(floorf((itemSize.width - accessorySize.width) / 2),
                                           BOX_MARGIN / 2 + ACCESSOR_MARGIN + messageSize.height,
                                           accessorySize.width, accessorySize.height);
                break;
        }
        
        boxRect = CGRectMake(floorf((superFrame.size.width - itemSize.width) / 2), floorf((superFrame.size.height - itemSize.height) / 2), floorf(itemSize.width), floorf(itemSize.height));
    }
    [self setFrame:boxRect];
    [messageLayer setFrame:messageRect];
    [accessory setFrame:accessoryRect];
}

- (void)displayItem:(GVCStatusItem *)item
{
    [self setCurrentItem:item];
    [self update];
}


- (void)updateMessage:(NSString *)msg andProgress:(float)progress
{
    BOOL needUpdate = NO;
//    if ( [[self text] isEqualToString:msg] == NO )
    {
        [[self messageLayer] setString:msg];
        needUpdate = YES;
    }
    if (progress <= 1.0) // && (currentProgress != progress))
    {
        [[self progressLayer] setProgress:progress];
//        currentProgress = progress;
        needUpdate = YES;
    }
    
    if (needUpdate == YES)
    {
        [self update];
    }
}

- (void)update
{
	if ([NSThread isMainThread]) 
	{
        [[self progressLayer] setProgress:[currentItem progress]];
        [[self progressLayer] setNeedsDisplay];

        [[self messageLayer] setString:[currentItem message]];
		[self setNeedsLayout];
		[self setNeedsDisplay];
	}
	else
	{
		[self performSelectorOnMainThread:@selector(update) withObject:nil waitUntilDone:NO];
	}
}


@end
