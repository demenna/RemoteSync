/*
 * GVCUINavigationController.h
 * 
 * Created by David Aspinall on 12-05-08. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */


#import <UIKit/UIKit.h>

@protocol GVCUIModalViewControllerModalDismiss <UINavigationControllerDelegate>
@optional
- (void)willDismissModalController;
@end

@interface GVCUINavigationController : UINavigationController

- (IBAction)dismissModalViewController:(id)sender;

@end
