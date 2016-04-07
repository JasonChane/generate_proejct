//
//  Lion_HTTPServer2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPServer2.h"
#import "Lion_HTTPServerConfig2.h"
#import "Lion_HTTPServerRouter2.h"
#import "Lion_HTTPUtility2.h"
#import "Lion_HTTPConnectionPool2.h"

#pragma mark -

DEF_PACKAGE( LionPackage_HTTP, LionHTTPServer2, server );

#pragma mark -

#undef	DEFAULT_PORT
#define	DEFAULT_PORT	(3000)

#pragma mark -

@interface LionHTTPServer2()
{
    BOOL _running;
}
@end

#pragma mark -

@implementation LionHTTPServer2

DEF_SINGLETON( LionHTTPServer2 )

@synthesize running = _running;
@synthesize listener = _listener;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.listener = nil;
    }
    return self;
}

- (void)dealloc
{
    [self stop];
    
    self.listener = nil;
    
    [super dealloc];
}

- (BOOL)start
{
    if ( _running )
    {
        ERROR( @"HTTP server already running" );
        return NO;
    }
    
    NSUInteger port = [LionHTTPServerConfig2 sharedInstance].port;
    NSString * path = [LionHTTPServerConfig2 sharedInstance].documentPath;
    
    BOOL isDirectory = NO;
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
    if ( NO == exists )
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    
    LionSocket * sock = [LionSocket socket];
    if ( sock )
    {
        [sock addResponder:self];
        
        BOOL succeed = [sock listen:port];
        if ( succeed )
        {
            self.listener = sock;
            
            _running = YES;
            return YES;
        }
    }
    
    ERROR( @"HTTP server cannot listen on port %d", port );
    return NO;
}

- (BOOL)stop
{
    if ( NO == _running )
    {
        ERROR( @"HTTP server not running" );
        return NO;
    }
    
    if ( self.listener )
    {
        [self.listener removeAllResponders];
        [self.listener stop];
        self.listener = nil;
    }
    
    _running = NO;
    return YES;
}

ON_SOCKET( sock )
{
    if ( sock.listenning )
    {
        INFO( @"HTTP server, starting" );
    }
    else if ( sock.acceptable )
    {
        INFO( @"HTTP server, new connection" );
        
        LionHTTPConnection2 * connection = [LionHTTPConnectionPool2 acceptConnectionFrom:sock];
        if ( nil == connection )
        {
            ERROR( @"HTTP server cannot accept new connections" );
        }
    }
    else if ( sock.stopping )
    {
        INFO( @"HTTP server, stopping" );
    }
    else if ( sock.stopped )
    {
        INFO( @"HTTP server, stopped" );
    }
}

@end
