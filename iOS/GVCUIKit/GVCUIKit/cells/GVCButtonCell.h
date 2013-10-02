//
//  DAButtonCell.h
//
//  Created by David Aspinall on 10-04-05.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCButtonCell : UITableViewCell 

- (id)initWithTitle:(NSString *)title image:(UIImage *)image imagePressed:(UIImage *)imagePressed darkTextColor:(BOOL)darkTextColor reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *centerLabel;

- (void) setTitle:(NSString *)newTitle;
- (void)addTarget:(id)target action:(SEL)select;

@end
