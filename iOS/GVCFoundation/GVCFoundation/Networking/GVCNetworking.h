/*
 * GVCNetworking.h
 * 
 * Created by David Aspinall on 12-05-13. 
 * Copyright (c) 2012 Global Village Consulting. All rights reserved.
 *
 */

#import "GVCMacros.h"
#import "GVCFunctions.h"

#import <Foundation/Foundation.h>

#ifndef GVCFoundation_GVCNetworking_h
#define GVCFoundation_GVCNetworking_h

#pragma mark - HTTP Headers
// Special characters defined in the MIME standard, RFC-1521
// http://www.ietf.org/rfc/rfc1521.txt

GVC_EXTERN NSCharacterSet *gvc_RFC1521SpecialCharacters(void);
GVC_EXTERN NSCharacterSet *gvc_RFC1521TokenCharacters(void);
GVC_EXTERN NSCharacterSet *gvc_RFC1521NonTokenCharacters(void);

GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_content_type)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_cache_control)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_connection)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_date)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_expires)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_keep_alive)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_mime_version)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_pragma)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_server)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_set_cookie)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_cookie)
GVC_DEFINE_EXTERN_STR(GVC_HTTP_HEADER_KEY_transfer_encoding)

#pragma mark - MIME Types
/*
 image/tiff
 image/jpeg
 image/gif
 image/png
 image/ico
 image/x-icon
 image/bmp
 image/x-bmp
 image/x-xbitmap
 image/x-win-bitmap
 */

GVC_EXTERN NSSet *gvc_MimeType_Images(void);



#endif
