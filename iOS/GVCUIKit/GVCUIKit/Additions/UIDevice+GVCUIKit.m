/*
 * UIDevice+GVCUIKit.h
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "UIDevice+GVCUIKit.h"

#include <sys/sysctl.h>  
#include <mach/mach.h>

@implementation UIDevice (UIDeviceGVCUIKit)

- (NSString *)gvc_userInterfaceIdiomString
{
	return ([self userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? @"iPad" : @"iPhone";
}

- (double)gvc_availableMemory 
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
    if (kernReturn != KERN_SUCCESS) 
	{
        return NSNotFound;
    }
    
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

- (NSString *)gvc_phoneNumber 
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
}

@end
