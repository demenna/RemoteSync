//
//  GVCTextLayer.m
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCTextLayer.h"
#import "GVCFoundation.h"

@implementation GVCTextLayer

@synthesize displayText;
@synthesize textFont;
@synthesize textColor;
@synthesize textShadowColor;

+ (BOOL)needsDisplayForKey:(NSString *)key 
{
	if ([key isEqualToString:GVC_PROPERTY(displayText)])
    {
		return YES;
	}

    return [super needsDisplayForKey:key];
}

- (id)init
{
    self = [super init];
	if (self != nil)
    {
		[self setDisplayText:[NSString gvc_EmptyString]];
        [self setTextColor:[UIColor blackColor]];
        [self setTextShadowColor:[UIColor whiteColor]];
        [self setTextFont:[UIFont boldSystemFontOfSize:14]];
	}
	return self;
}

- (void)drawInContext:(CGContextRef)context 
{
	UIGraphicsPushContext(context);
	
	CGRect bounds = self.bounds;
	CGRect shadow = bounds;
	shadow.origin.y -= 1;
	
	[[self textColor] set];
	[[self displayText] drawInRect:bounds withFont:[self textFont] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
	
	[[self textShadowColor] set];
	[[self displayText] drawInRect:shadow withFont:[self textFont] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
	
	UIGraphicsPopContext();
}

@end
