//
//  Lion_HTTPConnection2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPConnection2.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPConnectionPool2.h"

#pragma mark -

@implementation LionHTTPConnection2

@synthesize socket = _socket;
@synthesize request = _request;
@synthesize response = _response;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.socket = nil;
        self.request = nil;
        self.response = nil;
        
        [self performLoad];
    }
    return self;
}

- (void)dealloc
{
    [self performUnload];
    
    self.socket = nil;
    self.request = nil;
    self.response = nil;
    
    [super dealloc];
}

#pragma mark -

ON_SOCKET( sock )
{
    if ( sock != self.socket )
    {
        ERROR( @"Invalid socket file handle" );
        
        [sock disconnect];
        return;
    }
    
    if ( sock.accepting )
    {
        [[LionHTTPConnectionPool2 sharedInstance] addConnection:self];
    }
    else if ( sock.accepted )
    {
    }
    else if ( sock.readable )
    {
        if ( nil == self.request )
        {
            self.request = [LionHTTPRequest2 request:sock.readableData];
            if ( self.request )
            {
                self.response = [self.request response];
                
                [LionHTTPWorkflow2 process:self];
                
                [self.socket send:[self.response packIncludeBody:YES]];
                [self.socket disconnect];
            }
        }
    }
    else if ( sock.writable )
    {
    }
    else if ( sock.disconnecting )
    {
    }
    else if ( sock.disconnected )
    {
        [[LionHTTPConnectionPool2 sharedInstance] removeConnection:self];
    }
}

#pragma mark -

- (BOOL)acceptFrom:(LionSocket *)listener
{
    if ( nil == listener )
    {
        return NO;
    }
    
    self.socket = [listener accept];
    if ( nil == self.socket )
    {
        return NO;
    }
    
    self.socket.autoConsume = NO;
    self.socket.autoHeartbeat = NO;
    self.socket.autoReconnect = NO;
    [self.socket addResponder:self];
    
    return YES;
}

@end
