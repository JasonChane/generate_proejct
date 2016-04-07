//
//  Lion_MemoryCache.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_MemoryCache.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionMemoryCache, memoryCache );

#pragma mark -

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

#pragma mark -

@interface LionMemoryCache()
{
    BOOL					_clearWhenMemoryLow;
    NSUInteger				_maxCacheCount;
    NSUInteger				_cachedCount;
    NSMutableArray *		_cacheKeys;
    NSMutableDictionary *	_cacheObjs;
}
@end

#pragma mark -

@implementation LionMemoryCache

@synthesize clearWhenMemoryLow = _clearWhenMemoryLow;
@synthesize maxCacheCount = _maxCacheCount;
@synthesize cachedCount = _cachedCount;
@synthesize cacheKeys = _cacheKeys;
@synthesize cacheObjs = _cacheObjs;

DEF_SINGLETON( LionMemoryCache );

- (id)init
{
    self = [super init];
    if ( self )
    {
        _clearWhenMemoryLow = YES;
        _maxCacheCount = DEFAULT_MAX_COUNT;
        _cachedCount = 0;
        
        _cacheKeys = [[NSMutableArray alloc] init];
        _cacheObjs = [[NSMutableDictionary alloc] init];
        
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        [self observeNotification:UIApplicationDidReceiveMemoryWarningNotification];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    }
    
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [_cacheObjs removeAllObjects];
    [_cacheObjs release];
    
    [_cacheKeys removeAllObjects];
    [_cacheKeys release];
    
    [super dealloc];
}

- (BOOL)hasObjectForKey:(id)key
{
    return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (id)objectForKey:(id)key
{
    return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
    if ( nil == key )
        return;
    
    if ( nil == object )
        return;
    
    id cachedObj = [_cacheObjs objectForKey:key];
    if ( cachedObj == object )
        return;
    
    _cachedCount += 1;
    
    if ( _maxCacheCount > 0 )
    {
        while ( _cachedCount >= _maxCacheCount )
        {
            NSString * tempKey = [_cacheKeys safeObjectAtIndex:0];
            if ( tempKey )
            {
                [_cacheObjs removeObjectForKey:tempKey];
                [_cacheKeys removeObjectAtIndex:0];
            }
            
            _cachedCount -= 1;
        }
    }
    
    [_cacheKeys addObject:key];
    [_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( [_cacheObjs objectForKey:key] )
    {
        [_cacheKeys removeObjectIdenticalTo:key];
        [_cacheObjs removeObjectForKey:key];
        
        _cachedCount -= 1;
    }
}

- (void)removeAllObjects
{
    [_cacheKeys removeAllObjects];
    [_cacheObjs removeAllObjects];
    
    _cachedCount = 0;
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ( [notification is:UIApplicationDidReceiveMemoryWarningNotification] )
    {
        if ( _clearWhenMemoryLow )
        {
            [self removeAllObjects];
        }
    }
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionMemoryCache )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
