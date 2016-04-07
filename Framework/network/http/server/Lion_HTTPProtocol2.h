//
//  Lion_HTTPProtocol2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

typedef enum
{
    LionHTTPVersion_UNKNOWN	= 0,
    LionHTTPVersion_9		= 9,
    LionHTTPVersion_10		= 10,
    LionHTTPVersion_11		= 11,
} LionHTTPVersion;

typedef enum
{
    LionHTTPMethod_UNKNOWN	= 0,
    LionHTTPMethod_GET,
    LionHTTPMethod_HEAD,
    LionHTTPMethod_POST,
    LionHTTPMethod_PUT,
    LionHTTPMethod_DELETE
} LionHTTPMethod;

typedef enum
{
    LionHTTPStatus_CONTINUE                 =	100,
    LionHTTPStatus_SWITCHING_PROTOCOLS      =	101,
    LionHTTPStatus_PROCESSING               =	102,
    
    LionHTTPStatus_OK                       =	200,
    LionHTTPStatus_CREATED                  =	201,
    LionHTTPStatus_ACCEPTED                 =	202,
    LionHTTPStatus_NON_AUTH_INFORMATION     =	203,
    LionHTTPStatus_NO_CONTENT               =	204,
    LionHTTPStatus_RESET_CONTENT            =	205,
    LionHTTPStatus_PARTIAL_CONTENT          =	206,
    LionHTTPStatus_MULTI_STATUS             =	207,
    
    LionHTTPStatus_SPECIAL_RESPONSE         =	300,
    LionHTTPStatus_MOVED_PERMANENTLY        =	301,
    LionHTTPStatus_MOVED_TEMPORARILY        =	302,
    LionHTTPStatus_SEE_OTHER                =	303,
    LionHTTPStatus_NOT_MODIFIED             =	304,
    LionHTTPStatus_USE_PROXY                =	305,
    LionHTTPStatus_SWITCH_PROXY             =	306,
    LionHTTPStatus_TEMPORARY_REDIRECT       =	307,
    
    LionHTTPStatus_BAD_REQUEST              =	400,
    LionHTTPStatus_UNAUTHORIZED             =	401,
    LionHTTPStatus_PAYMENT_REQUIRED         =	402,
    LionHTTPStatus_FORBIDDEN                =	403,
    LionHTTPStatus_NOT_FOUND                =	404,
    LionHTTPStatus_NOT_ALLOWED              =	405,
    LionHTTPStatus_NOT_ACCEPTABLE           =	406,
    LionHTTPStatus_PROXY_AUTH_REQUIRED      =	407,
    LionHTTPStatus_REQUEST_TIMEOUT          =	408,
    LionHTTPStatus_CONFLICT                 =	409,
    LionHTTPStatus_GONE                     =	410,
    LionHTTPStatus_LENGTH_REQUIRED          =	411,
    LionHTTPStatus_PRECONDITION_FAILED      =	412,
    LionHTTPStatus_REQUEST_ENTITY_TOO_LARGE =	413,
    LionHTTPStatus_REQUEST_URI_TOO_LARGE    =	414,
    LionHTTPStatus_UNSUPPORTED_MEDIA_TYPE   =	415,
    LionHTTPStatus_RANGE_NOT_SATISFIABLE    =	416,
    LionHTTPStatus_EXPECTATION_FAILED       =	417,
    LionHTTPStatus_TOO_MANY_CONNECTIONS     =	421,
    LionHTTPStatus_UNPROCESSABLE_ENTITY     =	422,
    LionHTTPStatus_LOCKED                   =	423,
    LionHTTPStatus_FAILED_DEPENDENCY        =	424,
    LionHTTPStatus_UNORDERED_COLLECTION     =	425,
    LionHTTPStatus_UPGRADE_REQUIRED         =	426,
    LionHTTPStatus_RETRY_WITH               =	449,
    
    LionHTTPStatus_INTERNAL_SERVER_ERROR    =	500,
    LionHTTPStatus_NOT_IMPLEMENTED          =	501,
    LionHTTPStatus_BAD_GATEWAY              =	502,
    LionHTTPStatus_SERVICE_UNAVAILABLE      =	503,
    LionHTTPStatus_GATEWAY_TIMEOUT          =	504,
    LionHTTPStatus_VERSION_NOT_SUPPORTED    =	505,
    LionHTTPStatus_VARIANT_ALSO_NEGOTIATES  =	506,
    LionHTTPStatus_INSUFFICIENT_STORAGE     =	507,
    LionHTTPStatus_LOOP_DETECTED            =	508,
    LionHTTPStatus_BANDWIDTH_LIMIT_EXCEEDED =	509,
    LionHTTPStatus_NOT_EXTENED              =	510,
    
    LionHTTPStatus_UNPARSEABLE_HEADERS      =	600
} LionHTTPStatus;

#pragma mark -

#undef	AS_HTTP_HEADER
#define	AS_HTTP_HEADER( name ) \
@property (nonatomic, retain) NSString * name;

#undef	DEF_HTTP_HEADER
#define	DEF_HTTP_HEADER( name, key ) \
@dynamic name; \
- (NSString *)name \
{ \
return [self.headers objectForKey:key]; \
} \
- (void)set##name:(NSString *)value \
{ \
if ( value ) \
{ \
if ( nil == self.headers ) \
{ \
self.headers = [NSMutableDictionary dictionary]; \
} \
[self.headers setObject:value forKey:key]; \
} \
else \
{ \
[self.headers removeObjectForKey:key]; \
} \
}

#pragma mark -

@interface LionHTTPProtocol2 : NSObject

@property (nonatomic, assign) BOOL					headValid;
@property (nonatomic, assign) NSUInteger			headLength;
@property (nonatomic, retain) NSString *			headLine;
@property (nonatomic, retain) NSMutableDictionary *	headers;

@property (nonatomic, retain) NSString *			eol;
@property (nonatomic, retain) NSString *			eol2;
@property (nonatomic, assign) BOOL					eolValid;

@property (nonatomic, assign) BOOL					bodyValid;
@property (nonatomic, assign) NSUInteger			bodyOffset;
@property (nonatomic, assign) NSUInteger			bodyLength;
@property (nonatomic, retain) NSMutableData *		bodyData;

+ (NSString *)statusMessage:(LionHTTPStatus)status;

#pragma mark -

- (NSData *)pack;
- (NSData *)packIncludeBody:(BOOL)flag;

- (BOOL)unpack:(NSData *)data;
- (BOOL)unpack:(NSData *)data includeBody:(BOOL)flag;

#pragma mark -

- (NSString *)packHead;
- (NSData *)packBody;

- (BOOL)unpackHead:(NSString *)text;
- (BOOL)unpackBody:(NSData *)data;

#pragma mark -

- (void)addHeader:(NSString *)key value:(NSString *)value;
- (void)addHeaders:(NSDictionary *)dict;
- (void)removeHeader:(NSString *)key;

@end

