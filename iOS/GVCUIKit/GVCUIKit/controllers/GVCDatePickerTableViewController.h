//
//  GVCDatePickerTable.h
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

@protocol GVCDatePickerTableDelegate

@end

@interface GVCDatePickerTableViewController : GVCUIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITableView  *gvcTableView;;
@property (nonatomic, strong) NSString *labelKey;
@property (nonatomic, strong) NSString *detailKey;
@property (nonatomic, strong) NSDate *currentDate;
@property (strong,nonatomic) NSDate *minimumDate;
@property (strong,nonatomic) NSDate *maximumDate;

- (IBAction)dateChanged:(id)sender;

@end
