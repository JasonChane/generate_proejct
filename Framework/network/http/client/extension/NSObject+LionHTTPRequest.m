//
//  NSObject+LionHTTPRequest.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionHTTPRequest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionHTTPRequestResponder)

@dynamic REQUESTING;
@dynamic REQUESTING_URL;
@dynamic CANCEL_REQUESTS;

@dynamic GET;
@dynamic PUT;
@dynamic POST;
@dynamic DELETE;

@dynamic HTTP_GET;
@dynamic HTTP_PUT;
@dynamic HTTP_POST;
@dynamic HTTP_DELETE;

#pragma mark -

- (LionHTTPRequest *)GET:(NSString *)url
{
    return [self HTTP_GET:url];
}

- (LionHTTPRequest *)PUT:(NSString *)url
{
    return [self HTTP_PUT:url];
}

- (LionHTTPRequest *)POST:(NSString *)url
{
    return [self HTTP_POST:url];
}

- (LionHTTPRequest *)DELETE:(NSString *)url
{
    return [self HTTP_DELETE:url];
}

- (LionHTTPRequest *)HTTP_GET:(NSString *)url
{
    LionHTTPRequest * req = [LionHTTPRequestQueue GET:url];
    [req addResponder:self];
    return req;
}

- (LionHTTPRequest *)HTTP_PUT:(NSString *)url
{
    LionHTTPRequest * req = [LionHTTPRequestQueue PUT:url];
    [req addResponder:self];
    return req;
}

- (LionHTTPRequest *)HTTP_POST:(NSString *)url
{
    LionHTTPRequest * req = [LionHTTPRequestQueue POST:url];
    [req addResponder:self];
    return req;
}

- (LionHTTPRequest *)HTTP_DELETE:(NSString *)url
{
    LionHTTPRequest * req = [LionHTTPRequestQueue DELETE:url];
    [req addResponder:self];
    return req;
}

#pragma mark -

- (LionHTTPBoolBlockV)REQUESTING
{
    LionHTTPBoolBlockV block = ^ BOOL ( void )
    {
        return [self requestingURL:nil];
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPBoolBlockS)REQUESTING_URL
{
    LionHTTPBoolBlockS block = ^ BOOL ( NSString * url )
    {
        return [self requestingURL:url];
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPBoolBlockV)CANCEL_REQUESTS
{
    LionHTTPBoolBlockV block = ^ BOOL ( void )
    {
        [self cancelRequests];
        return YES;
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPRequestBlockSN)GET
{
    LionHTTPRequestBlockSN block = ^ LionHTTPRequest * ( NSString * url, ... )
    {
        va_list args;
        va_start( args, url );
        
        url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
        
        va_end( args );
        
        LionHTTPRequest * req = [LionHTTPRequestQueue GET:url];
        [req addResponder:self];
        return req;
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPRequestBlockSN)PUT
{
    LionHTTPRequestBlockSN block = ^ LionHTTPRequest * ( NSString * url, ... )
    {
        va_list args;
        va_start( args, url );
        
        url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
        
        va_end( args );
        
        LionHTTPRequest * req = [LionHTTPRequestQueue PUT:url];
        [req addResponder:self];
        return req;
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPRequestBlockSN)POST
{
    LionHTTPRequestBlockSN block = ^ LionHTTPRequest * ( NSString * url, ... )
    {
        va_list args;
        va_start( args, url );
        
        url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
        
        va_end( args );
        
        LionHTTPRequest * req = [LionHTTPRequestQueue POST:url];
        [req addResponder:self];
        return req;
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPRequestBlockSN)DELETE
{
    LionHTTPRequestBlockSN block = ^ LionHTTPRequest * ( NSString * url, ... )
    {
        va_list args;
        va_start( args, url );
        
        url = [[[NSString alloc] initWithFormat:url arguments:args] autorelease];
        
        va_end( args );
        
        LionHTTPRequest * req = [LionHTTPRequestQueue DELETE:url];
        [req addResponder:self];
        return req;
    };
    
    return [[block copy] autorelease];
}

- (LionHTTPRequestBlockSN)HTTP_GET
{
    return [self GET];
}

- (LionHTTPRequestBlockSN)HTTP_PUT
{
    return [self PUT];
}

- (LionHTTPRequestBlockSN)HTTP_POST
{
    return [self POST];
}

- (LionHTTPRequestBlockSN)HTTP_DELETE
{
    return [self DELETE];
}

- (BOOL)requestingURL
{
    if ( [self isRequestResponder] )
    {
        return [LionHTTPRequestQueue requesting:nil byResponder:self];
    }
    else
    {
        return NO;
    }
}

- (BOOL)requestingURL:(NSString *)url
{
    if ( [self isRequestResponder] )
    {
        return [LionHTTPRequestQueue requesting:url byResponder:self];
    }
    else
    {
        return NO;
    }
}

- (LionHTTPRequest *)request
{
    NSArray * array = [LionHTTPRequestQueue requests:nil byResponder:self];
    return [array safeObjectAtIndex:0];
}

- (NSArray *)requests
{
    return [LionHTTPRequestQueue requests:nil byResponder:self];
}

- (NSArray *)requests:(NSString *)url
{
    return [LionHTTPRequestQueue requests:url byResponder:self];
}

- (void)cancelRequests
{
    if ( [self isRequestResponder] )
    {
        [LionHTTPRequestQueue cancelRequestByResponder:self];
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionHTTPRequest )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
