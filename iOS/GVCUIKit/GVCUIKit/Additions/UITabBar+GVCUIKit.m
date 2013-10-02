/*
 * UITabBar+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UITabBar+GVCUIKit.h"

@implementation UITabBar (GVCUIKit)

- (NSUInteger)gvc_selectedIndex 
{
    return [[self items] indexOfObject:[self selectedItem]];
}

- (void)gvc_setSelectedIndex:(NSUInteger)newIndex 
{
    [self setSelectedItem:[[self items] objectAtIndex:newIndex]];
}

@end
