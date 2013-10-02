//
//  DATableViewController.h
//
//  Created by David Aspinall on 10-03-29.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCUITableViewController : UITableViewController <UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet id callbackDelegate;

@property (nonatomic, assign) BOOL autoresizesForKeyboard;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *tableFooterView;
@property (strong, nonatomic) IBOutlet UITableViewCell *cellTemplate;

- (NSString *)viewTitleKey;

- (IBAction)reload:(id)sender;

- (UITableViewCell *)dequeueOrLoadReusableCellFromClass:(Class)cellClass forTable:(UITableView *)tv withIdentifier:(NSString *)identifier;
- (UITableViewCell *)dequeueOrLoadReusableCellFromNib:(NSString *)cellNibName forTable:(UITableView *)tv withIdentifier:(NSString *)identifier;


/* Keyboard notifications */
-(void) resizeForKeyboard:(NSNotification *)notification appearing:(BOOL)appearing;

-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds animationDuration:(NSTimeInterval)aDuration;

-(void) keyboardDidAppear:(BOOL)animated withBounds:(CGRect)bounds;
-(void) keyboardDidDisappear:(BOOL)animated withBounds:(CGRect)bounds;

@end
