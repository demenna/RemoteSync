//
//  DAMultiLineTableViewCell.h
//
//  Created by David Aspinall on 16/09/09.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVCUITableViewCell.h"

/**
 * $Date: 2009-11-12 13:39:38 -0500 (Thu, 12 Nov 2009) $
 * $Rev: 46 $
 * $Author: david $
*/
@interface GVCMultiLineTableViewCell : GVCUITableViewCell <UITextViewDelegate>

@property (nonatomic, strong) UILabel *textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier;
- (void)setText:(NSString *)text;

+ (CGFloat)heightForWidth:(CGFloat)width withText:(NSString *)text;


@end
