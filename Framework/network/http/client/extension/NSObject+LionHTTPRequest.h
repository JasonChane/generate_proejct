//
//  NSObject+LionHTTPRequest.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#import "Lion_HTTPRequest.h"
#import "Lion_HTTPRequestQueue.h"

#pragma mark -

@interface NSObject(LionHTTPRequestResponder)

@property (nonatomic, readonly) LionHTTPBoolBlockV		REQUESTING;
@property (nonatomic, readonly) LionHTTPBoolBlockS		REQUESTING_URL;
@property (nonatomic, readonly) LionHTTPBoolBlockV		CANCEL_REQUESTS;

@property (nonatomic, readonly) LionHTTPRequestBlockSN	GET;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	PUT;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	POST;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	DELETE;

@property (nonatomic, readonly) LionHTTPRequestBlockSN	HTTP_GET;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	HTTP_PUT;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	HTTP_POST;
@property (nonatomic, readonly) LionHTTPRequestBlockSN	HTTP_DELETE;

- (LionHTTPRequest *)GET:(NSString *)url;
- (LionHTTPRequest *)PUT:(NSString *)url;
- (LionHTTPRequest *)POST:(NSString *)url;
- (LionHTTPRequest *)DELETE:(NSString *)url;

- (LionHTTPRequest *)HTTP_GET:(NSString *)url;
- (LionHTTPRequest *)HTTP_PUT:(NSString *)url;
- (LionHTTPRequest *)HTTP_POST:(NSString *)url;
- (LionHTTPRequest *)HTTP_DELETE:(NSString *)url;

- (BOOL)requestingURL;
- (BOOL)requestingURL:(NSString *)url;
- (LionHTTPRequest *)request;
- (NSArray *)requests;
- (NSArray *)requests:(NSString *)url;
- (void)cancelRequests;

@end
