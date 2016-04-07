//
//  Lion_HTTPConnectionPool2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Socket.h"

#import "Lion_HTTPPackage.h"
#import "Lion_HTTPProtocol2.h"
#import "Lion_HTTPConnection2.h"
#import "Lion_HTTPRequest2.h"
#import "Lion_HTTPResponse2.h"

#pragma mark -

@interface LionHTTPConnectionPool2 : NSObject

AS_SINGLETON( LionHTTPConnectionPool2 )

- (void)addConnection:(LionHTTPConnection2 *)conn;
- (void)removeConnection:(LionHTTPConnection2 *)conn;
- (void)removeAllConnections;

+ (LionHTTPConnection2 *)acceptConnectionFrom:(LionSocket *)listener;

@end

