/*
 * GVCConfiguration.m
 * 
 * Created by David Aspinall on 12-05-12. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCConfiguration.h"
#import <dispatch/dispatch.h>

#import "GVCFunctions.h"
#import "GVCDirectory.h"
#import "GVCFileOperation.h"

#import "NSBundle+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "NSFileManager+GVCFoundation.h"

#import "GVCConfigDocument.h"
#import "GVCConfigResource.h"
#import "GVCConfigPackage.h"
#import "GVCConfigProperty.h"

GVC_DEFINE_STRVALUE(GVCConfiguration_RESOURCES_FILE, resources.plist)

@interface GVCConfiguration ()

@property (strong, nonatomic) NSString *baseURL;

@property (strong, nonatomic) NSMutableDictionary *md5Hashes;
@property (strong, nonatomic) NSMutableDictionary *resourceDictionary;
@property (strong, nonatomic) NSMutableDictionary *resourceGroupDictionary;

- (void)checkLocalConfiguration;
- (void)checkRemoteConfiguration;
//- (void)storeCachedConfiguration;

- (void)processRemoteResource:(NSString *)itemKey md5:(NSString *)md5 forGroup:(NSString *)group;

@end

NSString * const GVCConfiguration_sourceURL = @"https://apps.global-village.net/mobile_configuration";

@implementation GVCConfiguration

GVC_SINGLETON_CLASS(GVCConfiguration)

@synthesize baseURL;
@synthesize md5Hashes;
@synthesize resourceDictionary;
@synthesize resourceGroupDictionary;

@synthesize operationQueue;

- (id)init
{
	self = [super init];
	if ( self != nil )
	{
        [self setMd5Hashes:[[NSMutableDictionary alloc] initWithCapacity:10]];
        [self setResourceDictionary:[[NSMutableDictionary alloc] initWithCapacity:10]];
        [self setResourceGroupDictionary:[[NSMutableDictionary alloc] initWithCapacity:10]];
        
        // should be something like
        // https://apps.global-village.net/mobile_configuration/<bundleIdentifier>/<appVersion>/
        [self setBaseURL:GVC_SPRINTF(@"%@/%@/%@", GVCConfiguration_sourceURL, [NSBundle gvc_MainBundleIdentifier], [NSBundle gvc_MainBundleMarketingVersion])];
        GVCLogError(@"Configuration url = %@", [self baseURL]);
	}
	
    return self;
}

- (void)reloadConfiguration
{
    // when the local configuration loads, there may be a new remote configuration URL
    [self checkLocalConfiguration];
    [self checkRemoteConfiguration]; 
}

- (NSString *)configurationResourcePathForKey:(NSString *)key
{
    return [resourceDictionary valueForKey:key];
}

- (NSArray *)configurationResourceKeysForGroup:(NSString *)key
{
    NSSet *set = [resourceGroupDictionary valueForKey:key];
    return (gvc_IsEmpty(set) ? nil : [set allObjects]);
}

- (void)updateIndexes:(NSString *)item forGroup:(NSString *)group
{
    dispatch_sync( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        GVCDirectory *docs = [GVCDirectory DocumentDirectory];

        // full path index
        [[self resourceDictionary] setObject:[docs fullpathForFile:item] forKey:item];
        
        // item index list by group
        NSMutableArray *list = [[self resourceGroupDictionary] objectForKey:group];
        if ( list == nil )
        {
            list = [[NSMutableArray alloc] initWithCapacity:10];
            [[self resourceGroupDictionary] setObject:list forKey:group];
        }
        if ( [list containsObject:item] == NO )
            [list addObject:item];
        
        // finally the md5 checksum
        [[self md5Hashes] setObject:[docs md5Hash:item] forKey:item];

        // update the cached database
        NSMutableDictionary *store = [[NSMutableDictionary alloc] initWithCapacity:3];
        [store setObject:[self resourceGroupDictionary] forKey:@"groups"];
        [store setObject:[self resourceDictionary] forKey:@"resources"];
        [store setObject:[self md5Hashes] forKey:@"md5"];
        
        NSString *dest = [[GVCDirectory DocumentDirectory] fullpathForFile:GVCConfiguration_RESOURCES_FILE];
        NSError *plistError = nil;
        NSData *archive = [NSPropertyListSerialization dataWithPropertyList:store format:NSPropertyListBinaryFormat_v1_0 options:0 error:&plistError];
        [archive writeToFile:dest atomically:YES];
	});
}

- (void)checkLocalConfiguration
{
    GVCDirectory *docs = [GVCDirectory DocumentDirectory];
    NSError *plistError = nil;
    GVCLogError(@"Docs %@", docs );

    if ( [docs fileExists:GVCConfiguration_RESOURCES_FILE] == YES )
    {
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:[docs fullpathForFile:GVCConfiguration_RESOURCES_FILE]] options:NSPropertyListMutableContainers format:nil error:&plistError];
        [self setResourceDictionary:[(NSDictionary *)[plist objectForKey:@"resources"] mutableCopy]];
        [self setResourceGroupDictionary:[(NSDictionary *)[plist objectForKey:@"groups"] mutableCopy]];
        [self setMd5Hashes:[(NSDictionary *)[plist objectForKey:@"md5"] mutableCopy]];
    }
    else
    {
        NSString *localConfigPath = [[NSBundle mainBundle] pathForResource:GVCConfiguration_RESOURCES_FILE ofType:nil];
        if ( gvc_IsEmpty(localConfigPath) == NO )
        {
            NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:localConfigPath] options:NSPropertyListImmutable format:nil error:&plistError];
            
            NSArray *groups = [plist allKeys];
            for ( NSString *group in groups)
            {
                NSArray *templateList = (NSArray *)[plist objectForKey:group];
                for (NSString *item in templateList )
                {
                    NSString *filename = [[item lastPathComponent] stringByDeletingPathExtension];
                    NSString *ext = [[item lastPathComponent] pathExtension];
                    NSString *subdir = [item stringByDeletingLastPathComponent];
                    
                    // if the resource already exists in the doc directory, then skip it
                    if ( [docs fileExists:item] == NO )
                    {
                        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:filename ofType:ext inDirectory:subdir];
                        if ( gvc_IsEmpty(bundlePath) == NO )
                        {
                            [docs createSubdirectory:subdir];
                            if ([docs copyFileFrom:bundlePath to:item] == YES)
                            {
                                // add it to the indexes
                                [self updateIndexes:item forGroup:group];
                            }
                        }
                    }
                    else
                    {
                        // add it to the indexes
                        [self updateIndexes:item forGroup:group];
                    }
                }
            }
        }
        else 
        {
            GVCLogInfo(@"No local configuration file named %@", GVCConfiguration_RESOURCES_FILE );
        }
    }
}

- (void)checkRemoteConfiguration
{
    NSString *temp = [[GVCDirectory TempDirectory] fullpathForFile:[NSString gvc_StringWithUUID]];

    NSString *remoteURL = remoteURL = GVC_SPRINTF(@"%@/%@", [self baseURL], GVCConfiguration_RESOURCES_FILE);
    NSURL *url = [NSURL URLWithString:remoteURL];
    GVCNetOperation *rscDownload = [[GVCNetOperation alloc] initForURL:url];
    [rscDownload setAllowSelfSignedCerts:YES];
    [rscDownload setResponseData:[[GVCStreamResponseData alloc] initForFilename:temp]];
    [rscDownload setDidFinishBlock:^(GVCOperation *operation) {

        NSError *plistError = nil;
        NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:[NSData dataWithContentsOfFile:temp] options:NSPropertyListImmutable format:nil error:&plistError];
        if ( plist != nil )
        {
            NSArray *groups = [plist allKeys];
            for ( NSString *group in groups)
            {
                NSArray *templateList = (NSArray *)[plist objectForKey:group];
                for (NSDictionary *item in templateList )
                {
                    NSString *itemKey = [[item allKeys] lastObject];
                    NSString *md5 = [item objectForKey:itemKey];
                    
                    [self processRemoteResource:itemKey md5:md5 forGroup:group];
                }
            }
        }
    }];
    
    [rscDownload setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
        GVCLogError(@"Operation Failed %@", err);
    }];
    [[self operationQueue] addOperation:rscDownload];
}

- (void)processRemoteResource:(NSString *)itemKey md5:(NSString *)md5 forGroup:(NSString *)group;
{
    BOOL needsUpdate = YES;
    if ( [[self md5Hashes] objectForKey:itemKey] != nil )
    {
        NSString *currentMD5 = [[self md5Hashes] objectForKey:itemKey];
        if ( [currentMD5 isEqualToString:md5] == YES )
        {
            needsUpdate = NO;
        }
    }
    
    if (needsUpdate == YES)
    {
        NSString *temp = [[GVCDirectory TempDirectory] fullpathForFile:[NSString gvc_StringWithUUID]];
        
        NSString *remoteURL = remoteURL = GVC_SPRINTF(@"%@/%@", [self baseURL], itemKey);
        NSURL *url = [NSURL URLWithString:remoteURL];
        GVCNetOperation *rscDownload = [[GVCNetOperation alloc] initForURL:url];
        [rscDownload setAllowSelfSignedCerts:YES];
        [rscDownload setResponseData:[[GVCStreamResponseData alloc] initForFilename:temp]];
        [rscDownload setDidFinishBlock:^(GVCOperation *operation) {
            NSString *subdir = [itemKey stringByDeletingLastPathComponent];
            GVCDirectory *docs = [GVCDirectory DocumentDirectory];
            NSString *backupName = nil;
            BOOL success = YES;
            
            [docs createSubdirectory:subdir];
            if ( [docs fileExists:itemKey] == YES) 
            {
                backupName = GVC_SPRINTF(@"%@~", itemKey);
                success = [docs moveFileFrom:itemKey to:backupName];
            }
            
            if (success == YES)
            {
                success = [docs moveFileFrom:temp to:itemKey];
                if (success == YES)
                {
                    [self updateIndexes:itemKey forGroup:group];
                    if ( gvc_IsEmpty(backupName) == NO )
                    {
                        [docs removeFileIfExists:backupName];
                    }
                }
                else if ( gvc_IsEmpty(backupName) == NO )
                {
                    // restore old file
                    success = [docs moveFileFrom:backupName to:itemKey];
                }
            }
        }];
        
        [rscDownload setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
            GVCLogError(@"Operation Failed %@", err);
        }];
        [[self operationQueue] addOperation:rscDownload];

    }
}

@end
