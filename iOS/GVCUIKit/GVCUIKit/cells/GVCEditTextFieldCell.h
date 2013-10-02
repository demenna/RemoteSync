//
//  DADataTextFieldCell.h
//
//  Created by David Aspinall on 10-04-13.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCEditCell.h"


@interface GVCEditTextFieldCell : GVCEditCell <UITextFieldDelegate> 

@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, assign) BOOL isSecure;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (UIKeyboardType)keyboardType;
- (void)setKeyboardType:(UIKeyboardType)kt;

- (UITextAutocapitalizationType)autocapitalizationType;
- (void)setAutocapitalizationType:(UITextAutocapitalizationType)kt;

- (UITextAutocorrectionType)autocorrectionType;
- (void)setAutocorrectionType:(UITextAutocorrectionType)kt;

@end

//@protocol GVCEditTextFieldCellDelegate <NSObject>
//@optional
//- (void) gvcEditCellDidBeginEditing:(GVCEditTextFieldCell *)editableCell;
//- (BOOL) gvcEditCellShouldReturn:(GVCEditTextFieldCell *)editableCell;
//- (void) gvcEditCell:(GVCEditTextFieldCell *)editableCell textChangedTo:(NSString *)newText;
//@end
