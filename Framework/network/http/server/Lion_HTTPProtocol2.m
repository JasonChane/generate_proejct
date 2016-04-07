//
//  Lion_HTTPProtocol2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPProtocol2.h"

#pragma mark -

@implementation LionHTTPProtocol2

@synthesize headValid = _headValid;
@synthesize headLength = _headLength;
@synthesize headLine = _headLine;
@synthesize headers = _headers;

@synthesize eol = _eol;
@synthesize eol2 = _eol2;
@synthesize eolValid = _eolValid;

@synthesize bodyValid = _bodyValid;
@synthesize bodyOffset = _bodyOffset;
@synthesize bodyLength = _bodyLength;
@synthesize bodyData = _bodyData;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.headLine = nil;
        self.headers = [NSMutableDictionary dictionary];
        self.bodyData = [NSMutableData data];
        
        self.eol = nil;
        self.eol2 = nil;
        
        [self performLoad];
    }
    return self;
}

- (void)dealloc
{
    [self performUnload];
    
    [self.headers removeAllObjects];
    self.headLine = nil;
    self.headers = nil;
    self.bodyData = nil;
    
    self.eol = nil;
    self.eol2 = nil;
    
    [super dealloc];
}

+ (NSString *)statusMessage:(LionHTTPStatus)status
{
    switch ( status )
    {
            /* 100 */
        case LionHTTPStatus_CONTINUE:					return @"Continue";
        case LionHTTPStatus_SWITCHING_PROTOCOLS:			return @"Switching Protocols";
        case LionHTTPStatus_PROCESSING:					return @"Processing";
            
            /* 200 */
        case LionHTTPStatus_OK:							return @"OK";
        case LionHTTPStatus_CREATED:						return @"Created";
        case LionHTTPStatus_ACCEPTED:					return @"Accepted";
        case LionHTTPStatus_NON_AUTH_INFORMATION:		return @"Non-Authoritative Information";
        case LionHTTPStatus_NO_CONTENT:					return @"No Content";
        case LionHTTPStatus_RESET_CONTENT:				return @"Reset Content";
        case LionHTTPStatus_PARTIAL_CONTENT:				return @"Partial Content";
        case LionHTTPStatus_MULTI_STATUS:				return @"Multi-Status";
            
            /* 300 */
        case LionHTTPStatus_SPECIAL_RESPONSE:			return @"Multiple Choices";
        case LionHTTPStatus_MOVED_PERMANENTLY:			return @"Moved Permanently";
        case LionHTTPStatus_MOVED_TEMPORARILY:			return @"Found";
        case LionHTTPStatus_SEE_OTHER:					return @"See Other";
        case LionHTTPStatus_NOT_MODIFIED:				return @"Not Modified";
        case LionHTTPStatus_USE_PROXY:					return @"Use Proxy";
        case LionHTTPStatus_SWITCH_PROXY:				return @"Switch Proxy";
        case LionHTTPStatus_TEMPORARY_REDIRECT:			return @"Temporary Redirect";
            
            /* 400 */
        case LionHTTPStatus_BAD_REQUEST:					return @"Bad Request";
        case LionHTTPStatus_UNAUTHORIZED:				return @"Unauthorized";
        case LionHTTPStatus_PAYMENT_REQUIRED:			return @"Payment Required";
        case LionHTTPStatus_FORBIDDEN:					return @"Forbidden";
        case LionHTTPStatus_NOT_FOUND:					return @"Not Found";
        case LionHTTPStatus_NOT_ALLOWED:					return @"Method Not Allowed";
        case LionHTTPStatus_NOT_ACCEPTABLE:				return @"Not Acceptable";
        case LionHTTPStatus_PROXY_AUTH_REQUIRED:			return @"Proxy Authentication Required";
        case LionHTTPStatus_REQUEST_TIMEOUT:				return @"Request Timeout";
        case LionHTTPStatus_CONFLICT:					return @"Conflict";
        case LionHTTPStatus_GONE:						return @"Gone";
        case LionHTTPStatus_LENGTH_REQUIRED:				return @"Length Required";
        case LionHTTPStatus_PRECONDITION_FAILED:			return @"Precondition Failed";
        case LionHTTPStatus_REQUEST_ENTITY_TOO_LARGE:	return @"Request Entity Too Large";
        case LionHTTPStatus_REQUEST_URI_TOO_LARGE:		return @"Request-URI Too Long";
        case LionHTTPStatus_UNSUPPORTED_MEDIA_TYPE:		return @"Unsupported Media Type";
        case LionHTTPStatus_RANGE_NOT_SATISFIABLE:		return @"Requested Range Not Satisfiable";
        case LionHTTPStatus_EXPECTATION_FAILED:			return @"Expectation Failed";
        case LionHTTPStatus_TOO_MANY_CONNECTIONS:		return @"There are too many connections from your internet address";
        case LionHTTPStatus_UNPROCESSABLE_ENTITY:		return @"Unprocessable Entity";
        case LionHTTPStatus_LOCKED:						return @"Locked";
        case LionHTTPStatus_FAILED_DEPENDENCY:			return @"Failed Dependency";
        case LionHTTPStatus_UNORDERED_COLLECTION:		return @"Unordered Collection";
        case LionHTTPStatus_UPGRADE_REQUIRED:			return @"Upgrade Required";
        case LionHTTPStatus_RETRY_WITH:					return @"Retry With";
            
            /* 500 */
        case LionHTTPStatus_INTERNAL_SERVER_ERROR:		return @"Internal Server Error";
        case LionHTTPStatus_NOT_IMPLEMENTED:				return @"Not Implemented";
        case LionHTTPStatus_BAD_GATEWAY:					return @"Bad Gateway";
        case LionHTTPStatus_SERVICE_UNAVAILABLE:			return @"Service Unavailable";
        case LionHTTPStatus_GATEWAY_TIMEOUT:				return @"Gateway Timeout";
        case LionHTTPStatus_VERSION_NOT_SUPPORTED:		return @"HTTP Version Not Supported";
        case LionHTTPStatus_VARIANT_ALSO_NEGOTIATES:		return @"Variant Also Negotiates";
        case LionHTTPStatus_INSUFFICIENT_STORAGE:		return @"Insufficient Storage";
        case LionHTTPStatus_LOOP_DETECTED:				return @"Loop Detected";
        case LionHTTPStatus_BANDWIDTH_LIMIT_EXCEEDED:	return @"Bandwidth Limit Exceeded";
        case LionHTTPStatus_NOT_EXTENED:					return @"Not Extended";
            
            /* 600 */
        case LionHTTPStatus_UNPARSEABLE_HEADERS:			return @"Unparseable Response Headers";
            
        default: break;
    }
    
    return @"";
}

- (NSData *)pack
{
    return [self packIncludeBody:YES];
}

- (NSData *)packIncludeBody:(BOOL)flag
{
    NSString *			endOfLine = self.eol ? self.eol : @"\r\n";
    NSMutableString *	header = [NSMutableString string];
    NSData *			body = nil;
    NSMutableData *		result = [NSMutableData data];
    
    NSString * headLine = [self packHead];
    if ( nil == headLine || 0 == headLine.length )
        return nil;
    
    [header appendString:headLine];
    [header appendString:endOfLine];
    
    NSMutableArray * keys = [NSMutableArray arrayWithArray:self.headers.allKeys];
    if ( keys && keys.count )
    {
        [keys sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
         {
             return [obj1 compare:obj2];
         }];
    }
    
    for ( NSString * key in keys )
    {
        [header appendFormat:@"%@: %@", key, [self.headers objectForKey:key]];
        [header appendString:endOfLine];
    }
    
    [header appendString:endOfLine];
    [result appendData:[header asNSData]];
    
    if ( flag )
    {
        body = [self packBody];
        if ( body )
        {
            [result appendData:body];
        }
    }
    
    return result;
}

- (BOOL)unpack:(NSData *)data
{
    return [self unpack:data includeBody:YES];
}

- (BOOL)unpack:(NSData *)data includeBody:(BOOL)bodyFlag
{
#define __STATE_INITIAL		(0)
#define __STATE_HEADER1		(1)
#define __STATE_HEADER2		(2)
#define __STATE_EOL			(3)
#define __STATE_BODY		(4)
#define __STATE_ERROR		(5)
#define __STATE_END			(6)
    
    if ( nil == data || 0 == data.length )
        return NO;
    
    NSUInteger			state = __STATE_INITIAL;
    NSCharacterSet *	eolCharset = [NSCharacterSet characterSetWithCharactersInString:@"\r\n"];
    NSCharacterSet *	colCharset = [NSCharacterSet characterSetWithCharactersInString:@":"];
    NSString *			text = [data asNSString];
    
    NSUInteger			line = 0;
    NSUInteger			offset = 0;
    
    BOOL				shouldContinue = YES;
    BOOL				succeed = YES;
    
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
                //				INFO( @"Start to parse" );
                
                self.headLine = nil;
                self.headers = [NSMutableDictionary dictionary];
                
                if ( nil == text || 0 == data.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                state = __STATE_HEADER1;
            }
                break;
                
            case __STATE_HEADER1:
            case __STATE_HEADER2:
            {
                //				INFO( @"Found header" );
                
                NSString * header = [text substringFromIndex:offset untilCharset:eolCharset];
                if ( nil == header || 0 == header.length )
                {
                    state = __STATE_ERROR;
                    break;
                }
                
                if ( __STATE_HEADER1 == state )
                {
                    BOOL correct = [self unpackHead:header];
                    if ( NO == correct )
                    {
                        state = __STATE_ERROR;
                        break;
                    }
                    
                    self.headLine = header;
                    
                    //					INFO( @"%@", header );
                }
                else
                {
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
                    
                    if ( nil == self.headers )
                    {
                        self.headers = [NSMutableDictionary dictionary];
                    }
                    
                    [self.headers setObject:value forKey:key];
                    
                    //					INFO( @"%@: %@", key, value );
                }
                
                offset += header.length;
                state = __STATE_EOL;
            }
                break;
                
            case __STATE_EOL:
            {
                //				INFO( @"Found EOL" );
                
                if ( offset + 1 >= data.length )
                {
                    state = __STATE_END;
                    break;
                }
                
                if ( NO == self.eolValid )
                {
                    NSInteger eolLength = 0;
                    
                    for ( ; offset + eolLength < data.length; ++eolLength )
                    {
                        unichar ch = [text characterAtIndex:(offset + eolLength)];
                        if ( '\n' != ch && '\r' != ch )
                        {
                            break;
                        }
                    }
                    
                    if ( 0 == eolLength )
                    {
                        state = __STATE_ERROR;
                        break;
                    }
                    
                    self.eol = [text substringWithRange:NSMakeRange( offset, eolLength )];
                    self.eol2 = [NSString stringWithFormat:@"%@%@", self.eol, self.eol];
                    self.eolValid = YES;
                }
                
                if ( nil == self.eol || nil == self.eol2 )
                {
                    state = __STATE_ERROR;
                    break;					
                }
                
                if ( offset + self.eol2.length <= data.length )
                {
                    NSRange range;
                    range.location = offset;
                    range.length = self.eol2.length;
                    
                    if ( NSOrderedSame == [text compare:self.eol2 options:NSLiteralSearch range:range] )
                    {						
                        self.headValid = YES;
                        
                        offset += self.eol2.length;
                        line += 1;
                        
                        self.headLength = offset;
                        self.bodyOffset = offset;
                        self.bodyLength = data.length - offset;
                        self.bodyValid = (self.bodyLength > 0 ? YES : NO);
                        
                        state = __STATE_BODY;
                        break;
                    }
                }
                
                if ( offset + self.eol.length <= data.length )
                {
                    NSRange range;
                    range.location = offset;
                    range.length = self.eol.length;
                    
                    if ( NSOrderedSame == [text compare:self.eol options:NSLiteralSearch range:range] )
                    {
                        offset += self.eol.length;
                        line += 1;
                        state = __STATE_HEADER2;
                        break;
                    }
                }
                
                state = __STATE_ERROR;
            }
                break;
                
            case __STATE_BODY:
            {
                //				INFO( @"Found body" );
                
                if ( bodyFlag )
                {
                    if ( self.bodyLength )
                    {
                        NSRange		dataRange = NSMakeRange( self.bodyOffset, self.bodyLength );
                        NSData *	dataSegment = [data subdataWithRange:dataRange];
                        
                        [self.bodyData appendData:dataSegment];
                    }
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
                //				INFO( @"End of parsing" );
                
                shouldContinue = NO;
            }
                break;
                
            default:
                break;
        }
    }
    
    return succeed;
}

- (NSString *)packHead
{
    return nil;
}

- (NSData *)packBody
{
    return nil;
}

- (BOOL)unpackHead:(NSString *)text
{
    return YES;
}

- (BOOL)unpackBody:(NSData *)data
{
    return YES;
}

- (void)addHeader:(NSString *)key value:(NSString *)value
{
    if ( nil == key || 0 == key.length )
        return;
    
    if ( value && value.length )
    {
        [self.headers setObject:value forKey:key];
    }
    else
    {
        [self.headers removeObjectForKey:key];
    }
}

- (void)addHeaders:(NSDictionary *)dict
{
    if ( nil == dict || 0 == dict.count )
        return;
    
    [self.headers addEntriesFromDictionary:dict];
}

- (void)removeHeader:(NSString *)key
{
    if ( nil == key )
        return;
    
    [self.headers removeObjectForKey:key];
}

@end
