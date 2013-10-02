//
//  GVCEditTextViewCell.h
//
//  Created by David Aspinall on 12-06-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCEditCell.h"

@interface GVCEditTextViewCell : GVCEditCell <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@end

