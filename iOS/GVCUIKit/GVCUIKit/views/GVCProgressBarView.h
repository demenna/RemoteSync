//
//  GVCProgressBarView.h
//  HL7Domain
//
//  Created by David Aspinall on 10-12-09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GVCProgressBarView : UIView 

+ (GVCProgressBarView *)standardWhiteProgressView;
+ (GVCProgressBarView *)standardDarkGreyProgressView;

- (id)initWithFrame:(CGRect)frame;

// progress value in range of 0 to 100
@property (assign,nonatomic) float progress; 
@property (strong,nonatomic) UIColor *barProgressColor;

- (IBAction)updateProgress:(id)sender;

@end
