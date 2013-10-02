/*
 * GVCPageScrollviewController.m
 * 
 * Created by David Aspinall on 12-05-10. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCPageScrollviewController.h"
#import "GVCPageController.h"
#import "GVCFoundation.h"

@interface GVCPageScrollviewController ()
@property (assign, nonatomic) int firstVisiblePageIndexBeforeRotation;
@property (assign, nonatomic) CGFloat percentScrolledIntoFirstVisiblePage;

@property (nonatomic, strong) NSMutableArray *pageControllers;
@property (nonatomic, strong) NSMutableSet *visiblePages;
- (void)tilePages;
- (CGSize)contentSizeForPagingScrollView;
@end

@implementation GVCPageScrollviewController

@synthesize firstVisiblePageIndexBeforeRotation;
@synthesize percentScrolledIntoFirstVisiblePage;
@synthesize pageControl;
@synthesize scrollView;

@synthesize initialPosition;
@synthesize lastScrolledXPosition;
@synthesize pageControllers;
@synthesize visiblePages;

- (NSUInteger)pageCount
{
    return gvc_IsEmpty([self pageControllers]) ? 0 : [[self pageControllers] count];
}

- (NSUInteger)pageIndex:(GVCPageController *)page
{
    return gvc_IsEmpty([self pageControllers]) ? -1 : [[self pageControllers] indexOfObject:page];
}

- (void)addPageController:(GVCPageController *)page
{
    if ( [self pageControllers] == nil )
    {
        [self setPageControllers:[NSMutableArray arrayWithCapacity:1]];
        [self setVisiblePages:[NSMutableSet setWithCapacity:1]];
    }
    
    [[self pageControllers] addObject:page];
    [[self pageControl] setNumberOfPages:[[self pageControllers] count]];
    CGRect visibleBounds = [[self scrollView] bounds];
    CGFloat contentWidth = CGRectGetWidth(visibleBounds) * [self pageCount];
    [[self scrollView] setContentSize:CGSizeMake(contentWidth, visibleBounds.size.height)];

    [self tilePages];
}

- (NSArray *)allPageControllers
{
    return [[self pageControllers] copy];
}

- (GVCPageController *)pageControllerAtIndex:(NSUInteger)idx
{
    GVCPageController *page = nil;
    if ( gvc_IsEmpty([self pageControllers]) == NO) 
    {
        if ( [[self pageControllers] count] > idx )
        {
            page = [[self pageControllers] objectAtIndex:idx];
        }
    }
    return page;
}

- (GVCPageController *)removePageControllerAtIndex:(NSUInteger)idx
{
    GVCPageController *page = [self pageControllerAtIndex:idx];
    if ( page != nil )
    {
        [[self pageControllers] removeObject:page];
    }
    [[self pageControl] setNumberOfPages:[self pageCount]];
    [self tilePages];
    return page;
}

- (void)removeAllPageControllers
{
    [[self pageControllers] removeAllObjects];
    [[self visiblePages] removeAllObjects];
    [self tilePages];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (CGSize)contentSizeForPagingScrollView 
{
    CGRect bounds = [[self scrollView] bounds];
    return CGSizeMake(bounds.size.width * [self pageCount], bounds.size.height);
}

#define PADDING  10

- (CGRect)frameForPageAtIndex:(NSUInteger)index 
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = [[self scrollView] bounds];
    CGRect pageFrame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height);
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (GVCPageController *page in [self visiblePages]) 
    {
        if ([self pageIndex:page] == index) 
        {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)tilePages 
{
    if ( [self pageCount] > 0 )
    {
        // Calculate which pages are visible
        CGRect visibleBounds = [self scrollView].bounds;
        CGFloat visibleWidth = CGRectGetWidth(visibleBounds);
        CGFloat minx = MAX(CGRectGetMinX(visibleBounds), 0);
        CGFloat maxx = MAX(CGRectGetMaxX(visibleBounds), 0);
        NSUInteger firstNeededPageIndex = floorf(minx / visibleWidth);
        NSUInteger lastNeededPageIndex  = floorf((maxx - 1) / visibleWidth);
        firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
        
        // START:TileChanges
        NSUInteger maxPage = ([self scrollView].contentSize.width / visibleWidth);
        lastNeededPageIndex  = MIN(lastNeededPageIndex, maxPage);
        // END:TileChanges
        
        // START:ControlUpdates
        if (firstNeededPageIndex == lastNeededPageIndex) {
            [pageControl setCurrentPage:firstNeededPageIndex % [self pageCount]];
        }
        // END:ControlUpdates
        
        NSMutableSet *recycledPages = [[NSMutableSet alloc] initWithCapacity:0];
        for (GVCPageController *page in visiblePages) 
        {
            if ([self pageIndex:page] < firstNeededPageIndex || [self pageIndex:page] > lastNeededPageIndex) 
            {
                [[page view] removeFromSuperview];
                [recycledPages addObject:page]; 
            }
        }
        [visiblePages minusSet:recycledPages];
        
        // add missing pages
        for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++)
        {
            if ( [self isDisplayingPageForIndex:index] == NO) 
            {
                GVCPageController *page = [self pageControllerAtIndex:index];
                if ( page != nil )
                {
                    [[page view] setFrame:[self frameForPageAtIndex:index]];
                    
                    [page pageWillAppear];
                    [[self scrollView] addSubview:[page view]];
                    [visiblePages addObject:page];
                    [page pageDidAppear];
                }
            }
        }    
    }
}

#pragma mark -
#pragma mark PageControl support
- (void)scrollToPageIndex:(NSInteger)pageIndex animated:(BOOL)animated
{
    CGPoint scrollOffset = [self scrollView].contentOffset;
    CGFloat pageWidth = [[self scrollView] bounds].size.width;
    NSInteger currentPage = floorf(scrollOffset.x / pageWidth);
    
    NSInteger adjustedPage = currentPage % [self pageCount];
    NSInteger destinationPage = currentPage + (pageIndex - adjustedPage);
    
    scrollOffset.x = destinationPage * pageWidth;
    
    [[self scrollView] setContentOffset:scrollOffset animated:animated];
}

- (IBAction)pageControlTapped:(id)sender
{
    [self scrollToPageIndex:[[self pageControl] currentPage] animated:YES];
}

#pragma mark -
#pragma mark View controller rotation methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation 
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // here, our pagingScrollView bounds have not yet been updated for the new interface orientation. So this is a good
    // place to calculate the content offset that we will need in the new orientation
    CGFloat offset = [self scrollView].contentOffset.x;
    CGFloat pageWidth = [[self scrollView] bounds].size.width;
    
    if (offset >= 0) 
    {
        [self setFirstVisiblePageIndexBeforeRotation:floorf(offset / pageWidth)];
        [self setPercentScrolledIntoFirstVisiblePage:(offset - (firstVisiblePageIndexBeforeRotation * pageWidth)) / pageWidth];
    }
    else 
    {
        [self setFirstVisiblePageIndexBeforeRotation:0];
        [self setPercentScrolledIntoFirstVisiblePage:offset / pageWidth];
    }    
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation 
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self tilePages];

    // recalculate contentSize based on current orientation
    [[self scrollView] setContentSize:[self contentSizeForPagingScrollView]];
    
    // adjust frames and configuration of each visible page
    for (GVCPageController *page in visiblePages) 
    {
        //        CGPoint restorePoint = [[page view] pointToCenterAfterRotation];
        //        CGFloat restoreScale = [[page view] scaleToRestoreAfterRotation];
        [[page view] setFrame:[self frameForPageAtIndex:[self pageIndex:page]]];
    }
    
    // adjust contentOffset to preserve page location based on values collected prior to location
    CGFloat pageWidth = [[self scrollView] bounds].size.width;
    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth);// + (percentScrolledIntoFirstVisiblePage * pageWidth);
    [[self scrollView] setContentOffset:CGPointMake(newOffset, 0)];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    // recalculate contentSize based on current orientation
//    [[self scrollView] setContentSize:[self contentSizeForPagingScrollView]];
//    
//    // adjust frames and configuration of each visible page
//    for (GVCPageController *page in visiblePages) 
//    {
////        CGPoint restorePoint = [[page view] pointToCenterAfterRotation];
////        CGFloat restoreScale = [[page view] scaleToRestoreAfterRotation];
//        [[page view] setFrame:[self frameForPageAtIndex:[self pageIndex:page]]];
//    }
//    
//    // adjust contentOffset to preserve page location based on values collected prior to location
//    CGFloat pageWidth = [[self scrollView] bounds].size.width;
//    CGFloat newOffset = (firstVisiblePageIndexBeforeRotation * pageWidth);// + (percentScrolledIntoFirstVisiblePage * pageWidth);
//    [[self scrollView] setContentOffset:CGPointMake(newOffset, 0)];
//    [self tilePages];
//}

#pragma mark - Scrollview support
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
    [[self scrollView] setPagingEnabled:YES];
    [[self pageControl] setNumberOfPages:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self pageControl] setNumberOfPages:[self pageCount]];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [self tilePages];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)newScrollView
{
	//    CGFloat pageWidth = self.scrollView.frame.size.width;
	//    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
	//	NSInteger nearestNumber = lround(fractionalPage);
	//	DLog(@"nearestNumber: %d", nearestNumber);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)newScrollView
{
    //	[self scrollViewDidEndScrollingAnimation:newScrollView];
    //	
    //	CGFloat pageWidth = self.scrollView.frame.size.width;
    //    float fractionalPage = self.scrollView.contentOffset.x / pageWidth;
    //	NSInteger nearestNumber = lround(fractionalPage);
    //	self.pageControl.currentPage = nearestNumber;
    //	
    //	[self.appDelegate.savedLocation replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", nearestNumber]];
}

@end
