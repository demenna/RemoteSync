//
//  GVCRoundBorderView.h
//  GVCImmunization
//
//  Created by David Aspinall on 11-02-08.
//  Copyright 2011 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCRoundBorderView : UIView

@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIColor *contentColor;


@property (assign, nonatomic) NSInteger borderWidth;
@property (assign, nonatomic) NSInteger cornerRadius;

@end
