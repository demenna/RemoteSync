/*
 * GVCLoginLockViewController.m
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCLoginLockViewController.h"

GVC_DEFINE_STRVALUE(GVCLoginLockViewController_USERNAME_KEY, username);
GVC_DEFINE_STRVALUE(GVCLoginLockViewController_PASSWORD_KEY, password);

@interface GVCLoginLockViewController ()
- (void)simulatedSuccess:(id)sender;
- (void)simulatedFail:(id)sender;
@end

@implementation GVCLoginLockViewController

@synthesize activityIndicator;
@synthesize usernameLabel;
@synthesize passwordLabel;
@synthesize passwordConfirmLabel;
@synthesize usernameField;
@synthesize passwordField;
@synthesize passwordConfirmField;
@synthesize loginButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) 
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setActivityIndicator:nil];
    [self setUsernameLabel:nil];
    [self setUsernameField:nil];
    [self setPasswordLabel:nil];
    [self setPasswordField:nil];
    [self setPasswordConfirmLabel:nil];
    [self setPasswordConfirmField:nil];
    [self setLoginButton:nil];

    [super viewDidUnload];
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
    [[self statusLabel] setHidden:YES];

	[[self usernameLabel] setText:GVC_LocalizedString(@"Username", @"Username")];
	[[self passwordLabel] setText:GVC_LocalizedString(@"Password", @"Password")];
	[[self usernameField] setPlaceholder:GVC_LocalizedString(@"UsernamePlaceholder", @"john")];
	[[self passwordField] setPlaceholder:GVC_LocalizedString(@"PasswordPlaceholder", @"password")];
	[[self passwordField] setSecureTextEntry:YES];

	if (([self lockMode] == GVCLockViewControllerMode_SET) || ([self lockMode] == GVCLockViewControllerMode_CHANGE))
    {
        [[self passwordConfirmLabel] setText:GVC_LocalizedString(@"PasswordConfirm", @"Confirm Password")];
        [[self passwordConfirmField] setPlaceholder:GVC_LocalizedString(@"PasswordConfirmPlaceholder", @"password")];
        [[self passwordConfirmField] setSecureTextEntry:YES];
        [[self passwordConfirmField] setEnabled:YES];
    	[[self passwordConfirmField] setDelegate:self];
        [[self loginButton] setTitle:GVC_SAVE_LABEL forState:UIControlStateNormal];
    }
    else
    {
        [[self loginButton] setTitle:GVC_LOGIN_LABEL forState:UIControlStateNormal];
    }
	
	[[self usernameField] setEnabled:YES];
	[[self usernameField] setDelegate:self];
	[[self passwordField] setEnabled:YES];
	[[self passwordField] setDelegate:self];

	[[self loginButton] setEnabled:YES];
	
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
	if ( username != nil )
	{
		[[self usernameField] setText:username];
	}
}


- (IBAction)loginAction:(id)sender 
{
    [[self view] resignFirstResponder];
    [[self activityIndicator] startAnimating];
	[[self statusLabel] setHidden:NO];
	[[self statusLabel] setTextColor:[UIColor blackColor]];
	[[self statusLabel] setText:GVC_LocalizedString(@"VerifyLogin", @"Verifying ..")];

    [[self usernameField] setEnabled:NO];
	[[self passwordField] setEnabled:NO];
	[[self loginButton] setEnabled:NO];
    if (([self lockMode] == GVCLockViewControllerMode_SET) || ([self lockMode] == GVCLockViewControllerMode_CHANGE))
    {
        [[self passwordConfirmField] setEnabled:NO];
    }

    NSString *failMessage = nil;
    NSString *enteredUsername = [[self usernameField] text];
    NSString *enteredPassword = [[self passwordField] text];
    NSString *enteredConfirm = [[self passwordConfirmField] text];
    NSString *username = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
    NSString *password = [[GVCKeychain sharedGVCKeychain] secureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
    BOOL success = NO;
    
    if ((gvc_IsEmpty(enteredUsername) == NO) && (gvc_IsEmpty(enteredPassword) == NO))
    {
        switch ([self lockMode])
        {
            case GVCLockViewControllerMode_CHANGE:
            {
                GVC_ASSERT_VALID_STRING(username);
                GVC_ASSERT_VALID_STRING(password);
                
                if ( [enteredPassword isEqualToString:enteredConfirm] == YES )
                {
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredUsername forKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredPassword forKey:GVCLoginLockViewController_PASSWORD_KEY];
                    success = YES;
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"ConfirmPasswordMissmatch", @"Passwords do not match");
                }
                break;
            }
            case GVCLockViewControllerMode_SET:
                if ( [enteredPassword isEqualToString:enteredConfirm] == YES )
                {
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredUsername forKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] setSecureObject:enteredPassword forKey:GVCLoginLockViewController_PASSWORD_KEY];
                    success = YES;
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"ConfirmPasswordMissmatch", @"Passwords do not match");
                }
                break;
            case GVCLockViewControllerMode_UNLOCK:
            {
                GVC_ASSERT_VALID_STRING(username);
                GVC_ASSERT_VALID_STRING(password);
                
                success = (([[[self usernameField] text] isEqualToString:username]) && ([[[self passwordField] text] isEqualToString:password]));
                if ( success == NO )
                {
                    failMessage = GVC_LocalizedString(@"LoginFailed", @"Login Failed");
                }
                break;
            }
            case GVCLockViewControllerMode_REMOVE:
                if (([[[self usernameField] text] isEqualToString:username]) && ([[[self passwordField] text] isEqualToString:password]))
                {
                    [[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_USERNAME_KEY];
                    [[GVCKeychain sharedGVCKeychain] removeSecureObjectForKey:GVCLoginLockViewController_PASSWORD_KEY];
                }
                else
                {
                    failMessage = GVC_LocalizedString(@"LoginFailed", @"Login Failed");
                }

                break;
                
            default:
                break;
        }
    }
    else
    {
        failMessage = GVC_LocalizedString(@"MissingUsernameOrPassword", @"Please enter username and password");
    }
                    
    
    if ( success == YES )
	{
        [self performSelector:@selector(simulatedSuccess:) withObject:nil afterDelay:0.5];
	}
    else
    {
        [self performSelector:@selector(simulatedFail:) withObject:failMessage afterDelay:1.5];
	}
}

- (void)simulatedSuccess:(NSString *)message 
{
    [[self usernameField] setEnabled:YES];
	[[self passwordField] setEnabled:YES];
	[[self passwordConfirmField] setEnabled:YES];
	[[self loginButton] setEnabled:YES];

	[activityIndicator stopAnimating];
	[[self statusLabel] setTextColor:[UIColor darkGrayColor]];
    [[self statusLabel] setText:(gvc_IsEmpty(message) ? @"Success" : message)];
    [super loginAction:nil];
}

- (void)simulatedFail:(NSString *)message 
{
    [[self usernameField] setEnabled:YES];
	[[self passwordField] setEnabled:YES];
	[[self passwordConfirmField] setEnabled:YES];
	[[self loginButton] setEnabled:YES];
    
	[activityIndicator stopAnimating];
	[[self statusLabel] setTextColor:[UIColor redColor]];
	[[self statusLabel] setText:(gvc_IsEmpty(message) ? @"Fail" : message)];
    [passwordField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ( textField == usernameField )
    {
        [passwordField becomeFirstResponder];
    }
    else if ( textField == passwordField )
    {
        if ( passwordConfirmField == nil )
        {
            [self loginAction:textField];
        }
        else
        {
            [passwordConfirmField becomeFirstResponder];
        }
    }
    else 
    {
        [self loginAction:textField];
    }
    return YES;
}

@end
