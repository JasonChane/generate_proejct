//
//  ProcessingRequest.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "ProcessingRequest.h"
#import "Lion_HTTPWorklet2.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPServerConfig2.h"
#import "Lion_HTTPServerRouter2.h"
#import "Lion_MIME2.h"
#import "Lion_Reachability.h"

#pragma mark -

@implementation ProcessingRequest

- (void)load
{
    self.prio = 200;
}

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)workflow
{
    LionHTTPConnection2 *	conn = workflow.connection;
    //	LionHTTPServerRouter2 *	router = [LionHTTPServerRouter2 sharedInstance];
    //	LionHTTPServerConfig2 *	config = [LionHTTPServerConfig2 sharedInstance];
    
    if ( conn.request.ContentType && conn.request.ContentType.length )
    {
        NSArray * types = [conn.request.ContentType componentsSeparatedByString:@";"];
        NSString * type = [(NSString *)[types safeObjectAtIndex:0] trim];
        NSString * param = [(NSString *)[types safeObjectAtIndex:1] trim];
        
        if ( [type.lowercaseString isEqualToString:@"multipart/form-data"] )
        {
            NSString * boundary = nil;
            
            if ( param && [param.lowercaseString hasPrefix:@"boundary="] )
            {
                boundary = [param substringFromIndex:@"boundary=".length];
            }
            
            if ( boundary )
            {
                NSData * boundaryData = [[NSString stringWithFormat:@"--%@", boundary] asNSData];
                
                NSRange range1 = NSMakeRange( NSNotFound, 0 );
                NSRange range2 = NSMakeRange( NSNotFound, 0 );
                NSRange searchRange = NSMakeRange( 0, conn.request.bodyData.length );
                
                range1 = [conn.request.bodyData rangeOfData:boundaryData options:0 range:searchRange];
                if ( NSNotFound != range1.location )
                {
                    searchRange.location = range1.location + range1.length;
                    searchRange.length = conn.request.bodyData.length - searchRange.location;
                    
                    for ( ;; )
                    {
                        if ( range1.location + range1.length >= conn.request.bodyData.length )
                            break;
                        
                        range2 = [conn.request.bodyData rangeOfData:boundaryData options:0 range:searchRange];
                        if ( NSNotFound == range2.location )
                            break;
                        
                        NSRange segmentRange;
                        segmentRange.location = range1.location + range1.length;
                        segmentRange.length = range2.location - segmentRange.location;
                        
                        NSData * segment = [conn.request.bodyData subdataWithRange:segmentRange];
                        if ( segment && segment.length )
                        {
                            [self processFormData:segment withWorkflow:workflow];
                        }
                        
                        searchRange.location = range2.location + range2.length;
                        searchRange.length = conn.request.bodyData.length - searchRange.location;
                        
                        range1 = range2;
                    }
                }
            }
        }
        else
        {
            // TODO:
        }
    }
    
    // TODO:
    
    VAR_DUMP( conn.request.params );
    VAR_DUMP( conn.request.files );
    
    return YES;
}

- (void)processFormData:(NSData *)data withWorkflow:(LionHTTPWorkflow2 *)workflow
{
#define __STATE_INITIAL		(0)
#define __STATE_HEADER		(1)
#define __STATE_EOL			(2)
#define __STATE_BODY		(3)
#define __STATE_ERROR		(4)
#define __STATE_END			(5)
    
    if ( nil == data || 0 == data.length )
        return;
    
    NSUInteger				state = __STATE_INITIAL;
    NSCharacterSet *		eolCharset = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    NSCharacterSet *		colCharset = [NSCharacterSet characterSetWithCharactersInString:@":"];
    NSString *				text = [data asNSString].trim;
    NSMutableDictionary *	headers = [NSMutableDictionary dictionary];
    NSData *				body = nil;
    
    NSUInteger				line = 0;
    NSUInteger				offset = 0;
    NSUInteger				bodyOffset = 0;
    NSUInteger				bodyLength = 0;
    
    BOOL					shouldContinue = YES;
    BOOL					succeed = YES;
    
    LionHTTPConnection2 *	conn = workflow.connection;
    LionHTTPServerConfig2 *	config = [LionHTTPServerConfig2 sharedInstance];
    
    while ( shouldContinue )
    {
        if ( offset >= data.length )
        {
            state = __STATE_END;
        }
        
        switch ( state )
        {
            case __STATE_INITIAL:
            {
                if ( nil == text || 0 == data.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                state = __STATE_HEADER;
            }
                break;
                
            case __STATE_HEADER:
            {
                NSString * header = [text substringFromIndex:offset untilCharset:eolCharset];
                if ( nil == header || 0 == header.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                NSString * key = [text substringFromIndex:offset untilCharset:colCharset];
                if ( key )
                {
                    key = key.trim;
                }
                
                if ( nil == key || 0 == key.length || key.length >= header.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                NSString * value = [text substringFromIndex:(offset + key.length + 1) untilCharset:eolCharset];
                if ( value )
                {
                    value = value.trim;
                }
                
                if ( nil == value || 0 == value.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                [headers setObject:value forKey:key];
                
                offset += header.length;
                state = __STATE_EOL;
            }
                break;
                
            case __STATE_EOL:
            {
                if ( offset + 1 >= data.length )
                {
                    state = __STATE_END;
                    break;
                }
                
                if ( offset + conn.request.eol2.length <= data.length )
                {
                    NSRange range;
                    range.location = offset;
                    range.length = conn.request.eol2.length;
                    
                    if ( NSOrderedSame == [text compare:conn.request.eol2 options:NSLiteralSearch range:range] )
                    {
                        offset += conn.request.eol2.length;
                        line += 1;
                        
                        bodyOffset = offset + conn.request.eol.length;
                        bodyLength = data.length - offset - conn.request.eol.length;
                        
                        state = __STATE_BODY;
                        break;
                    }
                }
                
                if ( offset + conn.request.eol.length <= data.length )
                {
                    NSRange range;
                    range.location = offset;
                    range.length = conn.request.eol.length;
                    
                    if ( NSOrderedSame == [text compare:conn.request.eol options:NSLiteralSearch range:range] )
                    {
                        offset += conn.request.eol.length;
                        line += 1;
                        
                        state = __STATE_HEADER;
                        break;
                    }
                }
                
                state = __STATE_ERROR;
            }
                break;
                
            case __STATE_BODY:
            {
                if ( bodyLength )
                {
                    body = [data subdataWithRange:NSMakeRange(bodyOffset, bodyLength)];
                }
                
                offset = data.length;
                state = __STATE_END;
            }
                break;
                
            case __STATE_ERROR:
            {
                ERROR( @"Failed to parse HTTP package at line #%d", line + 1 );
                
                succeed = NO;
                state = __STATE_END;
            }
                break;
                
            case __STATE_END:
            {
                shouldContinue = NO;
            }
                break;
                
            default:
                break;
        }
    }
    
    if ( body && body.length )
    {
        NSString * contentDisposition = [headers objectForKey:@"Content-Disposition"];
        //		NSString * contentType = [headers objectForKey:@"Content-Type"];
        
        if ( contentDisposition )
        {
            NSArray *				components = [contentDisposition componentsSeparatedByString:@";"];
            NSMutableDictionary *	keyValues = [NSMutableDictionary dictionary];
            
            for ( NSString * component in components )
            {
                NSArray *	pair = [component componentsSeparatedByString:@"="];
                NSString *	key = ((NSString *)[pair safeObjectAtIndex:0]).trim;
                
                if ( NO == [key.lowercaseString isEqualToString:@"form-data"] )
                {
                    NSString * value = ((NSString *)[pair safeObjectAtIndex:1]).trim.unwrap;
                    if ( value )
                    {
                        [keyValues setObject:value forKey:key];
                    }
                }
            }
            
            NSString * name = [keyValues objectForKey:@"name"];
            if ( name && name.length )
            {
                NSString * filename = [keyValues objectForKey:@"filename"];
                if ( filename && filename.length )
                {
                    CFUUIDRef	uuidObj = CFUUIDCreate( nil );
                    NSString *	uuidString = (NSString *)CFUUIDCreateString( nil, uuidObj );
                    
                    NSString *	hashName = [uuidString MD5];
                    NSString *	fileExt = [filename pathExtension];
                    NSString *	filePath = nil;
                    
                    if ( fileExt )
                    {
                        filePath = [[NSString stringWithFormat:@"%@/%@.%@", config.temporaryPath, hashName, fileExt] normalize];
                    }
                    else
                    {
                        filePath = [[NSString stringWithFormat:@"%@/%@", config.temporaryPath, hashName] normalize];
                    }
                    
                    [[NSFileManager defaultManager] createDirectoryAtPath:config.temporaryPath
                                              withIntermediateDirectories:YES
                                                               attributes:nil
                                                                    error:NULL];
                    
                    BOOL succeed = [body writeToFile:filePath atomically:YES];
                    if ( succeed )
                    {
                        [conn.request.files setObject:filePath forKey:name];
                    }
                    
                    CFRelease( uuidString );
                }
                else
                {
                    [conn.request.params setObject:body forKey:name];
                }
            }
        }
    }
    
    // TODO:
}

@end
