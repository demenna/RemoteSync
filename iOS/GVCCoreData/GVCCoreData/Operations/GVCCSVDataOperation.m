/*
 * GVCCSVDataOperation.m
 * 
 * Created by David Aspinall on 12-05-07. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCCSVDataOperation.h"
#import "GVCFoundation.h"

@implementation GVCCSVDataOperation

@synthesize csvFile;

- (id)initForPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator usingFile:(NSString *)file;
{
	self = [super initForPersistentStoreCoordinator:coordinator];
	if ( self != nil )
	{
        [self setCsvFile:file];
	}
	
    return self;
}

- (void)main
{
	[self initializeCoreData];
    
	[self operationDidStart];
	NSError *anError = nil;
    GVCCSVParser *parser = [[GVCCSVParser alloc] initWithDelegate:self separator:@"," fieldNames:nil firstLineHeaders:YES];
    if ([parser parseFilename:[self csvFile] error:&anError] == YES)
    {
        [self operationDidFailWithError:anError];
    }
    else
    {
        [self operationDidFinish];
    }
}


- (void)parser:(GVCParser *)parser didStartFile:(NSString *)sourceFile
{
    if ( [self isCancelled] == YES )
    {
        [parser setCancelled:YES];
    }
}

- (void)parser:(GVCParser *)parser didParseRow:(NSDictionary *)dictRow
{
    if ( [self isCancelled] == YES )
    {
        [parser setCancelled:YES];
    }
}

- (void)parser:(GVCParser *)parser didEndFile:(NSString *)sourceFile
{
}

- (void)parser:(GVCParser *)parser didFailWithError:(NSError *)anError
{
}

@end
