/*
 * UITableViewCell+GVCUIKit.h
 * 
 * Created by David Aspinall on 12-06-19. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableViewCell (GVCUIKit)

+ (id)gvc_CellWithStyle:(UITableViewCellStyle)style forTableView:(UITableView *)tableView;

+ (id)gvc_CellForTableView:(UITableView *)tv;

+ (UITableViewCellStyle)gvc_DefaultCellStyle;

+ (NSString *)gvc_DefaultCellIdentifier;

- (CGFloat)gvc_heightForCell;

@end
