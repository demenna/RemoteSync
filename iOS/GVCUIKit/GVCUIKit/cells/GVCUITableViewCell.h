//
//  GVCUITableViewCell.h
//
//  Created by David Aspinall on 10-12-07.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVCUITableViewCell : UITableViewCell

@property (assign,nonatomic) BOOL useDarkBackground;
@property (weak,nonatomic) id delegate;

+ (id)cellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView;

- (CGFloat)gvc_heightForCell;

@end
