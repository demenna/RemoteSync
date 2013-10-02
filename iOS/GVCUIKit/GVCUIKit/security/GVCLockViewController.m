/*
 * GVCLockViewController.m
 * 
 * Created by David Aspinall on 12-06-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCLockViewController.h"
#import "GVCFoundation.h"

@interface GVCLockViewController ()
@end

@implementation GVCLockViewController

@synthesize statusLabel;
@synthesize lastError;
@synthesize successBlock;
@synthesize failBlock;
@synthesize lockMode;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initForMode:GVCLockViewControllerMode_UNLOCK nibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (id)initForMode:(GVCLockViewControllerMode)mode nibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self != nil) 
    {
        [self setLockMode:mode];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

- (IBAction)loginAction:(id)sender 
{
    if ( self.successBlock != nil )
    {
        self.successBlock(nil);
    }
}

- (IBAction)cancelAction:(id)sender
{
    if ( self.failBlock != nil )
    {
        self.failBlock([self lastError]);
    }
}

@end
