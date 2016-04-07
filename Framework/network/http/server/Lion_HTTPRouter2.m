//
//  Lion_HTTPRouter2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPRouter2.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_HTTP, LionHTTPRouter2, router );

#pragma mark -

@interface LionHTTPRouter2()
{
    NSMutableDictionary *	_routes;
    LionHTTPRouter2Block		_index;
}
@end

#pragma mark -

@implementation LionHTTPRouter2

DEF_SINGLETON( LionHTTPRouter2 )

@synthesize routes = _routes;
@synthesize index = _index;

+ (void)load
{
    [self sharedInstance];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.routes = [[[NSMutableDictionary alloc] init] autorelease];
        self.index = nil;
    }
    return self;
}

- (void)dealloc
{
    [self.routes removeAllObjects];
    
    self.routes = nil;
    self.index = nil;
    
    [super dealloc];
}

- (void)index:(LionHTTPRouter2Block)block
{
    self.index = block;
}

- (void)route:(NSString *)url action:(LionHTTPRouter2Block)block
{
    [self.routes setObject:[block copy] forKey:url];
}

- (void)route:(NSString *)url
{
    NSString * path = nil;
    
    if ( nil == url || 0 == url.length )
        return;
    
    if ( [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] )
    {
        NSURL * url2 = [NSURL URLWithString:url];
        if ( nil == url2 )
            return;
        
        path = url2.path;
    }
    else
    {
        path = url;
    }
    
    LionHTTPRouter2Block block = [self.routes objectForKey:path];
    LionHTTPRouter2Block defaultBlock = self.index;
    
    if ( block )
    {
        block();
        return;
    }
    
    BOOL matched = NO;
    
    for ( NSString * rule in self.routes.allKeys )
    {
        if ( [rule isEqualToString:@"/"] )
        {
            defaultBlock = [self.routes objectForKey:rule];
        }
        
        if ( [rule isEqualToString:path] )
        {
            matched = YES;
        }
        else
        {
            NSMutableString * expr = [NSMutableString string];
            [expr appendString:@"^"];
            
            NSArray * segments = [rule componentsSeparatedByString:@"/"];
            for ( NSString * segment in segments )
            {
                if ( segment.length )
                {
                    if ( [segment hasPrefix:@":"] )
                    {
                        [expr appendString:@"([a-z0-9_]+)"];
                    }
                    else
                    {
                        NSString * formattedSegment = [segment stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
                        [expr appendString:formattedSegment];
                    }
                }
                
                if ( [segments lastObject] != segment )
                {
                    [expr appendString:@"/"];
                }
            }
            
            [expr appendString:@"$"];
            
            NSError * error = NULL;
            NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:expr options:NSRegularExpressionCaseInsensitive error:&error];
            NSTextCheckingResult * result = [regex firstMatchInString:path options:0 range:NSMakeRange(0, [path length])];
            
            matched = (result && (regex.numberOfCaptureGroups + 1) == result.numberOfRanges) ? YES : NO;
        }
        
        if ( matched )
        {
            block = [self.routes objectForKey:rule];
            break;
        }
    }
    
    if ( matched )
    {
        if ( block )
        {
            block();
        }
    }
    else
    {
        if ( defaultBlock )
        {
            defaultBlock();
        }
    }
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    if ( index >= self.routes.count )
        return self.index;
    
    return [self.routes objectForKey:[self.routes.allKeys objectAtIndex:index]];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
    ASSERT( 0 );
}

- (id)objectForKeyedSubscript:(id)key
{
    id block = [self.routes objectForKey:key];
    if ( block )
        return block;
    
    return self.index;
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if ( nil == obj || nil == key )
        return;
    
    [self.routes setObject:[[obj copy] autorelease] forKey:key];
}

@end
