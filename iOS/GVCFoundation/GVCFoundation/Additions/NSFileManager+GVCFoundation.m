/*
 * NSFileManager+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-12-06. 
 * Copyright (c) 2011 Global Village Consulting. All rights reserved.
 *
 */

#import "NSFileManager+GVCFoundation.h"
#import "NSData+GVCFoundation.h"
#import "GVCFunctions.h"

@implementation NSFileManager (GVCFoundation)

- (BOOL)gvc_directoryExists:(NSString *)path
{
	BOOL isDir;
	return ([self fileExistsAtPath:path isDirectory:&isDir] == YES) && (isDir == YES);
}

- (NSString *)gvc_documentsDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_cachesDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	if ( [paths count] == 0 )
		return [self gvc_temporaryDirectoryPath];
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_downloadsDirectoryPath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
	if ( [paths count] == 0 )
		return [self gvc_temporaryDirectoryPath];
	return [paths objectAtIndex:0];
}

- (NSString *)gvc_temporaryDirectoryPath
{
	return NSTemporaryDirectory();
}

- (NSURL *)gvc_documentsDirectoryURL
{
    NSArray *urls = [self URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [urls lastObject];
}

- (NSURL *)gvc_cachesDirectoryURL
{
    NSArray *urls = [self URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
	if ( [urls count] == 0 )
		return [self gvc_temporaryDirectoryURL];
    return [urls lastObject];
}

- (NSURL *)gvc_temporaryDirectoryURL
{
    return [NSURL URLWithString:[self gvc_temporaryDirectoryPath]];
}

- (NSURL *)gvc_downloadsDirectoryURL
{
    NSArray *urls = [self URLsForDirectory:NSDownloadsDirectory inDomains:NSUserDomainMask];
	if ( [urls count] == 0 )
		return [self gvc_temporaryDirectoryURL];
    return [urls lastObject];
}


- (NSString *)gvc_md5Hash:(NSString *)path
{
	NSString *hash = nil;
	NSData *data = [NSData dataWithContentsOfFile:path];
	if (data != nil)
	{	
		hash = [[data gvc_md5Digest] gvc_hexString];
	}
	return hash;
}

- (BOOL)gvc_validateFile:(NSString *)path withMD5Hash:(NSString *)hash 
{
	return [hash isEqualToString:[self gvc_md5Hash:path]];
}

- (NSArray *)gvc_filePathsWithExtension:(NSString *)extension inDirectory:(NSString *)directoryPath 
{
	NSArray *extensions = nil;
	
	if (gvc_IsEmpty(extension) == NO )
		extensions = [NSArray arrayWithObject:extension];
	
	return [self gvc_filePathsWithExtensions:extensions inDirectory:directoryPath];
}

- (NSArray *)gvc_filePathsWithExtensions:(NSArray *)extensions inDirectory:(NSString *)directoryPath 
{
	if ( gvc_IsEmpty(directoryPath) == YES )
		return nil;
	
	// |basenames| will contain only the matching file names, not their full paths.
	NSArray *basenames = [self contentsOfDirectoryAtPath:directoryPath  error:nil];
	
	// Check if dir doesn't exist or couldn't be opened.
	if (basenames == nil)
		return nil;
	
	// Check if dir is empty.
	if ([basenames count] == 0)
		return basenames;
	
	NSMutableArray *paths = [NSMutableArray arrayWithCapacity:[basenames count]];
	NSString *basename;
    
	// Convert all the |basenames| to full paths.
	for (basename in basenames)
	{
		NSString *fullPath = [directoryPath stringByAppendingPathComponent:basename];
		[paths addObject:fullPath];
	}
	
	// Check if caller wants all files, regardless of extension.
	if ((extensions == nil) || ([extensions count] == 0))
		return paths;
	
	return [paths pathsMatchingExtensions:extensions];
}

@end
