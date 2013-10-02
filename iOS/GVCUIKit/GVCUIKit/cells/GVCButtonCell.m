//
//  DAButtonCell.h
//
//  Created by David Aspinall on 10-04-05.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import "GVCButtonCell.h"

#define MAIN_FONT_SIZE 16.0


@implementation GVCButtonCell

@synthesize centerLabel;
@synthesize button;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	return [self initWithTitle:nil image:nil imagePressed:nil darkTextColor:YES reuseIdentifier:reuseIdentifier];
}

- (id)initWithTitle:(NSString *)title image:(UIImage *)image imagePressed:(UIImage *)imagePressed darkTextColor:(BOOL)darkTextColor reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self != nil)
	{
		[self setButton:[UIButton buttonWithType:UIButtonTypeCustom]];

		[[self button] setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
		[[self button] setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
		[[self button] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];

		[[self button] setTitle:title forState:UIControlStateNormal];	
		if (darkTextColor == YES)
		{
			[[self button] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		}
		else
		{
			[[self button] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		}
		
		[[button titleLabel] setFont:[UIFont boldSystemFontOfSize:20]];
		
		if ( image != nil )
		{
			UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
			[[self button] setBackgroundImage:newImage forState:UIControlStateNormal];
			[[self button] setBackgroundColor:[UIColor clearColor]];
		}
		else
		{
			[[self button] setBackgroundColor:[UIColor whiteColor]];
		}

		
		if ( imagePressed != nil )
		{
			UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
			[[self button] setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
		}
		
		// in case the parent view draws with a custom color or gradient, use a transparent color
		[[self contentView] addSubview:[self button]];
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [self setTitle:nil];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self setBackgroundView:nil];
	[[self button] setFrame:[[self contentView] bounds]];
}

- (void) setTitle:(NSString *)newTitle
{
	[[self button] setTitle:newTitle forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)seltor
{
	[[self button] addTarget:target action:seltor forControlEvents:UIControlEventTouchUpInside];
}

@end
