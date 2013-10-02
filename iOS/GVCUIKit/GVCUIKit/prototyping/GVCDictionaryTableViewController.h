//
//  DemoTableDictionaryController.h
//
//  Created by David Aspinall on 10-02-24.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUITableViewController.h"
#import "GVCFoundation.h"

GVC_DEFINE_EXTERN_STR( GVCDictionaryTableViewController_image );
GVC_DEFINE_EXTERN_STR( GVCDictionaryTableViewController_label );
GVC_DEFINE_EXTERN_STR( GVCDictionaryTableViewController_note );
GVC_DEFINE_EXTERN_STR( GVCDictionaryTableViewController_id );

@interface GVCDictionaryTableViewController : GVCUITableViewController

@property (strong) NSMutableDictionary *demoData;

+ (NSString *)imageKey;
+ (NSString *)labelKey;
+ (NSString *)noteKey;
+ (NSString *)identityKey;

- (NSDictionary *)rowAtIndexPath:(NSIndexPath *)indexPath;

- (NSArray *)sectionNames;
- (NSString *)sectionNameAtIndex:(NSUInteger)index;

- (NSArray *)sectionAtIndex:(NSUInteger)index;
- (NSArray *)rowsForSectionName:(NSString *)section;

- (NSMutableDictionary *)addRow:(NSDictionary *)rowData toSection:(NSString *)section;
- (NSMutableDictionary *)addRowWithImage:(NSString *)img label:(NSString *)lbl note:(NSString *)note toSection:(NSString *)section;
- (NSMutableDictionary *)addRowWithImage:(NSString *)img label:(NSString *)lbl note:(NSString *)note toSection:(NSString *)section withId:(NSString *)ident;


@end
