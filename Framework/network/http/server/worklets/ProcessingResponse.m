//
//  ProcessingResponse.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "ProcessingResponse.h"
#import "Lion_HTTPWorklet2.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPServerConfig2.h"
#import "Lion_HTTPServerRouter2.h"
#import "Lion_MIME2.h"
#import "Lion_Reachability.h"

#pragma mark -

@implementation ProcessingResponse

- (void)load
{
    self.prio = 400;
}

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)workflow
{
    LionHTTPConnection2 *	conn = workflow.connection;
    LionHTTPServerRouter2 *	router = [LionHTTPServerRouter2 sharedInstance];
    //	LionHTTPServerConfig2 *	config = [LionHTTPServerConfig2 sharedInstance];
    
    conn.response.Server = @"bhttpd";
    conn.response.Date = [[NSDate date] description];
    
    if ( LionHTTPStatus_OK != conn.response.status )
    {
        BOOL found = [router routes:[@(conn.response.status) asNSString]];
        if ( NO == found )
        {
            NSString * template = @"<html><body><pre>500 internal error.</pre></body></html>";
            
            conn.response.status = LionHTTPStatus_INTERNAL_SERVER_ERROR;
            [conn.response.bodyData appendData:[template asNSData]];
        }
    }
    
    if ( conn.response.bodyData && conn.response.bodyData.length )
    {
        conn.response.ContentLength = [NSString stringWithFormat:@"%lu", (unsigned long)(conn.response.bodyData.length)];
    }
    
    if ( LionHTTPMethod_GET == conn.request.method )
    {
        // TODO:
    }
    else if ( LionHTTPMethod_POST == conn.request.method )
    {
        // TODO:
    }
    else if ( LionHTTPMethod_HEAD == conn.request.method )
    {
        // TODO:
    }
    else if ( LionHTTPMethod_PUT == conn.request.method )
    {
        // TODO:
    }
    else if ( LionHTTPMethod_DELETE == conn.request.method )
    {
        // TODO:
    }
    
    return YES;
}

@end
