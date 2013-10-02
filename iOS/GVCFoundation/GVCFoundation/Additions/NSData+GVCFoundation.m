/*
 * NSData+GVCFoundation.m
 * 
 * Created by David Aspinall on 11-10-02. 
 * Copyright (c) 2011 Global Village Consulting Inc. All rights reserved.
 *
 */

#import "NSData+GVCFoundation.h"
#import "NSString+GVCFoundation.h"
#import "GVCFunctions.h"

#import <CommonCrypto/CommonDigest.h>

const NSUInteger kDefaultMaxBytesToHexDump = 1024;

@implementation NSData (GVCFoundation)

static char encodingTable[64] = {
	'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
	'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
	'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
	'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

- (NSString *)description
{
	return [self gvc_descriptionFromOffset:0];
}

- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset
{
	return [self gvc_descriptionFromOffset:startOffset limitingToByteCount:kDefaultMaxBytesToHexDump];
}

- (NSString *)gvc_descriptionFromOffset:(NSInteger)startOffset limitingToByteCount:(NSUInteger)maxBytes
{
    unsigned char *bytes = (unsigned char *)[self bytes];
    NSUInteger stopOffset = [self length];
	
		// Translate negative offset to positive, by subtracting from end
	if ( startOffset < 0 )
		startOffset = [self length] + startOffset;
	
		// Do we have more data than the caller wants?
	if ((stopOffset - startOffset) > maxBytes)
	{
		stopOffset = startOffset + maxBytes;
	}
	
		// If we're showing a subset, we'll tack in info about that
	NSString* curtailInfo = [NSString gvc_EmptyString];
	if ((startOffset > 0) || (stopOffset < [self length]))
	{
		curtailInfo = [NSString stringWithFormat:@" (showing bytes %d through %d)", startOffset, stopOffset];
	}
	
		// Start the hexdump out with an overview of the content
	NSMutableString *buf = [NSMutableString stringWithFormat:@"NSData %d bytes%@:\n", [self length], curtailInfo];
	
		// One row of 16-bytes at a time ...
    NSUInteger i, j;
    for ( i = startOffset ; i < stopOffset ; i += 16 )
    {
			// Show the row in Hex first
        for ( j = 0 ; j < 16 ; j++ )    
        {
            NSUInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                [buf appendFormat:@"%02X ", bytes[rowOffset]];
            }
            else
            {
                [buf appendFormat:@"   "];
            }
        }
		
			// Now show in ASCII
        [buf appendString:@"| "];   
        for ( j = 0 ; j < 16 ; j++ )
        {
            NSUInteger rowOffset = i+j;
            if (rowOffset < stopOffset)
            {
                unsigned char theChar = bytes[rowOffset];
                if (theChar < 32 || theChar > 127)
                {
                    theChar ='.';
                }
                [buf appendFormat:@"%c", theChar];
            }
        }
		
			// If we're not on the last row, tack on a newline
		if (i+16 < stopOffset)
		{
			[buf appendString:@"\n"];
		}
	}
	
    return buf;	
}

- (NSData *)gvc_md5Digest
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5([self bytes], (unsigned int)[self length], result);	
    return [NSData dataWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

- (NSData *)gvc_sha1Digest
{
	unsigned char result[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1([self bytes], (unsigned int)[self length], result);
    return [NSData dataWithBytes:result length:CC_SHA1_DIGEST_LENGTH];
}

- (NSString *)gvc_hexString
{
	NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([self length] * 2)];
	
    const unsigned char *dataBuffer = [self bytes];
    NSUInteger i;
    
    for (i = 0; i < [self length]; ++i)
	{
        [stringBuffer appendFormat:@"%02lx", (unsigned long)dataBuffer[i]];
	}
    
    return stringBuffer;
}

- (NSString *)gvc_base64Encoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while( YES )
	{
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining )
		{
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ )
			[result appendFormat:@"%c", encodingTable[outbuf[i]]];
		
		for( i = ctcopy; i < 4; i++ )
			[result appendString:@"="];
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

+ (NSData *)gvc_Base64Decoded:(NSString *)encoded
{
	return [[encoded dataUsingEncoding:NSUTF8StringEncoding] gvc_base64Decoded];
}

- (NSData *)gvc_base64Decoded
{
	const unsigned char	*bytes = [self bytes];
	NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
	
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	unsigned char ch = 0;
	unsigned char inbuf[4], outbuf[3];
	short i = 0, ixinbuf = 0;
	BOOL flignore = NO;
	BOOL flendtext = NO;
	
	while( YES )
	{
		if( ixtext >= lentext ) break;
		ch = bytes[ixtext++];
		flignore = NO;
		
		if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
		else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
		else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
		else if( ch == '+' ) ch = 62;
		else if( ch == '=' ) flendtext = YES;
		else if( ch == '/' ) ch = 63;
		else flignore = YES;
		
		if( ! flignore )
		{
			short ctcharsinbuf = 3;
			BOOL flbreak = NO;
			
			if( flendtext )
			{
				if( ! ixinbuf ) break;
				if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
				else ctcharsinbuf = 2;
				ixinbuf = 3;
				flbreak = YES;
			}
			
			inbuf [ixinbuf++] = ch;
			
			if( ixinbuf == 4 )
			{
				ixinbuf = 0;
				outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
				outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
				outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
				
				for( i = 0; i < ctcharsinbuf; i++ )
					[result appendBytes:&outbuf[i] length:1];
			}
			
			if( flbreak )  break;
		}
	}
	
	return [NSData dataWithData:result];
}


- (NSRange) gvc_rangeOfData:(NSData *)pattern fromStart: (NSUInteger)start;
{
    return [self rangeOfData:pattern options:0 range:NSMakeRange(start, [self length] - start)];
}


@end


@implementation NSMutableData (GVCFoundation)

- (void)gvc_appendUTF8String: (NSString *) string;
{
	if ( gvc_IsEmpty(string) == NO )
		[self appendData:[string dataUsingEncoding: NSUTF8StringEncoding]];
}

- (void)gvc_appendUTF8Format:(NSString *) format, ...;
{
    va_list argList;
    va_start(argList, format);
    [self gvc_appendUTF8String:[[NSString alloc] initWithFormat:format arguments:argList]];
    va_end(argList);
}

- (void)gvc_removeDataRange:(NSRange)range;
{
    [self replaceBytesInRange:range withBytes: NULL length: 0];
}

@end
