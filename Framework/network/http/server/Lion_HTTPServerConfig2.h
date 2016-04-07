//
//  Lion_HTTPServerConfig2.h
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
#import "Lion_HTTPServer2.h"

#pragma mark -

AS_PACKAGE( LionHTTPServer2, LionHTTPServerConfig2, config );

#pragma mark -

@interface LionHTTPServerConfig2 : NSObject

AS_SINGLETON( LionHTTPServerConfig2 )

@property (nonatomic, assign) NSUInteger		port;
@property (nonatomic, retain) NSString *		documentPath;
@property (nonatomic, retain) NSString *		temporaryPath;

- (void)loadConfig;
- (void)loadConfig:(NSString *)path;

@end
