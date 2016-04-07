//
//  Lion_HTTPRequest2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPProtocol2.h"

#pragma mark -

@class LionHTTPResponse2;

@interface LionHTTPRequest2 : LionHTTPProtocol2

@property (nonatomic, assign) LionHTTPVersion		version;
@property (nonatomic, assign) LionHTTPMethod			method;
@property (nonatomic, retain) NSString *			resource;

@property (nonatomic, retain) NSMutableDictionary *	params;
@property (nonatomic, retain) NSMutableDictionary *	files;

AS_HTTP_HEADER( Accept )				// Accept: text/plain, text/html
AS_HTTP_HEADER( AcceptCharset )			// Accept-Charset: iso-8859-5
AS_HTTP_HEADER( AcceptEncoding )		// Accept-Encoding: compress, gzip
AS_HTTP_HEADER( AcceptLanguage )		// Accept-Language: en,zh
AS_HTTP_HEADER( AcceptRanges )			// Accept-Ranges: bytes
AS_HTTP_HEADER( Authorization )			// Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
AS_HTTP_HEADER( CacheControl )			// Cache-Control: no-cache
AS_HTTP_HEADER( Connection )			// Connection: close
AS_HTTP_HEADER( Cookie )				// Cookie: $Version=1; Skin=new;
AS_HTTP_HEADER( ContentLength )			// Content-Length: 348
AS_HTTP_HEADER( ContentType )			// Content-Type: application/x-www-form-urlencoded
AS_HTTP_HEADER( Date )					// Date: Tue, 15 Nov 2010 08:12:31 GMT
AS_HTTP_HEADER( Expect )				// Expect: 100-continue
AS_HTTP_HEADER( From )					// From: user@email.com
AS_HTTP_HEADER( Host )					// Host: www.zcmhi.com
AS_HTTP_HEADER( IfMatch )				// If-Match: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfModifiedSince )		// If-Modified-Since: Sat, 29 Oct 2010 19:43:31 GMT
AS_HTTP_HEADER( IfNoneMatch )			// If-None-Match: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfRange )				// If-Range: “737060cd8c284d8af7ad3082f209582d”
AS_HTTP_HEADER( IfUnmodifiedSince )		// If-Unmodified-Since: Sat, 29 Oct 2010 19:43:31 GMT
AS_HTTP_HEADER( MaxForwards )			// Max-Forwards: 10
AS_HTTP_HEADER( Pragma )				// Pragma: no-cache
AS_HTTP_HEADER( ProxyAuthorization )	// Proxy-Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
AS_HTTP_HEADER( Range )					// Range: bytes=500-999
AS_HTTP_HEADER( Referer )				// Referer: http://www.zcmhi.com/archives/71.html
AS_HTTP_HEADER( TE )					// TE: trailers,deflate;q=0.5
AS_HTTP_HEADER( Upgrade )				// Upgrade: HTTP/2.0, SHTTP/1.3, IRC/6.9, RTA/x11
AS_HTTP_HEADER( UserAgent )				// User-Agent: Mozilla/5.0 (Linux; X11)
AS_HTTP_HEADER( Via )					// Via: 1.0 fred, 1.1 nowhere.com (Apache/1.1)
AS_HTTP_HEADER( Warning )				// Warn: 199 Miscellaneous warning

+ (LionHTTPRequest2 *)request;
+ (LionHTTPRequest2 *)request:(NSData *)data;

- (LionHTTPResponse2 *)response;

@end
