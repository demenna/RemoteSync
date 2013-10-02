/*
 * GVCUITabViewController.m
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCUITabBarController.h"
#import "GVCUINavigationController.h"

@implementation GVCUITabBarController

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}
    
	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

- (IBAction)dismissModalViewController:(id)sender
{
    UINavigationController *nav = [self navigationController];
    if ((nav != nil) && ([nav isKindOfClass:[GVCUINavigationController class]] == YES))
    {
        [(GVCUINavigationController *)[self navigationController] dismissModalViewController:sender];
    }
    else 
    {
        [self dismissModalViewControllerAnimated:YES];
    }
}

@end
