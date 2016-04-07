//
//  Lion_HTTPServerConfig2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPServerConfig2.h"

#pragma mark -

DEF_PACKAGE( LionHTTPServer2, LionHTTPServerConfig2, config );

#pragma mark -

#undef	DEFAULT_PORT
#define	DEFAULT_PORT	(3000)

#pragma mark -

@interface LionHTTPServer2()
{
    NSUInteger	_port;
    NSString *	_documentPath;
}
@end

#pragma mark -

@implementation LionHTTPServerConfig2

DEF_SINGLETON( LionHTTPServerConfig2 )

@synthesize port = _port;
@synthesize documentPath = _documentPath;
@synthesize temporaryPath = _temporaryPath;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.port = DEFAULT_PORT;
        
#if (TARGET_OS_MAC)
        
        char	buff[256] = { 0 };
        //		char *	result = getcwd( buff, 256 - 1 );
        
        self.documentPath = [NSString stringWithUTF8String:buff];
        self.temporaryPath = [NSString stringWithUTF8String:buff];
        
#elif (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        
        self.documentPath = [LionSandbox docPath];
        self.temporaryPath = [LionSandbox tmpPath];
        
#endif	// #elif (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    }
    return self;
}

- (void)dealloc
{
    self.documentPath = nil;
    self.temporaryPath = nil;
    
    [super dealloc];
}

- (void)loadConfig
{
    [self loadConfig:@"config.json"];
}

- (void)loadConfig:(NSString *)path
{
    // TODO:
}

@end
