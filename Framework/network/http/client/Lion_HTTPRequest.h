//
//  Lion_HTTPRequest.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

@class ASIFormDataRequest;
@class LionHTTPRequest;

#pragma mark -

@interface NSObject(LionHTTPRequest)
- (BOOL)isRequestResponder;
- (BOOL)prehandleRequest:(LionHTTPRequest *)request;
- (void)handleRequest:(LionHTTPRequest *)request;
- (void)posthandleRequest:(LionHTTPRequest *)request;
@end

#pragma mark -

#undef	BEFORE_REQUEST
#define BEFORE_REQUEST( __req ) \
- (void)prehandleRequest:(LionHTTPRequest *)__req

#undef	AFTER_REQUEST
#define AFTER_REQUEST( __req ) \
- (void)posthandleRequest:(LionHTTPRequest *)__req

#undef	ON_REQUEST
#define ON_REQUEST( __req ) \
- (void)handleRequest:(LionHTTPRequest *)__req

#undef	ON_HTTP_REQUEST
#define ON_HTTP_REQUEST( __req ) \
- (void)handleRequest:(LionHTTPRequest *)__req

@compatibility_alias LionRequest LionHTTPRequest;

typedef void				(^LionHTTPRequestBlock)( void );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockV)( void );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockB)( BOOL flag );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockT)( NSTimeInterval interval );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockN)( id key, ... );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockS)( NSString * string );
typedef LionHTTPRequest *	(^LionHTTPRequestBlockSN)( NSString * string, ... );
typedef BOOL				(^LionHTTPBoolBlockS)( NSString * url );
typedef BOOL				(^LionHTTPBoolBlockV)( void );

#pragma mark -

@interface LionHTTPRequest : ASIFormDataRequest

AS_INT( STATE_CREATED );
AS_INT( STATE_SENDING );
AS_INT( STATE_RECVING );
AS_INT( STATE_FAILED );
AS_INT( STATE_SUCCEED );
AS_INT( STATE_CANCELLED );
AS_INT( STATE_REDIRECTED );

@property (nonatomic, readonly) LionHTTPRequestBlockN	HEADER;				// directly set header
@property (nonatomic, readonly) LionHTTPRequestBlockN	BODY;				// directly set body
@property (nonatomic, readonly) LionHTTPRequestBlockN	PARAM;				// add key value
@property (nonatomic, readonly) LionHTTPRequestBlockN    PARAMS;				// add keys values
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE;				// add file data
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_ALIAS;
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_MP4;			// add jpeg file
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_MP4_ALIAS;		// add jpeg file
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_PNG;			// add png file
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_PNG_ALIAS;		// add png file
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_JPG;			// add jpeg file
@property (nonatomic, readonly) LionHTTPRequestBlockN	FILE_JPG_ALIAS;		// add jpeg file
@property (nonatomic, readonly) LionHTTPRequestBlockT	TIMEOUT;			// add file data
@property (nonatomic, readonly) LionHTTPRequestBlockS	SAVE_AS;			// save the response data into a file
@property (nonatomic, readonly) LionHTTPRequestBlockB	SHOULD_COMPRESS;	// save the response data into a file
@property (nonatomic, readonly) LionHTTPRequestBlockB	SHOULD_DECOMPRESS;	// save the response data into a file

@property (nonatomic, assign) NSUInteger				state;
@property (nonatomic, retain) NSMutableArray *			responders;
//@property (nonatomic, assign) id						responder;

@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSMutableDictionary *		userInfo;
@property (nonatomic, retain) NSObject *				userObject;

@property (nonatomic, copy) LionHTTPRequestBlock			whenUpdate;
@property (nonatomic, copy) LionHTTPRequestBlock			whenSending;
@property (nonatomic, copy) LionHTTPRequestBlock			whenSendProgressed;
@property (nonatomic, copy) LionHTTPRequestBlock			whenRecving;
@property (nonatomic, copy) LionHTTPRequestBlock			whenRecvProgressed;
@property (nonatomic, copy) LionHTTPRequestBlock			whenFailed;
@property (nonatomic, copy) LionHTTPRequestBlock			whenSucceed;
@property (nonatomic, copy) LionHTTPRequestBlock			whenCancelled;
@property (nonatomic, copy) LionHTTPRequestBlock			whenRedirected;

@property (nonatomic, assign) NSTimeInterval			initTimeStamp;
@property (nonatomic, assign) NSTimeInterval			sendTimeStamp;
@property (nonatomic, assign) NSTimeInterval			recvTimeStamp;
@property (nonatomic, assign) NSTimeInterval			doneTimeStamp;

@property (nonatomic, readonly) NSTimeInterval			timeCostPending;	// 排队等待耗时
@property (nonatomic, readonly) NSTimeInterval			timeCostOverDNS;	// 网络连接耗时（DNS）
@property (nonatomic, readonly) NSTimeInterval			timeCostRecving;	// 网络收包耗时
@property (nonatomic, readonly) NSTimeInterval			timeCostOverAir;	// 网络整体耗时

#if __Lion_DEVELOPMENT__
@property (nonatomic, readonly) NSMutableArray *		callstack;
#endif	// #if __Lion_DEVELOPMENT__

@property (nonatomic, readonly) BOOL					created;
@property (nonatomic, readonly) BOOL					sending;
@property (nonatomic, readonly) BOOL					recving;
@property (nonatomic, readonly) BOOL					failed;
@property (nonatomic, readonly) BOOL					succeed;
@property (nonatomic, readonly) BOOL					cancelled;
@property (nonatomic, readonly) BOOL					redirected;
@property (nonatomic, readonly) BOOL					sendProgressed;
@property (nonatomic, readonly) BOOL					recvProgressed;

@property (nonatomic, readonly) CGFloat					uploadPercent;
@property (nonatomic, readonly) NSUInteger				uploadBytes;
@property (nonatomic, readonly) NSUInteger				uploadTotalBytes;

@property (nonatomic, readonly) CGFloat					downloadPercent;
@property (nonatomic, readonly) NSUInteger				downloadBytes;
@property (nonatomic, readonly) NSUInteger				downloadTotalBytes;

- (BOOL)is:(NSString *)url;
- (void)changeState:(NSUInteger)state;

- (BOOL)hasResponder:(id)responder;
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponders;

- (void)callResponders;
- (void)forwardResponder:(NSObject *)obj;

- (void)updateSendProgress;
- (void)updateRecvProgress;

@end

#pragma mark -

@interface LionEmptyRequest : LionHTTPRequest
@end
