//
//  GVCManagedObject.h
//
//  Created by David Aspinall on 13/02/09.
//  Copyright 2010 Global Village Consulting Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GVCFoundation.h"

GVC_DEFINE_EXTERN_STR(GVCManagedObject_SYNC_ID_ATTRIBUTE);
GVC_DEFINE_EXTERN_STR(GVCManagedObject_SYNC_SRC_ATTRIBUTE);

GVC_DEFINE_EXTERN_STR(GVCManagedObject_NAME_ATTRIBUTE);
GVC_DEFINE_EXTERN_STR(GVCManagedObject_SORT_ORDER_ATTRIBUTE);

GVC_DEFINE_EXTERN_STR(GVCManagedObject_UUID_ATTRIBUTE);
GVC_DEFINE_EXTERN_STR(GVCManagedObject_CREATED_DATE_ATTRIBUTE);
GVC_DEFINE_EXTERN_STR(GVCManagedObject_UPDATED_DATE_ATTRIBUTE);

/**
 * $Date: 2009-09-08 22:51:18 -0400 (Tue, 08 Sep 2009) $
 * $Rev: 36 $
 * $Author: david $
*/
@interface GVCManagedObject : NSManagedObject 

- (void)awakeFromInsert;

@end
