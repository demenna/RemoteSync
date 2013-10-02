/*
 * GVCURLOperationTest.m
 * 
 * Created by David Aspinall on 12-03-22. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"
#import "GVCResourceTestCase.h"

#pragma mark - Interface declaration
@interface GVCURLOperationTest : GVCResourceTestCase

@property (strong, nonatomic) NSOperationQueue *queue;

@end


#pragma mark - Test Case implementation
@implementation GVCURLOperationTest

@synthesize queue;

	// setup for all the following tests
- (void)setUp
{
    [super setUp];
	[self setQueue:[[NSOperationQueue alloc] init]];
}

	// tear down the test setup
- (void)tearDown
{
    [super tearDown];
}

	// All code under test must be linked into the Unit Test bundle
- (void)testBasicURL
{
	__block BOOL hasCalledBack = NO;

	NSURL *apple = [NSURL URLWithString:@"http://www.apple.com"];
	GVCNetOperation *apple_Op = [[GVCNetOperation alloc] initForURL:apple];
	[apple_Op setProgressBlock:^(NSInteger bytes, NSInteger totalBytes, NSString *msg){
		GVCLogError(@"%d of %d", bytes, totalBytes);
	}];
	[apple_Op setDidFinishBlock:^(GVCOperation *operation) {
        GVCMemoryResponseData *respData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
		NSData *data = [respData responseBody];
		GVCLogError(@"Operation success with data %@", data);
		[data writeToFile:@"/tmp/apple.com.html" atomically:YES];
		hasCalledBack = YES;
	}];
	[apple_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		STAssertTrue(NO, @"Operation failed with error %@", err);
		hasCalledBack = YES;
	}];
	[[self queue] addOperation:apple_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }

}

- (void)testFTPURL
{
	__block BOOL hasCalledBack = NO;
	
	NSURL *ftpurl = [NSURL URLWithString:@"ftp://media.local."];
	GVCNetOperation *ftp_Op = [[GVCNetOperation alloc] initForURL:ftpurl];
	[ftp_Op setProgressBlock:^(NSInteger bytes, NSInteger totalBytes, NSString *msg){
		GVCLogError(@"Received %d of %d", bytes, totalBytes);
	}];
	[ftp_Op setDidFinishBlock:^(GVCOperation *operation) {
        GVCMemoryResponseData *respData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
		NSData *data = [respData responseBody];
		STAssertTrue(data == nil, @"Basic url connection should work, but no data");
		hasCalledBack = YES;
	}];
	[ftp_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		GVCLogError(@"Operation failed with error %@", err);
		STAssertTrue(NO, @"Operation failed with %@", err);
		hasCalledBack = YES;
	}];
	[[self queue] addOperation:ftp_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }
	
}

- (void)testSelfSignedCertFail
{
	__block BOOL hasCalledBack = NO;
	
	NSURL *url = [NSURL URLWithString:@"https://media.local."];
	GVCNetOperation *url_Op = [[GVCNetOperation alloc] initForURL:url];
	[url_Op setDidFinishBlock:^(GVCOperation *operation) {
		STAssertTrue(NO, @"Operation should have failed with error");
		hasCalledBack = YES;
	}];
	[url_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		GVCLogError(@"GVCOperation failed with error %@", err);
		hasCalledBack = YES;
	}];
	
	[[self queue] addOperation:url_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }
}

- (void)testSelfSignedCertSuccess
{
	__block BOOL hasCalledBack = NO;
	
	NSURL *url = [NSURL URLWithString:@"https://media.local."];
	GVCNetOperation *url_Op = [[GVCNetOperation alloc] initForURL:url];
	[url_Op setAllowSelfSignedCerts:YES];
	
	[url_Op setDidFinishBlock:^(GVCOperation *operation) {
		GVCLogError(@"GVCOperation success");
        GVCMemoryResponseData *respData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
		NSData *data = [respData responseBody];
		[data writeToFile:@"/tmp/media-local.html" atomically:YES];
		STAssertTrue(data != nil, @"Self signed server should have returned a page");
		STAssertTrue([data length] > 10, @"Self signed server should have content");
		hasCalledBack = YES;
	}];
	[url_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		STAssertTrue(NO, @"Operation should have succeeded. %@", err);
		hasCalledBack = YES;
	}];
	
	[[self queue] addOperation:url_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }
	
}


@end
