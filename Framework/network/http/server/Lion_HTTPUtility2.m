//
//  Lion_HTTPUtility2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPUtility2.h"
#import "Lion_HTTPWorkflow2.h"

#pragma mark -

LION_EXTERN void Echo( NSString * text, ... )
{
    LionHTTPWorkflow2 * workflow = [LionHTTPWorkflow2 processingWorkflow];
    if ( workflow )
    {
        va_list args;
        va_start( args, text );
        
        NSString * content = [[NSString alloc] initWithFormat:(NSString *)text arguments:args];
        
        if ( content )
        {
            [workflow.connection.response.bodyData appendData:[content asNSData]];
            
            [content release];
        }
        
        va_end( args );
    }
}

LION_EXTERN void line( NSString * text, ... )
{
    LionHTTPWorkflow2 * workflow = [LionHTTPWorkflow2 processingWorkflow];
    if ( workflow )
    {
        va_list args;
        va_start( args, text );
        
        NSString * content = [[NSString alloc] initWithFormat:(NSString *)text arguments:args];
        
        if ( content )
        {
            [workflow.connection.response.bodyData appendData:[content asNSData]];
            [workflow.connection.response.bodyData appendData:[@"\n" asNSData]];
            
            [content release];
        }
        
        va_end( args );
    }
}

LION_EXTERN void file( NSString * filePath )
{
    if ( nil == filePath )
        return;
    
    LionHTTPWorkflow2 * workflow = [LionHTTPWorkflow2 processingWorkflow];
    if ( workflow )
    {
        NSData * fileData = [[NSData alloc] initWithContentsOfFile:filePath];
        if ( fileData )
        {
            [workflow.connection.response.bodyData appendData:fileData];
            
            [fileData release];
        }
    }
}

LION_EXTERN void header( NSString * key, NSString * value )
{
    if ( nil == key )
        return;
    
    LionHTTPWorkflow2 * workflow = [LionHTTPWorkflow2 processingWorkflow];
    if ( workflow )
    {
        if ( value )
        {
            [workflow.connection.response addHeader:key value:value];
        }
        else
        {
            [workflow.connection.response removeHeader:key];
        }
    }
}

