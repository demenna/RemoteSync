/*
 * GVCUIViewWithTableController.h
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

@interface GVCUIViewWithTableController : GVCUIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)reload:(id)sender;

@end
