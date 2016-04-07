//
//  Lion_HTTPConnectionPool2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPConnectionPool2.h"
#import "Lion_HTTPConnection2.h"
#import "Lion_HTTPWorkflow2.h"

#pragma mark -

@interface LionHTTPConnectionPool2()
{
    NSMutableArray * _connections;
}
@end

#pragma mark -

@implementation LionHTTPConnectionPool2

DEF_SINGLETON( LionHTTPConnectionPool2 )

- (id)init
{
    self = [super init];
    if ( self )
    {
        _connections = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_connections removeAllObjects];
    [_connections release];
    
    [super dealloc];
}

#pragma mark -

- (void)addConnection:(LionHTTPConnection2 *)conn
{
    [_connections addObject:conn];
}

- (void)removeConnection:(LionHTTPConnection2 *)conn
{
    [_connections removeObject:conn];
    
    [conn autorelease];
}

- (void)removeAllConnections
{
    [_connections removeAllObjects];
}

#pragma mark -

+ (LionHTTPConnection2 *)acceptConnectionFrom:(LionSocket *)listener
{
    ASSERT( listener );
    
    LionHTTPConnection2 * conn = [[[LionHTTPConnection2 alloc] init] autorelease];
    if ( conn )
    {
        BOOL succeed = [conn acceptFrom:listener];
        if ( succeed )
        {
            return conn;
        }
    }
    
    [listener refuse];
    return nil;
}

@end
