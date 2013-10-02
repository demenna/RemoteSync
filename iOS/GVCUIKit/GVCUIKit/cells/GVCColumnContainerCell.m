//
//  GVCColumnContainerCell.m
//
//  Created by David Aspinall on 12-06-20.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCColumnContainerCell.h"

@interface GVCColumnContainerCell ()
@property (nonatomic, strong) NSMutableArray *widths;
- (BOOL)reconcileViewsAndSizes;
@end


@implementation GVCColumnContainerCell

@synthesize widths;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
    }
    return self;
}


- (id)initWithStyle:(UITableViewCellStyle)style forUILabelSizes:(NSArray *)set reuseIdentifier:(NSString *)reuseIdentifier;
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil)
    {
        for ( NSObject *obj in set )
        {
            GVC_ASSERT([obj isKindOfClass:[GVCSizedColumn class]], @"Invalid class for lable size %@", obj);
            [self addSizedColumn:(GVCSizedColumn *)obj];
        }
    }
    return self;
}

#pragma mark - column view management
- (void)removeAll
{
    [[self widths] removeAllObjects];
}

- (void)addView:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent
{
    [self addSizedColumn:[[GVCSizedColumn alloc] init:view atIndex:idx forSize:percent]];
}

- (void)addUILabel:(NSUInteger)idx forSize:(CGFloat)percent
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//    [label setBackgroundColor:[self backgroundColor]];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [label setTextColor:[UIColor blackColor]];
    [label setHighlightedTextColor:[UIColor whiteColor]];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setAdjustsFontSizeToFitWidth:YES];
    [label setBaselineAdjustment:UIBaselineAdjustmentNone];

    [self addView:label atIndex:idx forSize:percent];
}

- (void)addSizedColumn:(GVCSizedColumn *)part
{
    if ( [self widths] == nil )
    {
        [self setWidths:[[NSMutableArray alloc] initWithCapacity:10]];
    }
    [[self widths] addObject:part];
    if ( [[[self contentView] subviews] containsObject:[part columnView]] == NO )
    {
        [[self contentView] addSubview:[part columnView]];
    }

    [self setNeedsLayout];
}

- (NSUInteger)viewCount
{
    return [[self widths] count];
}

- (GVCSizedColumn *)columnAtIndex:(NSUInteger)idx
{
    GVCSizedColumn *column = nil;
    if (([self reconcileViewsAndSizes] == YES) && (idx < [[self widths] count]))
    {
        column = [[self widths] objectAtIndex:idx];
    }
    
    return  column;
}

- (UIView *)viewAtIndex:(NSUInteger)idx
{
    GVCSizedColumn *column = [self columnAtIndex:idx];
    return (column == nil ? nil : [column columnView]);
}



#pragma mark - UITableView overrides
- (void)prepareForReuse 
{
    [super prepareForReuse];
}

#pragma mark - reconcile and layout
- (BOOL)reconcileViewsAndSizes
{
    BOOL success = NO;
    
    NSArray *columnViews = [[self contentView] subviews];
    if ([[self widths] count] != [columnViews count])
    {
        // both have values, but mismatched, abandon current widths
        [self removeAll];
    }
    
    if (gvc_IsEmpty([self widths]) == YES)
    {
        if (gvc_IsEmpty(columnViews) == NO)
        {
            // build widths from the initial size of each label
            // margin between views
            CGFloat marginSpace = ([columnViews count] -1) * 5.0;
            __block CGFloat maxWidth = 0.0;
            [columnViews gvc_performOnEach:^(id item) {
                UIView *view = (UIView *)item;
                CGFloat boundWidth = [view bounds].size.width;
                if ( boundWidth <= 0.0 )
                {
                    boundWidth = [[self contentView] bounds].size.width / [columnViews count];
                }
                maxWidth += boundWidth;
            }];
            maxWidth += marginSpace;
            
            [columnViews gvc_performOnEach:^(id item) {
                UIView *view = (UIView *)item;
                CGFloat boundWidth = [view bounds].size.width;
                if ( boundWidth <= 0.0 )
                {
                    boundWidth = [[self contentView] bounds].size.width / [columnViews count];
                }
                [self addView:view atIndex:[columnViews indexOfObject:view] forSize:(boundWidth / maxWidth) * 100];
            }];
            success = YES;
        }
    }
    else if (gvc_IsEmpty(columnViews) == YES)
    {
        // views should already be in subview
        [self removeAll];
    }
    else
    {
        success = YES;
    }
    
    GVC_ASSERT([[self widths] count] == [columnViews count], @"Mismatched widths and labels");
    [[self widths] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult rslt = NSOrderedSame;
        
        if ([(GVCSizedColumn *)obj1 columnIndex] > [(GVCSizedColumn *)obj2 columnIndex]) 
        {
            rslt = NSOrderedDescending;
        }
        else
        {
            rslt = NSOrderedAscending;
        }
        
        return rslt;
    }];
    return success;
}



- (void)layoutSubviews 
{
    [super layoutSubviews];
    if ( [self reconcileViewsAndSizes] == YES )
    {
        float insetWidth = 10;
        if ( [self accessoryType] != UITableViewCellAccessoryNone )
            insetWidth = 40;
        UIEdgeInsets inset = UIEdgeInsetsMake( 0, 5, 0, insetWidth);
        CGRect myBounds = UIEdgeInsetsInsetRect([[self contentView] bounds], inset);
        CGFloat nextLabelPosition = myBounds.origin.x;
        
        for (GVCSizedColumn *portion in [self widths])
        {
            UIView *label = [portion columnView];
            if ( label != nil )
            {
                CGRect labelRect = [label bounds];
                
                labelRect.origin.x = nextLabelPosition;
                labelRect.origin.y = myBounds.origin.y;
                labelRect.size.width = floorf(myBounds.size.width * ([portion sizePercentage]/100.0));
                labelRect.size.height = myBounds.size.height;
                [label setFrame:labelRect];
                
                nextLabelPosition = CGRectGetMaxX(labelRect) + 5;
            }
        }
    }
}

- (CGFloat)gvc_heightForCell
{
    CGFloat height = MAX(44.0, [[self contentView] bounds].size.height);
    NSArray *columnViews = [[self contentView] subviews];
    for ( UIView *aview in columnViews )
    {
        height = MAX([aview gvc_heightForCell], height);
    }
    return height;
}

@end


@implementation GVCSizedColumn

@synthesize columnView;
@synthesize columnIndex;
@synthesize sizePercentage;

- (id)init:(UIView *)view atIndex:(NSUInteger)idx forSize:(CGFloat)percent
{
    self = [super init];
    if (self != nil) 
    {
        [self setColumnView:view];
        [self setColumnIndex:idx];
        [self setSizePercentage:percent];
    }
    return self;
}

- (id)init
{
    return [self init:nil atIndex:0 forSize:0.0];
}

- (NSString *)description
{
    return GVC_SPRINTF(@"%@ (%d) %f %@", [super description], [self columnIndex], [self sizePercentage], [self columnView]);
}
@end

