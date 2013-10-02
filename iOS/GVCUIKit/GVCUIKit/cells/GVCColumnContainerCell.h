//
//  GVCColumnContainerCell.h
//
//  Created by David Aspinall on 12-06-20.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GVCUIKit.h"
#import "GVCUITableViewCell.h"

@interface GVCSizedColumn : NSObject
- (id)init:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent;
@property (weak, nonatomic) UIView *columnView;
@property (assign, nonatomic) NSUInteger columnIndex;
@property (assign, nonatomic) CGFloat sizePercentage;
@end

@interface GVCColumnContainerCell : GVCUITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithStyle:(UITableViewCellStyle)style forUILabelSizes:(NSArray *)set reuseIdentifier:(NSString *)reuseIdentifier;

- (void)removeAll;

- (void)addSizedColumn:(GVCSizedColumn *)part;
- (void)addView:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent;
- (void)addUILabel:(NSUInteger)idx forSize:(CGFloat)percent;

- (NSUInteger)viewCount;
- (GVCSizedColumn *)columnAtIndex:(NSUInteger)idx;
- (UIView *)viewAtIndex:(NSUInteger)index;

@end
