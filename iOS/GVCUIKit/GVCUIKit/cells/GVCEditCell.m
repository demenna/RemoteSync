//
//  DADataEditCell.m
//
//  Created by David Aspinall on 10-04-12.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCEditCell.h"


@implementation GVCEditCell

@synthesize editPath;
@synthesize canSelectCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) 
	{
        // Initialization code
		self.accessoryType = UITableViewCellAccessoryNone;
		[self setCanSelectCell:NO];

    }
    return self;
}

- (void)setCanSelectCell:(BOOL)value
{
    if (value == YES)
	{
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
	else
	{
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    canSelectCell = value;
}


- (void)prepareForReuse 
{
	[self setEditPath:nil];
	[super prepareForReuse];
}

@end
