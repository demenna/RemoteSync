//
//  GVCAppDelegate.h
//  MobileNotes
//
//  Created by David Aspinall on 12-06-21.
//  Copyright (c) 2012 Global Village Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GVCFoundation.h"
#import "GVCUIKit.h"
#import "GVCCoreData.h"
#import "ERSync.h"

GVC_DEFINE_EXTERN_STR(SYNC_APP_ID)
GVC_DEFINE_EXTERN_STR(SYNC_DEVICE_IPAD) //743E2D47-DDA4-4827-A164-0C61547CD4D5

@interface GVCAppDelegate : GVCCoreDataUIAppDelegate

@property (nonatomic, retain) SyncEngine *engine;
@property (nonatomic, retain) SyncPrincipal *principal;

- (void)syncEngineDidReset;

@end
