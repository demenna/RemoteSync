/*
 * UIViewController+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@protocol UITableViewDynamicContentController
// passes array of index paths.
- (void)loadDynamicContentForIndexPaths:(NSArray *)pathArray;
@end

@interface UIViewController (GVCUIKit)

@end
