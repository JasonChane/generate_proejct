//
//  ProcessingRoutes.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "ProcessingRoutes.h"
#import "Lion_HTTPWorklet2.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPServerConfig2.h"
#import "Lion_HTTPServerRouter2.h"
#import "Lion_MIME2.h"
#import "Lion_Reachability.h"

#pragma mark -

@implementation ProcessingRoutes

- (void)load
{
    self.prio = 300;
}

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)workflow
{
    LionHTTPConnection2 *	conn = workflow.connection;
    LionHTTPServerRouter2 *	router = [LionHTTPServerRouter2 sharedInstance];
    LionHTTPServerConfig2 *	config = [LionHTTPServerConfig2 sharedInstance];
    
    BOOL		found = NO;
    NSString *	resource = conn.request.resource;
    NSString *	rootPath = config.documentPath;
    
    if ( resource && resource.length )
    {
        found = [router routes:resource];
    }
    else
    {
        found = [router routes:@"/"];
    }
    
    if ( NO == found )
    {
        NSString *	filePath = [[NSString stringWithFormat:@"%@/%@", rootPath, resource] normalize];
        NSData *	fileData = nil;
        
        BOOL isDirectory = NO;
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
        if ( exists && NO == isDirectory )
        {
            fileData = [NSData dataWithContentsOfFile:filePath];
        }
        
        if ( fileData && fileData.length )
        {
            conn.response.ContentType = [LionMIME2 fromFileExtension:[filePath pathExtension]];
            [conn.response.bodyData appendData:fileData];
            
            found = YES;
        }
    }
    
    if ( NO == found )
    {
        conn.response.status = LionHTTPStatus_NOT_FOUND;
    }
    
    return YES;
}

@end
