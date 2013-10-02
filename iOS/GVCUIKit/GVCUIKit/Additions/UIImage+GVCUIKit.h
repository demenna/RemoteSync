/*
 * UIImage+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>

// Credit: http://github.com/enormego/cocoa-helpers

@interface UIImage (UIImageGVCUIKit)

/*
 * Alternative to using imageNamed:, which caches
 * images and doesn't clear the cache.
 */
+ (UIImage *)gvc_newImageFromResource:(NSString *)filename;

/*
 * Creates an image from the contents of a URL
 */
+ (UIImage*)gvc_imageWithContentsOfURL:(NSURL*)url;

/*
 * Scales the image to the given size
 */
- (UIImage*)gvc_scaleToSize:(CGSize)size;

/*
 * Scales and crops the image to the given size
 * Automatically detects the size/height and offset
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)gvc_scaleAndCropToSize:(CGSize)size;

/*
 * Scales the height and crops the width to the size
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)gvc_scaleHeightAndCropWidthToSize:(CGSize)size;

/*
 * Scales the width and crops the height to the size
 * Sides of the image will be cropped so the result is centered
 */
- (UIImage*)gvc_scaleWidthAndCropHeightToSize:(CGSize)size;

/*
 * Scales image to the size, crops to the offset
 * Provide offset based on scaled size, not original size
 *
 * Example:
 * Image is 640x480, scaling to 480x320
 * This will then scale to 480x360
 *
 * If you want to vertically center the image, set the offset to CGPointMake(0.0,-20.0f)
 * Now it will clip the top 20px, and the bottom 20px giving you the desired 480x320
 */
- (UIImage*)gvc_scaleToSize:(CGSize)size withOffset:(CGPoint)offset;  

/* returns the UUID filename */
- (NSString *)gvc_saveAsUUIDInDirectory:(NSString *)dir;

/** saves as a PNG */
- (BOOL)gvc_saveImageToFile:(NSString *)path;

- (UIImage *)gvc_cropToRect:(CGRect)rect;

@end
