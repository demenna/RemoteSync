//
//  GVCBadgeView.h
//  Test
//
//  Created by David Aspinall on 11-03-15.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCBadgeView : UIView 

- (id)initWithFrame:(CGRect)frame;

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) UIColor *badgeColor;
@property (strong,nonatomic) UIFont *textFont;

- (IBAction)updateBadgeText:(id)sender;

@end
