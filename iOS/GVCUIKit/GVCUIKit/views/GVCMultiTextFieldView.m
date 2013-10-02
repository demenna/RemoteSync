//
//  GVCMultiTextFieldView.m
//  GVCImmunization
//
//  Created by David Aspinall on 11-04-21.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import "GVCMultiTextFieldView.h"

#import "GVCFoundation.h"

@interface GVCMultiTextFieldView ()
@property (nonatomic, strong) NSMutableArray *multiTextFields;
@end

#define TITLE_LEFT_OFFSET 10
#define TITLE_TOP_OFFSET 6
#define TITLE_HEIGHT 30

#define VALUE_TOP_OFFSET 6
#define VALUE_HEIGHT 30

@implementation GVCMultiTextFieldView

@synthesize multiTextFields = _multiTextFields;
@synthesize nextKeyboardResponder = _nextKeyboardResponder;
@synthesize delegate;
@synthesize widths = _widths;

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame textFieldCount:1];
}

- (id)initWithFrame:(CGRect)frame textFieldCount:(int)textFieldCount
{
    self = [super initWithFrame:frame];
	if (self != nil) 
	{
		[self setTextFieldCount:textFieldCount];
    }
    return self;
}

- (void)setTextFieldCount:(int)textFieldCount
{
	GVC_ASSERT(textFieldCount > 0, @"Text Field Count must be greater then 0");
	[self setMultiTextFields:[NSMutableArray arrayWithCapacity:textFieldCount]];
	for(int i = 0; i < textFieldCount; i++)
	{
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
		textField.backgroundColor = [UIColor whiteColor];
		textField.font = [UIFont systemFontOfSize:16];
		textField.textColor = [UIColor colorWithRed:58.0/255.0 green:86.0/255.0 blue:138.0/255.0 alpha:1.0];
		textField.delegate = self;
		textField.returnKeyType = UIReturnKeyDone;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[[[self multiTextFields] lastObject] setReturnKeyType:UIReturnKeyNext];
		[[self multiTextFields] addObject:textField];
		
		[self addSubview:textField];
	}
}

- (int)textFieldCount
{
	return [[self multiTextFields] count];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)setNextKeyboardResponder:(UIResponder *)next
{
	[[[self multiTextFields] lastObject] setReturnKeyType:(next == NULL ? UIReturnKeyDone : UIReturnKeyNext)];
	_nextKeyboardResponder = next;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
	[textField resignFirstResponder];
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(multiTextField:textField:selected:)] == YES))
	{
		[delegate multiTextField:self textField:textField selected:NO];
	}
	
	if ([[self multiTextFields] indexOfObject:textField] + 1 == [[self multiTextFields] count])
	{
		if (_nextKeyboardResponder)
		{
			[_nextKeyboardResponder becomeFirstResponder];
		}
	}
	else
	{
		[[[self multiTextFields] objectAtIndex:[[self multiTextFields] indexOfObject:textField] + 1] becomeFirstResponder];
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(multiTextFieldShouldClear:textField:)] == YES))
	{
		return [delegate multiTextFieldShouldClear:self textField:textField];
	}
	return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(multiTextField:textField:shouldChangeCharactersInRange:replacementString:)] == YES))
	{
		return [delegate multiTextField:self textField:textField shouldChangeCharactersInRange:range replacementString:string];
	}
	
	return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(multiTextField:textField:selected:)] == YES))
	{
		[delegate multiTextField:self textField:textField selected:YES];
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	if ((delegate != nil) && ([delegate respondsToSelector:@selector(multiTextField:textField:selected:)] == YES))
	{
		[delegate multiTextField:self textField:textField selected:NO];
	}
}

- (void)layoutSubviews 
{
    [super layoutSubviews];
	
	if ( gvc_IsEmpty([self multiTextFields]) == NO )
	{
		if ( gvc_IsEmpty([self widths]) == YES )
		{
			NSInteger num = [[self multiTextFields] count];
			[self setWidths:[NSMutableArray arrayWithCapacity:num]];
			for ( NSInteger i = 0; i < num; i++ )
			{
				[[self widths] addObject:[NSNumber numberWithFloat:(float) (1.0 / (float)num)]];
			}
		}

		GVCLogInfo(@"widths %@", [self widths]);
		CGRect contentRect = [self bounds];
		if(contentRect.origin.x == 0.0) 
		{
			contentRect.origin.x = 10.0;
			contentRect.size.width -= 20;
		}
		
		float xoffset = contentRect.origin.x;
		float width = contentRect.size.width;
		float height = contentRect.size.height;
		CGRect frame;
		
		int count = [[self multiTextFields] count];
		float avaliableWidth = width - (count == 0 ? 0 : (TITLE_LEFT_OFFSET * (count - 1)));
		int i;
		for(i = 0; i < count; ++i)
		{
			UITextField *textField = [[self multiTextFields] objectAtIndex:i];
			
			float thisWidth = avaliableWidth * [[_widths objectAtIndex:i] floatValue];
			CGSize textSize = [@"Ig" sizeWithFont:textField.font];
			textSize.height = 31;
			frame = CGRectMake(xoffset, (height - textSize.height)/2, thisWidth, textSize.height);
			[textField setFrame:frame];
			xoffset += TITLE_LEFT_OFFSET + thisWidth;
		}
	}
}

- (UITextField *)textFieldAtIndex:(int)idx
{
	return [[self multiTextFields] objectAtIndex:idx];
}

- (void)setText:(NSString *)theText atIndex:(int)idx
{
	[[[self multiTextFields] objectAtIndex:idx] setText:theText];
}

- (void)setPlaceholder:(NSString *)theText atIndex:(int)idx
{
	
	[[[self multiTextFields] objectAtIndex:idx] setPlaceholder:theText];
}

- (NSString *)textAtIndex:(int)idx
{
	return [[[self multiTextFields] objectAtIndex:idx] text];
}

- (BOOL)respondsToSelector:(SEL)selector
{
    return [super respondsToSelector:selector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    return [super methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
    [super forwardInvocation:invocation];
}

@end
