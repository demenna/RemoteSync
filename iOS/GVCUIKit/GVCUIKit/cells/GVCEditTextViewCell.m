//
//  GVCEditTextViewCell.m
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCEditTextViewCell.h"
#import "UITextView+GVCUIKit.h"

@interface GVCEditTextViewCell ()

@end


@implementation GVCEditTextViewCell

@synthesize textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        [self setTextView:[[UITextView alloc] initWithFrame:CGRectZero]];
        [[self textView] setFont:[UIFont boldSystemFontOfSize:14.0]];
        [[self textView] setDelegate:self];
        [[self contentView] addSubview:[self textView]];
    }
    return self;
}


- (void)layoutSubviews 
{
    [super layoutSubviews];
	CGRect r = CGRectInset(self.contentView.bounds, 8, 8);
    if ( [self textLabel] != nil )
	{
        CGSize textLabelSize = [[self textLabel] bounds].size;
		textLabelSize.width += 10.0;
        r.origin.x += textLabelSize.width;
        r.size.width -= textLabelSize.width;
	}

	[[self textView] setFrame:r];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlight animated:(BOOL)animated 
{
    [super setHighlighted:highlight animated:animated];

	if (highlight == YES)
    {
		[[self textView] setTextColor:[UIColor whiteColor]];
    }
	else
    {
		[[self textView] setTextColor:[UIColor blackColor]];
    }
}

- (void)prepareForReuse 
{
    [super prepareForReuse];
    
    [[self textView] setText:nil];
    [[self textView] setDelegate:nil];
}

#pragma mark Text Field
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)txtView
{
	return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)txtView
{
	return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)txtView
{
    //	((UITableView*)[self superview]).scrollEnabled = YES;
    UITableView *tv = (UITableView *) [self superview];
    [tv scrollToRowAtIndexPath:[tv indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCellDidBeginEditing:)])
	{
		[[self delegate] gvcEditCellDidBeginEditing:self];
	}
}

// saving here occurs both on return key and changing away
- (void)textViewDidEndEditing:(UITextView *)txtView
{
    //	((UITableView*)[self superview]).scrollEnabled = YES;
    UITableView *tv = (UITableView *) [self superview];
    [tv scrollToRowAtIndexPath:[tv indexPathForCell:self] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	if (([self delegate] != nil) && [[self delegate] respondsToSelector:@selector(gvcEditCell:textChangedTo:)])
	{
		[[self delegate] gvcEditCell:self textChangedTo:[txtView text]];
	}
}	

- (CGFloat)gvc_heightForCell
{
    CGFloat height = MAX(100.0, [super gvc_heightForCell]);
    if ([self textView] != nil )
    {
        height = MAX([[self textView] gvc_heightForCell], height);
    }
    return height;
}

@end
