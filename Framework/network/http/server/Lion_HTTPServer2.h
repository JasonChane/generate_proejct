//
//  Lion_HTTPServer2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPPackage.h"
#import "Lion_HTTPProtocol2.h"
#import "Lion_HTTPConnection2.h"
#import "Lion_HTTPRequest2.h"
#import "Lion_HTTPResponse2.h"

#pragma mark -

AS_PACKAGE( LionPackage_HTTP, LionHTTPServer2, server );

#pragma mark -

@interface LionHTTPServer2 : NSObject

AS_SINGLETON( LionHTTPServer2 )

@property (nonatomic, readonly) BOOL		running;
@property (nonatomic, retain) LionSocket *	listener;

- (BOOL)start;
- (BOOL)stop;

@end