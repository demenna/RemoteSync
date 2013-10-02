/*
 * UIImage+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import <CoreGraphics/CoreGraphics.h>

#import "UIImage+GVCUIKit.h"
#import "GVCFoundation.h"

// Credit: http://github.com/enormego/cocoa-helpers

@implementation UIImage (UIImageGVCUIKit)

+ (UIImage *)gvc_newImageFromResource:(NSString *)filename {
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
    return [[UIImage alloc] initWithContentsOfFile:imageFile];
}

+ (UIImage*)gvc_imageWithContentsOfURL:(NSURL*)url {
    NSError* error;
    NSData* data = [NSData dataWithContentsOfURL:url options:0 error:&error];
    if(error || !data) {
        return nil;
    } else {
        return [UIImage imageWithData:data];
    }
}

- (UIImage*)gvc_scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/*
 What you're asking for is pretty easy. Calculate the different scaling factors for the width and the height, then pick the larger one for your actual scale factor. Multiply your input size by the scale, and crop whichever one comes out too large.
 
 scale = max(maxwidth/oldwidth, maxheight/oldheight)
 scaledwidth = oldwidth * scale
 scaledheight = oldheight * scale
 if scaledheight > maxheight:
 croptop = (scaledheight - maxheight) / 2
 cropbottom = (scaledheight - maxheight) - croptop
 if scaledwidth > maxwidth:
 cropleft = (scaledwidth - maxwidth) / 2
 cropright = (scaledwidth - maxwidth) - cropleft
 */
- (UIImage*)gvc_scaleAndCropToSize:(CGSize)size 
{
	CGFloat scale = MAX(size.width/self.size.width, size.height/self.size.height);
	CGFloat scaledWidth = self.size.width * scale;
	CGFloat scaledHeight = self.size.height * scale;
	CGSize scaleSize = CGSizeMake(scaledWidth, scaledHeight);
	CGRect cropRect = CGRectMake(0.0, 0.0, scaledWidth, scaledHeight);

	if ( scaledHeight > size.height )
	{
		cropRect.size.height = size.height; // (scaledHeight - size.height) / 2.0;
		cropRect.origin.y = (scaledHeight - size.height) / 2.0; //- cropRect.size.height;
	}

	if ( scaledWidth > size.width )
	{
		cropRect.size.width = size.width; //(scaledWidth - size.width) / 2.0;
		cropRect.origin.x = (scaledWidth - size.width) / 2.0; //- cropRect.size.width;
	}

	// scale the image
	UIGraphicsBeginImageContext(scaleSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, scaleSize.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, scaleSize.width, scaleSize.height), self.CGImage);
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
	
	[scaledImage gvc_saveImageToFile:@"/tmp/scaled.png"];
    
	return [scaledImage gvc_cropToRect:cropRect];
}

- (UIImage *)gvc_cropToRect:(CGRect)rect
{
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClipToRect( context, rect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(0, 0, self.size.width, self.size.height);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(context, drawRect, self.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	[cropped gvc_saveImageToFile:@"/tmp/cropped.png"];

	return cropped;
	
}

- (UIImage*)gvc_scaleHeightAndCropWidthToSize:(CGSize)size 
{
    float newWidth = (self.size.width * size.height) / self.size.height;
    return [self gvc_scaleToSize:size withOffset:CGPointMake((newWidth - size.width) / 2, 0.0f)];
}

- (UIImage*)gvc_scaleWidthAndCropHeightToSize:(CGSize)size 
{
    float newHeight = (self.size.height * size.width) / self.size.width;
    return [self gvc_scaleToSize:size withOffset:CGPointMake(0, (newHeight - size.height) / 2)];
}

- (UIImage*)gvc_scaleToSize:(CGSize)size withOffset:(CGPoint)offset 
{
    UIImage* scaledImage = [self gvc_scaleToSize:CGSizeMake(size.width + (offset.x * -2), size.height + (offset.y * -2))];
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGRect croppedRect;
    croppedRect.size = size;
    croppedRect.origin = CGPointZero;
    
    CGContextClipToRect(context, croppedRect);
    
    CGRect drawRect;
    drawRect.origin = offset;
    drawRect.size = scaledImage.size;
    
    CGContextDrawImage(context, drawRect, scaledImage.CGImage);
    
    
    UIImage* croppedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return croppedImage;
}

- (NSString *)gvc_saveAsUUIDInDirectory:(NSString *)dir
{
	NSString *uuid = [[NSString gvc_StringWithUUID] stringByAppendingPathExtension:@"png"];
	NSFileManager *mgr = [NSFileManager defaultManager];
	
	if ( [mgr gvc_directoryExists:dir] == YES)
	{
		if ([self gvc_saveImageToFile:[dir stringByAppendingPathComponent:uuid]] == YES)
			return uuid;
	}
	return nil;
}

/** saves as a PNG */
- (BOOL)gvc_saveImageToFile:(NSString *)path
{
    NSError* error;
    NSData* data = UIImagePNGRepresentation(self);
    if(data != nil)
	{
		if ([data writeToFile:path options:NSAtomicWrite error:&error] == NO)
		{
				//GVCLogInfo(@"Error writing image to %@ [%@]", path, error );
			return NO;
		}
    }
	return YES;
}

@end
