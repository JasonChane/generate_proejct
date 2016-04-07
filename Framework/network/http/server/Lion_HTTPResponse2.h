//
//  Lion_HTTPResponse2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPProtocol2.h"

#pragma mark -

#undef	Lion_SERVER_NAME
#define	Lion_SERVER_NAME		@"bhttpd"

#pragma mark -

@interface LionHTTPResponse2 : LionHTTPProtocol2

@property (nonatomic, assign) LionHTTPVersion		version;
@property (nonatomic, assign) LionHTTPStatus			status;
@property (nonatomic, retain) NSString *			statusMessage;

AS_HTTP_HEADER( AcceptRanges )			// Accept-Ranges: bytes
AS_HTTP_HEADER( Age )					// Age: 12
AS_HTTP_HEADER( Allow )					// Allow: GET, HEAD
AS_HTTP_HEADER( Connection )			// Connection: close
AS_HTTP_HEADER( CacheControl )			// Cache-Control: no-cache
AS_HTTP_HEADER( ContentEncoding )		// Content-Encoding: gzip
AS_HTTP_HEADER( ContentLanguage )		// Content-Language: en,zh
AS_HTTP_HEADER( ContentLength )			// Content-Length: 348
AS_HTTP_HEADER( ContentLocation )		// Content-Location: /index.htm
AS_HTTP_HEADER( ContentMD5 )			// Content-MD5: Q2hlY2sgSW50ZWdyaXR5IQ==
AS_HTTP_HEADER( ContentRange )			// Content-Range: bytes 21010-47021/47022
AS_HTTP_HEADER( ContentType )			// Content-Type: text/html; charset=utf-8
AS_HTTP_HEADER( Date )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
AS_HTTP_HEADER( ETag )					// ETag: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( Expires )				// Expires: Thu, 01 Dec 2010 16:00:00 GMT
AS_HTTP_HEADER( LastModified )			// Last-Modified: Tue, 15 Nov 2010 12:45:26 GMT
AS_HTTP_HEADER( Location )				// Location: http://www.zcmhi.com/archives/94.html
AS_HTTP_HEADER( Pragma )				// Pragma: no-cache
AS_HTTP_HEADER( ProxyAuthenticate )		// Proxy-Authenticate: Basic
AS_HTTP_HEADER( Refresh )				// Refresh: 5; url=http://www.zcmhi.com/archives/94.html
AS_HTTP_HEADER( RetryAfter )			// Retry-After: 120
AS_HTTP_HEADER( Server )				// Server: Apache/1.3.27 (Unix) (Red-Hat/Linux)
AS_HTTP_HEADER( SetCookie )				// Set-Cookie: UserID=JohnDoe; Max-Age=3600; Version=1
AS_HTTP_HEADER( Trailer )				// Trailer: Max-Forwards
AS_HTTP_HEADER( TransferEncoding )		// Transfer-Encoding:chunked
AS_HTTP_HEADER( Vary )					// Vary: *
AS_HTTP_HEADER( Via )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
AS_HTTP_HEADER( Warning )				// Warning: 199 Miscellaneous warning
AS_HTTP_HEADER( WWWAuthenticate )		// WWW-Authenticate: Basic

+ (LionHTTPResponse2 *)response;
+ (LionHTTPResponse2 *)response:(NSData *)data;

@end
