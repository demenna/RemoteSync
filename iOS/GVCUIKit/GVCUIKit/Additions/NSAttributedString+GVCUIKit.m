//
//  NSAttributedString+GVCUIKit.m
//
//  Created by David Aspinall on 12-04-19.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "NSAttributedString+GVCUIKit.h"
#import "GVCFoundation.h"

@implementation NSAttributedString (GVCUIKit)

+ (CTTextAlignment)gvc_CTTextAlignmentFromUITextAlignment:(NSTextAlignment)alignment
{
    CTTextAlignment ctAlign = kCTNaturalTextAlignment;
    switch (alignment) 
    {
		case UITextAlignmentLeft:
            ctAlign = kCTLeftTextAlignment;
            break;
		case UITextAlignmentCenter:
            ctAlign = kCTCenterTextAlignment;
            break;
		case UITextAlignmentRight:
            ctAlign = kCTRightTextAlignment;
            break;
        default: 
            break;
	}
    return ctAlign;
}

+ (CTLineBreakMode)gvc_CTTextLineBreakModeFromNSLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CTLineBreakMode ctMode = kCTLineBreakByWordWrapping;
	switch (lineBreakMode) 
    {
		case NSLineBreakByWordWrapping:
            ctMode = kCTLineBreakByWordWrapping;
            break;
		case NSLineBreakByCharWrapping:
            ctMode = kCTLineBreakByCharWrapping;
            break;
		case NSLineBreakByClipping:
            ctMode = kCTLineBreakByClipping;
            break;
		case NSLineBreakByTruncatingHead:
            ctMode = kCTLineBreakByTruncatingHead;
            break;
		case NSLineBreakByTruncatingTail:
            ctMode = kCTLineBreakByTruncatingTail;
            break;
		case NSLineBreakByTruncatingMiddle:
            ctMode = kCTLineBreakByTruncatingMiddle;
            break;
		default: 
            break;
	}
    return ctMode;
}

- (CGSize)gvc_sizeConstrainedToWidth:(CGFloat)width
{
    CGSize size = CGSizeMake(width, 0.);
    
    CFAttributedStringRef attributedStringRef = (__bridge CFAttributedStringRef)self;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attributedStringRef);
	CFRange fitCFRange = CFRangeMake(0,0);
	CGSize newSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, size, &fitCFRange);
    
	if (nil != framesetter) 
    {
        CFRelease(framesetter);
        framesetter = nil;
    }
    
	return CGSizeMake(ceilf(newSize.width), ceilf(newSize.height));
}

@end



@implementation NSMutableAttributedString (GVCUIKit)

- (void)gvc_setTextAlignment:(NSTextAlignment)align lineBreakMode:(NSLineBreakMode)mode
{
    [self gvc_setTextAlignment:align lineBreakMode:mode range:NSMakeRange(0, [self length])];

}
- (void)gvc_setTextAlignment:(NSTextAlignment)align lineBreakMode:(NSLineBreakMode)mode range:(NSRange)range
{
    CTTextAlignment textAlignment = [NSAttributedString gvc_CTTextAlignmentFromUITextAlignment:align];
    CTLineBreakMode lineBreak = [NSAttributedString gvc_CTTextLineBreakModeFromNSLineBreakMode:mode];
   
    CTParagraphStyleSetting paragraphStyles[2] = 
    {
        {
            .spec = kCTParagraphStyleSpecifierAlignment,
            .valueSize = sizeof(CTTextAlignment),
            .value = (const void*)&textAlignment
        },
		{
            .spec = kCTParagraphStyleSpecifierLineBreakMode,
            .valueSize = sizeof(CTLineBreakMode),
            .value = (const void*)&lineBreak
        },
	};
	CTParagraphStyleRef style = CTParagraphStyleCreate(paragraphStyles, 2);
    [self addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)style range:range];
    CFRelease(style);

}

- (void)gvc_setTextColor:(UIColor *)color range:(NSRange)range
{
    [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
	[self addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)color.CGColor range:range];
}
- (void)gvc_setTextColor:(UIColor *)color
{
    [self gvc_setTextColor:color range:NSMakeRange(0, [self length])];
}

- (void)gvc_setFont:(UIFont *)font range:(NSRange)range
{
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)[font fontName], [font pointSize], nil);
    [self removeAttribute:(NSString*)kCTFontAttributeName range:range];
	[self addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:range];
	CFRelease(fontRef);
}

- (void)gvc_setFont:(UIFont *)font
{
    [self gvc_setFont:font range:NSMakeRange(0, [self length])];
}


+ (NSMutableAttributedString *)gvc_MutableAttributedStringFromUILabel:(UILabel *)label
{
    GVC_ASSERT(label != nil, @"Label cannot be nil");
    
    NSMutableAttributedString* attributedString = nil;
    if (gvc_IsEmpty([label text]) == NO)
    {
        attributedString = [[NSMutableAttributedString alloc] initWithString:[label text]];
        
        [attributedString gvc_setFont:[label font]];
        [attributedString gvc_setTextColor:[label textColor]];
        [attributedString gvc_setTextAlignment:[label textAlignment] lineBreakMode:[label lineBreakMode]]; 
    }
    
    return attributedString;
}

+ (NSMutableAttributedString *)gvc_MutableAttributed:(NSString *)str font:(UIFont *)font color:(UIColor *)colr alignment:(NSTextAlignment)align lineBreakMode:(NSLineBreakMode)mode
{
    GVC_ASSERT(str != nil, @"String cannot be nil");
    GVC_ASSERT(font != nil, @"Font cannot be nil");
    GVC_ASSERT(colr != nil, @"Color cannot be nil");
    
    NSMutableAttributedString* attributedString = nil;
    if (gvc_IsEmpty(str) == NO)
    {
        attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attributedString gvc_setFont:font];
        [attributedString gvc_setTextColor:colr];
        [attributedString gvc_setTextAlignment:align lineBreakMode:mode];
    }
    
    return attributedString;
}


@end
