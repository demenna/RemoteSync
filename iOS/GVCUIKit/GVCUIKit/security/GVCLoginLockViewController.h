/*
 * GVCLoginLockViewController.h
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GVCFoundation.h"
#import "GVCLockViewController.h"

GVC_DEFINE_EXTERN_STR(GVCLoginLockViewController_USERNAME_KEY);
GVC_DEFINE_EXTERN_STR(GVCLoginLockViewController_PASSWORD_KEY);

@interface GVCLoginLockViewController : GVCLockViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordConfirmLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end
