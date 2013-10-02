//
//  GVCDetailViewController.h
//  MobileNotes
//
//  Created by David Aspinall on 12-06-21.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteEditTableViewController.h"
#import "SyncStatusTableViewController.h"

@class Note;

@interface GVCDetailViewController : UIViewController <UISplitViewControllerDelegate>

- (void)setDetailItem:(Note *)note;

@property (strong, nonatomic) IBOutlet NoteEditTableViewController *noteEditor;
@property (strong, nonatomic) IBOutlet SyncStatusTableViewController *syncStatus;


- (IBAction)resetLocal:(id)sender;

@end
