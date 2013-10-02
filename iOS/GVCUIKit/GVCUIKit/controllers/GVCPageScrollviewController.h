/*
 * GVCPageScrollviewController.h
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "GVCUIViewController.h"

@class GVCPageController;

@interface GVCPageScrollviewController : GVCUIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger initialPosition;
@property (nonatomic, assign) CGFloat lastScrolledXPosition;

- (NSUInteger)pageCount;
- (NSArray *)allPageControllers;
- (void)addPageController:(GVCPageController *)page;
- (GVCPageController *)pageControllerAtIndex:(NSUInteger)idx;
- (GVCPageController *)removePageControllerAtIndex:(NSUInteger)idx;
- (void)removeAllPageControllers;

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

@end
