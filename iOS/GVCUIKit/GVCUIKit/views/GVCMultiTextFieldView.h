//
//  GVCMultiTextFieldView.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-04-21.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GVCMultiTextFieldDelegate;

@interface GVCMultiTextFieldView : UIView  <UITextFieldDelegate>

@property (nonatomic, assign) id<GVCMultiTextFieldDelegate> delegate;
@property (nonatomic, strong) UIResponder *nextKeyboardResponder;
@property (nonatomic, strong) NSMutableArray *widths;

- (id)initWithFrame:(CGRect)frame textFieldCount:(int)textFieldCount;

- (void)setTextFieldCount:(int)textFieldCount;
- (int)textFieldCount;

- (UITextField *)textFieldAtIndex:(int)index;

- (void)setText:(NSString *)theText atIndex:(int)index;
- (NSString *)textAtIndex:(int)index;

- (void)setPlaceholder:(NSString *)theText atIndex:(int)index;

@end


@protocol GVCMultiTextFieldDelegate <NSObject>
@optional
- (BOOL)multiTextFieldShouldClear:(GVCMultiTextFieldView *)cell textField:(UITextField *)textField;
- (void)multiTextField:(GVCMultiTextFieldView *)cell textField:(UITextField *)textField selected:(BOOL)selected;
- (BOOL)multiTextField:(GVCMultiTextFieldView *)cell textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
@end
