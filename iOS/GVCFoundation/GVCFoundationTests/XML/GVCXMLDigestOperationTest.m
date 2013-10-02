/*
 * GVCXMLDigestOperationTest.m
 * 
 * Created by David Aspinall on 12-03-27. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import <SenTestingKit/SenTestingKit.h>
#import "GVCFoundation.h"
#import "GVCResourceTestCase.h"

#pragma mark - Interface declaration
@interface GVCXMLDigestOperationTest : GVCResourceTestCase
@property (strong, nonatomic) NSOperationQueue *queue;
@end

const NSString *ITUNES_URL = @"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=300/rss.xml";

#pragma mark - Test Case implementation
@implementation GVCXMLDigestOperationTest

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
- (void)testParse
{
	__block BOOL hasCalledBack = NO;
	GVCRSSDigester *parser = [[GVCRSSDigester alloc] init];
	[parser setFilename:[self pathForResource:@"DaringFireball" extension:@"xml"]];
    
    GVCXMLParserOperation *xml_op = [[GVCXMLParserOperation alloc] initForParser:parser];
    
    [xml_op setDidFinishBlock:^(GVCOperation *operation) {
        GVCXMLParserOperation *xmlParseOp = (GVCXMLParserOperation *)operation;
        GVCRSSDigester *parseDelegate = (GVCRSSDigester *)[xmlParseOp xmlParser];
        
		STAssertNotNil(parseDelegate, @"Operation success with parseDelegate %@", parseDelegate);
		STAssertTrue( [parseDelegate status] == GVC_XML_ParserDelegateStatus_SUCCESS , @"Operation should be success %d", [parseDelegate status]);

        NSArray *digest = [parseDelegate digestKeys];
		STAssertNotNil(digest, @"Parse digest %@", digest);

        GVCRSSFeed *feed = (GVCRSSFeed *)[parseDelegate digestValueForPath:@"feed"];
		STAssertNotNil(feed, @"Parse feed %@", feed);
        STAssertTrue([[feed feedEntries] count] == 47, @"Feed entries count %d", [[feed feedEntries] count]);
        
		hasCalledBack = YES;
	}];
	[xml_op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		STAssertTrue(NO, @"Operation failed with error %@", err);
		hasCalledBack = YES;
	}];
	[[self queue] addOperation:xml_op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }

}

// All code under test must be linked into the Unit Test bundle
- (void)testDownloadAndParse
{
	__block BOOL hasCalledBack = NO;

    GVCNetOperation *url_Op = [[GVCNetOperation alloc] initForURL:[NSURL URLWithString:@"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=300/rss.xml"]];
    
	[url_Op setDidFinishBlock:^(GVCOperation *operation) {
        GVCXMLParserOperation *xml_op = [[GVCXMLParserOperation alloc] initForParser:[[GVCRSSDigester alloc] init]];
        GVCMemoryResponseData *respData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
        NSData *data = [respData responseBody];
		[[xml_op xmlParser] setXmlData:data];

        [xml_op setDidFinishBlock:^(GVCOperation *operation) {
            GVCXMLParserOperation *xmlParseOp = (GVCXMLParserOperation *)operation;
            GVCRSSDigester *parseDelegate = (GVCRSSDigester *)[xmlParseOp xmlParser];
            
            STAssertNotNil(parseDelegate, @"Operation success with parseDelegate %@", parseDelegate);
            STAssertTrue( [parseDelegate status] == GVC_XML_ParserDelegateStatus_SUCCESS , @"Operation should be success %d", [parseDelegate status]);
            
            NSArray *digest = [parseDelegate digestKeys];
            STAssertNotNil(digest, @"Parse digest %@", digest);
            
            GVCRSSFeed *feed = (GVCRSSFeed *)[parseDelegate digestValueForPath:@"rss"];
            STAssertNotNil(feed, @"Parse feed nil %@", digest);
            STAssertTrue([[feed feedEntries] count] == 300, @"Feed entries count %d", [[feed feedEntries] count]);
            
            hasCalledBack = YES;
        }];
        [xml_op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
            STAssertTrue(NO, @"Operation failed with error %@", err);
            hasCalledBack = YES;
        }];

        [[self queue] addOperation:xml_op];
	}];
	[url_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		GVCLogError(@"GVCOperation (%@) failed with error %@", operation, err);
		hasCalledBack = YES;
	}];

	[[self queue] addOperation:url_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        GVCLogError(@"letting runloop %d", count);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }
    STAssertTrue(hasCalledBack, @"Operation not finished");
    
    if ( hasCalledBack == NO ) 
    {
        [queue cancelAllOperations];
        
        count = 0;
        while (hasCalledBack == NO && count < 2)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
            count++;
        }
    }
}

// All code under test must be linked into the Unit Test bundle
- (void)testDownloadAndParseDependency
{
	__block BOOL hasCalledBack = NO;
    
    GVCStopwatch *stopwatch = [[GVCStopwatch alloc] init];
    GVCNetOperation *url_Op = [[GVCNetOperation alloc] initForURL:[NSURL URLWithString:@"http://ax.phobos.apple.com.edgesuite.net/WebObjects/MZStore.woa/wpa/MRSS/newreleases/limit=300/rss.xml"]];
    GVCXMLParserOperation *xml_op = [[GVCXMLParserOperation alloc] initForParser:[[GVCRSSDigester alloc] init]];

    [url_Op setProgressBlock:^(NSInteger bytes, NSInteger totalBytes, NSString *msg){
		GVCLogError(@"%f: URL Received %d of %d", [stopwatch elapsed], bytes, totalBytes);
	}];
	[url_Op setDidFinishBlock:^(GVCOperation *operation) {
		GVCLogError(@"%f: GVCOperation (%@) finished", [stopwatch elapsed], operation);
        GVCMemoryResponseData *respData = (GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData];
		NSData *data = [respData responseBody];
		[[xml_op xmlParser] setXmlData:data];
	}];
	[url_Op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		GVCLogError(@"%f: GVCOperation (%@) failed with error %@", [stopwatch elapsed], operation, err);
		hasCalledBack = YES;
	}];
    [xml_op setDidStartBlock:^(GVCOperation *operation) {
        GVCLogError(@"%f: GVCOperation (%@) did start *****************", [stopwatch elapsed], operation);
    }];
    [xml_op setDidFinishBlock:^(GVCOperation *operation) {
        GVCLogError(@"%f: GVCOperation (%@) did finish", [stopwatch elapsed], operation);
        GVCXMLParserOperation *xmlParseOp = (GVCXMLParserOperation *)operation;
        GVCRSSDigester *parseDelegate = (GVCRSSDigester *)[xmlParseOp xmlParser];
        
        STAssertNotNil(parseDelegate, @"Operation success with parseDelegate %@", parseDelegate);
        STAssertTrue( [parseDelegate status] == GVC_XML_ParserDelegateStatus_SUCCESS , @"Operation should be success %d", [parseDelegate status]);
        
        NSArray *digest = [parseDelegate digestKeys];
        STAssertNotNil(digest, @"Parse digest %@", digest);
        
        GVCRSSFeed *feed = (GVCRSSFeed *)[parseDelegate digestValueForPath:@"rss"];
        
        GVCFileWriter *writer = [GVCFileWriter writerForFilename:@"/tmp/apple300.rss"];
        GVCXMLGenerator *outgen = [[GVCXMLGenerator alloc] initWithWriter:writer andFormat:GVC_XML_GeneratorFormat_PRETTY];
        [feed writeRss:outgen];
        
        STAssertNotNil(feed, @"Parse feed nil %@", digest);
        STAssertTrue([[feed feedEntries] count] == 300, @"Feed entries count %d", [[feed feedEntries] count]);
        
        hasCalledBack = YES;
    }];
    [xml_op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
        GVCLogError(@"%f: GVCOperation (%@) did fail with %@", [stopwatch elapsed], operation, err);
        STAssertTrue(NO, @"Operation failed with error %@", err);
        hasCalledBack = YES;
    }];

    [stopwatch start];
    [xml_op addDependency:url_Op];
    [[self queue] addOperation:xml_op];
	[[self queue] addOperation:url_Op];
	
	int count = 0;
    while (hasCalledBack == NO && count < 10)
	{
        GVCLogError(@"letting runloop %d", count);
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
        count++;
    }
    STAssertTrue(hasCalledBack, @"Operation not finished");
    
    if ( hasCalledBack == NO ) 
    {
        [queue cancelAllOperations];
        
        count = 0;
        while (hasCalledBack == NO && count < 2)
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
            count++;
        }
    }
    [stopwatch stop];
}

@end
