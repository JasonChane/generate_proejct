//
//  Lion_HTTPServerRouter2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPServerRouter2.h"
#import "Lion_HTTPUtility2.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionHTTPServer2, LionHTTPServerRouter2, urls );
DEF_PACKAGE( LionHTTPServer2, LionHTTPServerRouter2, router );

#pragma mark -

@interface LionHTTPServerRouter2()
{
    NSMutableDictionary *		_routes;
    LionHTTPServerRouter2Block	_index;
}
@end

#pragma mark -

@implementation LionHTTPServerRouter2

DEF_SINGLETON( LionHTTPServerRouter2 )

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
        self.index = ^
        {
            line( @"<html>" );
            line( @"<body>" );
            line( @"<pre>" );
            line( @"It works!" );
            line( @"\n" );
            line( @"	 ______    ______    ______" );
            line( @"	/\\  __ \\  /\\  ___\\  /\\  ___\\" );
            line( @"	\\ \\  __<  \\ \\  __\\_ \\ \\  __\\_" );
            line( @"	 \\ \\_____\\ \\ \\_____\\ \\ \\_____\\" );
            line( @"	  \\/_____/  \\/_____/  \\/_____/" );
            line( @"\n" );
            line( @"	Copyright (c) 2014-2015, Geek Zoo Studio" );
            line( @"	http://www.Lion-framework.com" );
            line( @"</pre>" );
            line( @"</body>" );
            line( @"</html>" );
        };
        
        self[@"404"] = ^
        {
            line( @"<html>" );
            line( @"<body>" );
            line( @"<pre>" );
            line( @"404 not found" );
            line( @"</pre>" );
            line( @"</body>" );
            line( @"</html>" );
        };
        
        self[@"500"] = ^
        {
            line( @"<html>" );
            line( @"<body>" );
            line( @"<pre>" );
            line( @"500 internal error" );
            line( @"</pre>" );
            line( @"</body>" );
            line( @"</html>" );
        };
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

- (void)indexAction:(LionHTTPServerRouter2Block)block
{
    self.index = block;
}

- (void)otherAction:(LionHTTPServerRouter2Block)block url:(NSString *)url;
{
    [self.routes setObject:[[block copy] autorelease] forKey:url];
}

- (void)error404Action:(LionHTTPServerRouter2Block)block
{
    [self.routes setObject:[[block copy] autorelease] forKey:@"404"];
}

- (void)error500Action:(LionHTTPServerRouter2Block)block
{
    [self.routes setObject:[[block copy] autorelease] forKey:@"500"];
}

- (BOOL)routes:(NSString *)url
{
    NSString * path = nil;
    
    if ( nil == url || 0 == url.length )
        return NO;
    
    if ( [url hasPrefix:@"http://"] || [url hasPrefix:@"https://"] )
    {
        NSURL * url2 = [NSURL URLWithString:url];
        if ( nil == url2 )
            return NO;
        
        path = url2.path;
    }
    else
    {
        path = url;
    }
    
    LionHTTPServerRouter2Block block = [self.routes objectForKey:path];
    LionHTTPServerRouter2Block defaultBlock = self.index;
    
    if ( block )
    {
        block();
        return YES;
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
            return YES;
        }
    }
    //	else
    //	{
    //		if ( defaultBlock )
    //		{
    //			defaultBlock();
    //			return YES;
    //		}
    //	}
    
    return NO;
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

