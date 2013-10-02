/*
 * UIColor+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>


@interface UIColor (GVCUIKit)

-(BOOL)gvc_isMonochrome;

-(CGFloat)gvc_red;
-(CGFloat)gvc_green;
-(CGFloat)gvc_blue;

-(CGFloat)gvc_hue;
-(CGFloat)gvc_saturation;
-(CGFloat)gvc_brightness;

-(CGFloat)gvc_alpha;

-(void)gvc_rgba:(float[4])arr;
-(void)gvc_hsba:(float[4])arr;

-(UIColor *)gvc_reverseColor;

@end

void GVC_RGB2HSL(float r, float g, float b, float* outH, float *outS, float *outV);
void GVC_HSL2RGB(float h, float s, float l, float* outR, float* outG, float* outB);
