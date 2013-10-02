/*
 * UITableView+GVCUIKit.m
 * 
 * Created by David Aspinall on 12-06-29. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "UITableView+GVCUIKit.h"

@implementation UITableView (GVCUIKit)

- (void)gvc_scrollToTop:(BOOL)animated
{
	[self setContentOffset:CGPointMake(0,0) animated:animated];
}

- (void)gvc_scrollToBottom:(BOOL)animated 
{
	NSUInteger sectionCount = [self numberOfSections];
	if (sectionCount > 0) 
	{
		NSUInteger rowCount = [self numberOfRowsInSection:(sectionCount-1)];
		if (rowCount > 0) 
		{
			NSIndexPath* indexPath = [NSIndexPath indexPathForRow:(rowCount-1) inSection:(sectionCount-1)];
			[self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
		}
	}
}

@end
