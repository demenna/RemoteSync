//
//  GVCDetailViewController.m
//  MobileNotes
//
//  Created by David Aspinall on 12-06-21.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import "GVCDetailViewController.h"
#import "GVCCoreData.h"
#import "ERSync.h"
#import "GVCFoundation.h"

#import "Note.h"
#import "Category.h"
#import "GVCAppDelegate.h"

@interface GVCDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

@implementation GVCDetailViewController

@synthesize noteEditor = _noteEditor;
@synthesize syncStatus = _syncStatus;
@synthesize masterPopoverController = _masterPopoverController;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (([[self noteEditor] note] != newDetailItem) && ([[[self noteEditor] note] isUpdated] == YES))
	{
		[[self noteEditor] saveAction:nil];
    }

	[[self noteEditor] setNote:newDetailItem];
	[[self noteEditor] reload:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	SyncEngine *engine = [[self applicationDelegate] engine];
	NSString *msg = GVC_SPRINTF(@"Application started, sync engine is %@", ([engine active] ? @"active" : @"disabled"));
	[[self syncStatus] startSync:msg];
	
	SyncPrincipal *principal = [[self applicationDelegate] principal];
	if ( principal == nil )
		[[self syncStatus] addStatus:0 forTotal:0 statusMessage:@"Missing principal record"];
	else
	{
		[[self syncStatus] addStatus:0 forTotal:0 statusMessage:GVC_SPRINTF(@"%@ for site %@ last Sync on %@", [principal username], [principal site], [principal lastSync])];
	}
	[[self syncStatus] endSync:nil];
}

- (void)viewDidUnload
{
    [self setNoteEditor:nil];
	[self setSyncStatus:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - Sync actions

- (GVCAppDelegate *)applicationDelegate
{
	return (GVCAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (IBAction)resetLocal:(id)sender
{
	[[[self applicationDelegate] engine] setActive:NO];
	[[self applicationDelegate] setPrincipal:nil];
	[[self noteEditor] setNote:nil];

	SyncResetLocalDatabaseOperation *op = [[SyncResetLocalDatabaseOperation alloc] initForPersistentStoreCoordinator:[[self applicationDelegate] persistentStoreCoordinator]];
	[op setModel:[[self applicationDelegate] managedObjectModel]];
	[op setContextDidSaveBlock:^(GVCOperation *operation, NSNotification *notification) {
		[[self applicationDelegate] mergeChanges:notification];
	}];
	[op setDidStartBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Resetting all data"];
	}];
	[op setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
		GVCLogError(@"%d/%d %@", item, total, msg);
		[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
		[[self syncStatus] reload:nil];
	}];
	 
	[op setDidFinishBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		[[self applicationDelegate] syncEngineDidReset];
		[[self applicationDelegate] saveContext];
		[[[self applicationDelegate] engine] setActive:YES];

	}];
	[op setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:[[operation operationError] localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		
			// reload?
	}];

	[[[self applicationDelegate] operationQueue] addOperation:op];
}

- (IBAction)registerAction:(id)sender 
{
	SyncPrincipal *p = [[self applicationDelegate] principal];
	
		// send registration info
	GVCStringWriter *writer = [GVCStringWriter stringWriter];
	GVCXMLGenerator *output = [[GVCXMLGenerator alloc] initWithWriter:writer];
	[output openElement:@"registration"];
	[output writeElement:@"appid" withText:SYNC_APP_ID];
	[output writeElement:@"deviceType" withText:SYNC_DEVICE_IPAD];
	[output writeElement:@"deviceUUID" withText:[p uuid]];
	[output writeElement:@"user" withText:[p username]];
	[output writeElement:@"password" withText:[p password]];
	[output closeElement]; // registration
	[output closeDocument];
	
	NSData *data = [[writer string] dataUsingEncoding:[writer stringEncoding]];
	[data writeToFile:@"/tmp/registration-rq.xml" atomically:YES];
	NSURL *url = [SyncOperation registerURL:[p site]];
	NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
	[req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
	[req setValue:GVC_SPRINTF(@"%d", [data length]) forHTTPHeaderField:@"Content-Length"];
	
	[req setHTTPMethod:@"POST"];
	[req setHTTPBody:data];
	
	SyncOperation *netOp = [[SyncOperation alloc] initForRequest:req];
	[netOp setType:SyncOperationType_REGISTER];

	SyncParseAndLoadOperation *parseAndLoad = [[SyncParseAndLoadOperation alloc] initForPersistentStoreCoordinator:[[self applicationDelegate] persistentStoreCoordinator]];
	[parseAndLoad setNetOperation:netOp];
	[parseAndLoad addDependency:netOp];

	[netOp setDidStartBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Sending registration"];
		[[self syncStatus] startSync:@"Registration message"];
	}];
	[netOp setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
		GVCLogError(@"%d/%d %@", item, total, msg);
		[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
	}];
	
	[netOp setDidFinishBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		NSData *data = [(GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData] responseBody];
		[data writeToFile:@"/tmp/registration.xml" atomically:YES];
	}];
	[netOp setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
		[[self syncStatus] reload:nil];
	}];

	[parseAndLoad setContextDidSaveBlock:^(GVCOperation *operation, NSNotification *notification) {
		[[self applicationDelegate] mergeChanges:notification];
	}];
	[parseAndLoad setDidStartBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Parsing ..."];
	}];
	[parseAndLoad setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
		[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
	}];
	[parseAndLoad setDidFinishBlock:^(GVCOperation *operation) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		[[self syncStatus] endSync:@"Registration completed"];
		[[self syncStatus] reload:nil];
	}];
	[parseAndLoad setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
		[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
		[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
		[[self syncStatus] reload:nil];
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration failed"  message:[err localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];

	}];

	[[[self applicationDelegate] operationQueue] addOperation:netOp];
	[[[self applicationDelegate] operationQueue] addOperation:parseAndLoad];
}

- (IBAction)fullSyncAction:(id)sender
{
	SyncPrincipal *p = [[self applicationDelegate] principal];
	
	if (gvc_IsEmpty([p principalId]) == YES)
	{
			// run a register test
			// show error alert
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No device registration.  Run the Registration service first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	else
	{
		GVCStringWriter *writer = [GVCStringWriter stringWriter];
		GVCXMLGenerator *output = [[GVCXMLGenerator alloc] initWithWriter:writer];
		[output openElement:@"sync"];
		[output writeElement:@"principalUUID" withText:[p principalId]];
		if ( [p lastSync] != nil )
		{
			[output writeElement:@"lastSync" withText:[p formattedLastSync]];
			[output openElement:@"data"];	
			[output closeElement]; // data
		}
		[output closeElement]; // registration
		[output closeDocument];
		
		NSData *data = [[writer string] dataUsingEncoding:[writer stringEncoding]];
		[data writeToFile:@"/tmp/fullsync-rq.xml" atomically:YES];
		NSURL *url = [SyncOperation initialURL:[p site]];
		if ( [p lastSync] != nil )
		{
			url = [SyncOperation fullSlowURL:[p site]];
		}
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
		[req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
		[req setValue:GVC_SPRINTF(@"%d", [data length]) forHTTPHeaderField:@"Content-Length"];
		
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody:data];
		
		SyncOperation *netOp = [[SyncOperation alloc] initForRequest:req];
		
		if ( [p lastSync] != nil )
		{
			[netOp setType:SyncOperationType_FULL];
			[[self syncStatus] startSync:@"Full Sync"];
		}
		else
		{
			[netOp setType:SyncOperationType_INITIAL];
			[[self syncStatus] startSync:@"Initial Sync"];
		}
		
		SyncParseAndLoadOperation *parseAndLoad = [[SyncParseAndLoadOperation alloc] initForPersistentStoreCoordinator:[[self applicationDelegate] persistentStoreCoordinator]];
		[parseAndLoad setNetOperation:netOp];
		[parseAndLoad addDependency:netOp];
		
		[netOp setDidStartBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Sending full sync"];
		}];
		[netOp setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
			GVCLogError(@"%d/%d %@", item, total, msg);
			[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
		}];
		
		[netOp setDidFinishBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			NSData *data = [(GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData] responseBody];
			[data writeToFile:@"/tmp/fullsync.xml" atomically:YES];
		}];
		[netOp setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
			[[self syncStatus] reload:nil];
		}];
		
		[parseAndLoad setContextDidSaveBlock:^(GVCOperation *operation, NSNotification *notification) {
			[[self applicationDelegate] mergeChanges:notification];
		}];
		[parseAndLoad setDidStartBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Parsing ..."];
		}];
		[parseAndLoad setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
			[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
		}];
		[parseAndLoad setDidFinishBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:@"Registration completed"];
			[[self syncStatus] reload:nil];
		}];
		[parseAndLoad setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
			[[self syncStatus] reload:nil];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration failed"  message:[err localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			
		}];
		
		[[[self applicationDelegate] operationQueue] addOperation:netOp];
		[[[self applicationDelegate] operationQueue] addOperation:parseAndLoad];
	}
}

- (IBAction)deltaSyncAction:(id)sender 
{
	SyncPrincipal *p = [[self applicationDelegate] principal];
	
	if (gvc_IsEmpty([p principalId]) == YES)
	{
			// run a register test
			// show error alert
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No device registration.  Run the Registration service first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	else if ([p lastSync] == nil )
	{
			// delta requires previous sync
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"  message:@"No previous sync recorded.  Run a FULL sync first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
	}
	else
	{
		GVCStringWriter *writer = [GVCStringWriter stringWriter];
		GVCXMLGenerator *output = [[GVCXMLGenerator alloc] initWithWriter:writer];
		[output openElement:@"sync"];
		[output writeElement:@"principalUUID" withText:[p principalId]];
		[output writeElement:@"lastSync" withText:[p formattedLastSync]];
		[output openElement:@"data"];	
		
			// check for deleted
		NSEntityDescription *syncEnt = [NSEntityDescription entityForName:SyncEntity_ENTITY_NAME inManagedObjectContext:[p managedObjectContext]];
		NSMutableArray *and = [NSMutableArray arrayWithCapacity:2];
		[and addObject:[syncEnt gvc_predicateForProperty:@"status" andValue:@"delete"]];
		[and addObject:[NSPredicate predicateWithFormat:@"(updatedDate >= %@)", [p lastSync]]];
		NSSet *allDel = [[p managedObjectContext] gvc_fetchObjectsForEntityName:SyncEntity_ENTITY_NAME withPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:and]];
		for ( SyncEntity *delObj in allDel )
		{
			NSDictionary *atts = [NSDictionary dictionaryWithObjectsAndKeys:[delObj uuid], @"id", [delObj status], @"status", nil];
			[output writeElement:[delObj name] inNamespace:nil withAttributes:atts];
		}
		
//		NSEntityDescription *changesetEntity = [NSEntityDescription entityForName:SyncChangeset_ENTITY_NAME inManagedObjectContext:[p managedObjectContext]];
		NSPredicate *datePred = [NSPredicate predicateWithFormat:@"(updatedDate >= %@)", [p lastSync]];
		NSSet *allChangeset = [[p managedObjectContext] gvc_fetchObjectsForEntityName:SyncChangeset_ENTITY_NAME withPredicate:datePred];
		
		NSMutableDictionary *grouped = [NSMutableDictionary dictionaryWithCapacity:10];
		for (SyncChangeset *changeset in allChangeset) 
		{
			NSSet *changes = [changeset changes];
			for ( SyncChangeValue *cv in changes )
			{
				SyncEntity *se = [cv syncEntity];
				NSMutableArray *subgroup = [grouped objectForKey:[se uuid]];
				if ( subgroup == nil )
				{
					subgroup = [NSMutableArray arrayWithCapacity:1];
					[grouped setObject:subgroup forKey:[se uuid]];
				}
				[subgroup addObject:cv];
			}
		}
		
		for (NSString *uid in [grouped allKeys])
		{
			NSArray *subgroup = [grouped objectForKey:uid];
			SyncEntity *se = [(SyncChangeValue *)[subgroup lastObject] syncEntity];
			NSDictionary *atts = [NSDictionary dictionaryWithObjectsAndKeys:[se uuid], @"id", [se status], @"status", nil];
			
			[output openElement:[se name] inNamespace:nil withAttributes:atts];
			for (SyncChangeValue *cv in subgroup)
			{
				if ( [[cv valueType] isEqualToString:@"O"] == YES )
				{
					SyncEntity *dest = [cv toOne];
					[output openElement:[cv name]];
					NSDictionary *destatts = [NSDictionary dictionaryWithObjectsAndKeys:[dest uuid], @"id", [dest status], @"status", nil];
					[output writeElement:[dest name] inNamespace:nil withAttributes:destatts];
					[output closeElement]; // change value
				}
				else if ( [[cv valueType] isEqualToString:@"M"] == YES )
				{
					[output openElement:[cv name]];
					for (SyncEntity *dest in [cv toMany])
					{
						NSDictionary *destatts = [NSDictionary dictionaryWithObjectsAndKeys:[dest uuid], @"id", [dest status], @"status", nil];
						[output writeElement:[dest name] inNamespace:nil withAttributes:destatts];
					}
					[output closeElement]; // change value
				}
				else
				{
					[output writeElement:[cv name] withText:[cv value]];
				}
			}
			[output closeElement]; //sync entity
		}
		[output closeElement]; // data
		[output closeElement]; // registration
		[output closeDocument];
		
		NSData *data = [[writer string] dataUsingEncoding:[writer stringEncoding]];
		[data writeToFile:@"/tmp/delta-rq.xml" atomically:YES];
		NSURL *url = [SyncOperation fullFastURL:[p site]];
		NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0];
		[req setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
		[req setValue:GVC_SPRINTF(@"%d", [data length]) forHTTPHeaderField:@"Content-Length"];
		
		[req setHTTPMethod:@"POST"];
		[req setHTTPBody:data];
		
		SyncOperation *netOp = [[SyncOperation alloc] initForRequest:req];
		[netOp setType:SyncOperationType_DELTA];
		
		SyncParseAndLoadOperation *parseAndLoad = [[SyncParseAndLoadOperation alloc] initForPersistentStoreCoordinator:[[self applicationDelegate] persistentStoreCoordinator]];
		[parseAndLoad setNetOperation:netOp];
		[parseAndLoad addDependency:netOp];
		
		[netOp setDidStartBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Sending Delta Sync"];
			[[self syncStatus] startSync:@"Delta Sync"];
		}];
		[netOp setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
			GVCLogError(@"%d/%d %@", item, total, msg);
			[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
		}];
		
		[netOp setDidFinishBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			NSData *data = [(GVCMemoryResponseData *)[(GVCNetOperation *)operation responseData] responseBody];
			[data writeToFile:@"/tmp/delta-rs.xml" atomically:YES];
		}];
		[netOp setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
			[[self syncStatus] reload:nil];
		}];
		
		[parseAndLoad setContextDidSaveBlock:^(GVCOperation *operation, NSNotification *notification) {
			[[self applicationDelegate] mergeChanges:notification];
		}];
		[parseAndLoad setDidStartBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] startAlertWithMessage:@"Parsing ..."];
		}];
		[parseAndLoad setProgressBlock:^(NSInteger item, NSInteger total, NSString *msg) {
			[[self syncStatus] addStatus:item forTotal:total statusMessage:msg];
		}];
		[parseAndLoad setDidFinishBlock:^(GVCOperation *operation) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:@"Registration completed"];
			[[self syncStatus] reload:nil];
		}];
		[parseAndLoad setDidFailWithErrorBlock:^(GVCOperation *operation, NSError *err) {
			[[GVCAlertMessageCenter sharedGVCAlertMessageCenter] stopAlert];
			[[self syncStatus] endSync:GVC_SPRINTF(@"Registration failed - %@", err)];
			[[self syncStatus] reload:nil];
			
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Registration failed"  message:[err localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			
		}];
		
		[[[self applicationDelegate] operationQueue] addOperation:netOp];
		[[[self applicationDelegate] operationQueue] addOperation:parseAndLoad];
	}
}


@end
