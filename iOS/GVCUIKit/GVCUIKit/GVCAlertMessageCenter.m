//
//  GVCAlertMessageCenter.m
//  HL7Domain
//
//  Created by David Aspinall on 10-12-13.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCAlertMessageCenter.h"
#import "UIView+GVCUIKit.h"
#import "GVCStatusView.h"

@interface GVCAlertMessageCenter()
@property (nonatomic, strong) NSMutableArray *alerts;
@property (nonatomic, strong) GVCStatusView *alertView;
@property (nonatomic, assign) BOOL active;
- (void)showNextAlertMessage;
- (void)processMessageQueue;
//- (void)hideAlertView;
@end


@implementation GVCAlertMessageCenter

@synthesize alerts;
@synthesize alertView;
@synthesize active;

GVC_SINGLETON_CLASS(GVCAlertMessageCenter);

- (id) init
{
	self=[super init];
	if(self != nil)
	{
		[self setAlerts:[[NSMutableArray alloc] init]];
		[self setActive:NO];
        
        [self setAlertView:[[GVCStatusView alloc] initWithFrame:CGRectZero]];
        [[self alertView] setAutoresizingMask:(UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin)];
	}
	return self;
}

- (void)loadView 
{
    UIView *base = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [base setBackgroundColor:[UIColor clearColor]];
    [base setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [base setUserInteractionEnabled:NO];
    [base addSubview:[self alertView]];
    //[base setAlpha:0];
    
    [self setView:base];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setActive:(BOOL)yesNo
{
	dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if ( yesNo == YES )
		{
			if ( active == NO )
            {
                [self setTransformForCurrentOrientation];
                UIWindow *keyWindow  = [[UIApplication sharedApplication] keyWindow];
                [keyWindow addSubview:[self view]];
                [keyWindow bringSubviewToFront:[self view]];

                [[self view] setNeedsDisplay];
            }
		}
		else
		{
			if ( active == YES )
            {
                [alertView hide];
                [[self view] removeFromSuperview];
            }
		}
		
		active = yesNo;
	});
}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
- (void)setTransformForCurrentOrientation
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	NSInteger degrees = 0;
	
	if (UIInterfaceOrientationIsLandscape(orientation))
	{
		if (orientation == UIInterfaceOrientationLandscapeLeft)
		{
			degrees = -90;
		} 
		else
		{ 
			degrees = 90; 
		}
	}
	else
	{
		if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		{ 
			degrees = 180;
		} 
		else
		{ 
			degrees = 0; 
		}
	}
    [UIView beginAnimations:nil context:nil];
	[[self view] setTransform:CGAffineTransformMakeRotation(RADIANS(degrees))];
    [[self view] setFrame:[[UIScreen mainScreen] bounds]]; 
    [UIView commitAnimations];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification 
{ 
    if ( [self active] == YES )
    {
        [self setTransformForCurrentOrientation];
		[alertView update];
    }
}

- (void)keyWindowChanged:(NSNotification *)notification
{
	[self stopAlert];
}

- (void) startAlertWithMessage:(NSString *)message
{
    [self enqueueMessage:message];
}

- (void) stopAlert
{
	[self clearQueue];
    [self setActive:NO];
}

- (void)showNextAlertMessage
{
	if ( [alerts count] > 0 )
	{
        [self setActive:YES];

		GVCStatusItem *item = [alerts objectAtIndex:0];
		[alerts removeObjectAtIndex:0];
		[alertView displayItem:item];
	}
    else
    {
        [self stopAlert];
    }
}

- (void)processMessageQueue
{
	if ([alerts count] > 0) 
	{
		[self showNextAlertMessage];
	}
}

- (void)enqueueMessage:(NSString *)message
{
    [self enqueueMessage:message accessory:GVC_StatusItemAccessory_ACTIVITY position:GVC_StatusItemPosition_TOP];
}

- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type
{
    [self enqueueMessage:message accessory:type position:GVC_StatusItemPosition_TOP];
}

- (void)enqueueMessage:(NSString *)message accessory:(GVC_StatusItemAccessory)type position:(GVC_StatusItemPosition)pos
{
    GVC_ASSERT_VALID_STRING( message );
	GVCStatusItem *item = [[GVCStatusItem alloc] init];
    [item setMessage:message];
    [item setAccessoryType:type];
    [item setAccessoryPosition:pos];

    [self enqueue:item];
}

- (void)enqueue:(GVCStatusItem *)item
{
    GVC_ASSERT(item != nil, @"Status Item is nil");
    
    [alerts addObject:item];
    [self showNextAlertMessage];
}

- (void)clearQueue
{
    [alerts removeAllObjects];
}

@end



@implementation GVCStatusItem

@synthesize message;
@synthesize progress;
@synthesize image;

@synthesize accessoryType;
@synthesize accessoryPosition;
@synthesize activityStyle;

@end
