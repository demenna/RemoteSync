    //
//  DADataDateCell.m
//
//  Created by David Aspinall on 10-04-15.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCEditDateCell.h"


@implementation GVCEditDateCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
	{
		[self setCanSelectCell:YES];
    }
    return self;
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
}

- (CGFloat)gvc_heightForCell
{
    return [super gvc_heightForCell];
}
@end
