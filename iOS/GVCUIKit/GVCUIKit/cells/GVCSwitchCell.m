//
//  GVCSwitchCell.m
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCSwitchCell.h"

@interface GVCSwitchCell ()

@end


@implementation GVCSwitchCell

@synthesize switchControl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [self setSwitchControl:[[UISwitch alloc] init]];
        [self setAccessoryView:[self switchControl]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    [[self switchControl] setOn:NO];
}


@end
