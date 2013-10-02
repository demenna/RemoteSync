
#import "GVCUIViewController.h"
#import "GVCFoundation.h"

@interface GVCUIViewController ()
-(void) keyboardWillShow:(NSNotification *)notification;
-(void) keyboardDidShow:(NSNotification *)notification;
-(void) keyboardDidHide:(NSNotification *)notification;
-(void) keyboardWillHide:(NSNotification *)notification;
@end


@implementation GVCUIViewController

@synthesize navigationBarStyle;
@synthesize navigationBarTintColor;
@synthesize statusBarStyle;	

@synthesize hasViewAppeared;
@synthesize isViewAppearing;

@synthesize autoresizesForKeyboard;
@synthesize managedObjectContext;
@synthesize callbackDelegate;

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self != nil)
	{
		[self setNavigationBarStyle:UIBarStyleDefault];
		[self setStatusBarStyle:UIStatusBarStyleDefault];
		navigationBarTintColor	= nil;
		hasViewAppeared			= NO;
		isViewAppearing			= NO;
		[self setAutoresizesForKeyboard:NO];
	}
	return self;
}

- (NSString *)viewTitleKey
{
	return @"viewTitle";
}

#pragma mark - UIViewController

-(void) viewWillAppear:(BOOL)animated 
{
	[super viewWillAppear:animated];
	isViewAppearing = YES;

//	UINavigationBar *bar	= [self navigationBar];
//	[bar setTintColor:[self navigationBarTintColor]];
//	[bar setBarStyle:[self navigationBarStyle]];
//	[[UIApplication sharedApplication] setStatusBarStyle:[self statusBarStyle] animated:YES];
	
	if (autoresizesForKeyboard == YES) 
	{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification  object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification  object:nil];
	}
}

-(void) viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
	hasViewAppeared = YES;
	
	[[[self navigationBar] topItem] setTitle:GVC_LocalizedClassString([self viewTitleKey], GVC_CLASSNAME(self))];
//	[[[self navigationBar] topItem] setTitle:GVC_LocalizedString([self viewTitleKey], [self viewTitleKey])];
}

-(void) viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	isViewAppearing = NO;
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification  object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification  object:nil];
}

-(void) viewDidDisappear:(BOOL)animated 
{
	[super viewDidDisappear:animated];
	hasViewAppeared = NO;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
	{
		return YES;
	}

	return [super shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration 
{
	return [super willAnimateRotationToInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
	return [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (UINavigationBar *)navigationBar
{
	return [[self navigationController] navigationBar];
}

- (IBAction)dismissModalViewController:(id)sender
{
    UIViewController *target = self;
    UINavigationController *navController = [self navigationController] ;
    if ( navController == nil )
    {
        target = [self parentViewController];
        if (target != nil)
        {
            if ([target isKindOfClass:[UINavigationController class]] == YES )
            {
                navController = (UINavigationController *)target;
            }
            else
            {
                navController = [target navigationController];
            }
        }
        else
        {
            target = [self presentingViewController];
            if (target != nil)
            {
                if ([target isKindOfClass:[UINavigationController class]] == YES )
                {
                    navController = (UINavigationController *)target;
                }
                else if ( [target navigationController] != nil )
                {
                    navController = [target navigationController];
                }
            }
        }
    }
    [navController dismissViewControllerAnimated:YES completion:^(){
        if ([[self callbackDelegate] respondsToSelector:NSSelectorFromString(@"tableView")] == YES ) 
        {
            id tv = [[self callbackDelegate] valueForKey:@"tableView"];
            if ((tv != nil) && ([tv isKindOfClass:[UITableView class]] == YES))
                [(UITableView *)tv reloadData];
        }
    }];
}


#pragma mark - UIKeyboardNotifications

-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing 
{
	NSDictionary *userInfo = [notification userInfo];
	
	// Get the ending frame rect
	NSValue *frameEndValue	= [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGRect keyboardRect = [frameEndValue CGRectValue];
	
	// Convert to window coordinates
	CGRect keyboardFrame = [[self view] convertRect:keyboardRect fromView:nil];
	
	NSNumber *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	BOOL animated = ([animationDurationValue doubleValue] > 0.0) ? YES : NO; 

	if (animated == YES) 
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:[animationDurationValue doubleValue]];
	}
	
	if (appearing == YES) 
	{
		[self keyboardWillAppear:animated withBounds:keyboardFrame];
		[self keyboardWillAppear:animated withBounds:keyboardFrame animationDuration:[animationDurationValue doubleValue]];
	}
	else 
	{
		[self keyboardDidDisappear:animated withBounds:keyboardFrame];
	}
	
	if (animated == YES) 
	{
		[UIView commitAnimations];
	}
}

-(void) keyboardWillShow:(NSNotification *)notification 
{
//	if ([self isViewAppearing] == YES) 
	{
		[self resizeForKeyboard:notification appearing:YES];
	}
}

-(void) keyboardDidShow:(NSNotification *)notification 
{
	CGRect frameStart;
	[[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&frameStart];
	
	CGRect keyboardBounds = CGRectMake(0, 0, frameStart.size.width, frameStart.size.height);
	[self keyboardDidAppear:YES withBounds:keyboardBounds];
}

-(void) keyboardDidHide:(NSNotification *)notification 
{
//	if ([self isViewAppearing] == YES) 
	{
		[self resizeForKeyboard:notification appearing:NO];
	}
}

-(void) keyboardWillHide:(NSNotification *)notification 
{
	CGRect frameEnd;
	[[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&frameEnd];
	CGRect keyboardBounds = CGRectMake(0, 0, frameEnd.size.width, frameEnd.size.height);
	
	NSTimeInterval animationDuration;
	NSValue *animationDurationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	[animationDurationValue getValue:&animationDuration];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds];
	[self keyboardWillDisappear:YES withBounds:keyboardBounds animationDuration:animationDuration];
}


#pragma mark - API

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self view] isKindOfClass:[UIScrollView class]] == YES )
	{
		UIEdgeInsets e = UIEdgeInsetsMake(0, 0, bounds.size.height, 0);
		
		[(UIScrollView *)[self view] setContentInset:e];
		[(UIScrollView *)[self view] setScrollIndicatorInsets:e];
	}
}

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{

}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
	if ( [[self view] isKindOfClass:[UIScrollView class]] == YES )
	{
		[(UIScrollView *)[self view] setContentInset:UIEdgeInsetsZero];
		[(UIScrollView *)[self view] setScrollIndicatorInsets:UIEdgeInsetsZero];
	}
}

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration 
{

}

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds 
{
}

-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds 
{
}


#pragma mark -

-(void) viewDidUnload 
{
	[super viewDidUnload];
}

-(void) didReceiveMemoryWarning 
{
	if ((hasViewAppeared == YES) && (isViewAppearing == NO)) 
	{
		[super didReceiveMemoryWarning];
		hasViewAppeared = NO;
	}
	else 
	{
		[super didReceiveMemoryWarning];
	}
}

@end
