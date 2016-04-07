//
//  Lion_HTTPRequestQueue.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPPackage.h"
#import "Lion_HTTPRequest.h"

#pragma mark -

AS_PACKAGE( LionPackage_HTTP, LionHTTPRequestQueue, requestQueue );

#pragma mark -

@class LionHTTPRequest;
@class LionHTTPRequestQueue;

@compatibility_alias LionRequestQueue LionHTTPRequestQueue;

typedef void (^LionHTTPRequestQueueBlock)( LionHTTPRequest * req );

#pragma mark -

@interface LionHTTPRequestQueue : NSObject<ASIHTTPRequestDelegate>

AS_SINGLETON( LionHTTPRequestQueue )

@property (nonatomic, assign) BOOL						merge;
@property (nonatomic, assign) BOOL						online;				// 开网/断网

@property (nonatomic, assign) BOOL						blackListEnable;	// 是否使用黑名单
@property (nonatomic, assign) NSTimeInterval			blackListTimeout;	// 黑名单超时
@property (nonatomic, retain) NSMutableDictionary *		blackList;

@property (nonatomic, assign) NSUInteger				bytesUpload;
@property (nonatomic, assign) NSUInteger				bytesDownload;

@property (nonatomic, assign) NSTimeInterval			delay;
@property (nonatomic, retain) NSMutableArray *			requests;

@property (nonatomic, copy) LionHTTPRequestQueueBlock	whenCreate;
@property (nonatomic, copy) LionHTTPRequestQueueBlock	whenUpdate;

+ (BOOL)isNetworkInUse;
+ (NSUInteger)bandwidthUsedPerSecond;

+ (LionHTTPRequest *)GET:(NSString *)url;
+ (LionHTTPRequest *)POST:(NSString *)url;
+ (LionHTTPRequest *)PUT:(NSString *)url;
+ (LionHTTPRequest *)DELETE:(NSString *)url;

+ (BOOL)requesting:(NSString *)url;
+ (BOOL)requesting:(NSString *)url byResponder:(id)responder;

+ (NSArray *)requests:(NSString *)url;
+ (NSArray *)requests:(NSString *)url byResponder:(id)responder;

+ (void)cancelRequest:(LionHTTPRequest *)request;
+ (void)cancelRequestByResponder:(id)responder;
+ (void)cancelAllRequests;

+ (void)blockURL:(NSString *)url;
+ (void)unblockURL:(NSString *)url;

@end
