/*
 * UITabBar+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UITabBar(GVCUIKit)
- (NSUInteger)gvc_selectedIndex;
- (void)gvc_setSelectedIndex:(NSUInteger)newIndex;
@end
