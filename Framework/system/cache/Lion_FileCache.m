//
//  Lion_FileCache.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_FileCache.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionFileCache, fileCache );

#pragma mark -

@interface LionFileCache()
{
    NSString *		_cachePath;
    NSString *		_cacheUser;
    NSFileManager *	_fileManager;
}
@end

#pragma mark -

@implementation LionFileCache

@synthesize cachePath = _cachePath;
@synthesize cacheUser = _cacheUser;

DEF_SINGLETON( LionFileCache );

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.cacheUser = @"";
        self.cachePath = [NSString stringWithFormat:@"%@/%@/Cache/", [LionSandbox libCachePath], [LionSystemInfo appVersion]];
        
        _fileManager = [[NSFileManager alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    [_fileManager release];
    _fileManager = nil;
    
    self.cachePath = nil;
    self.cacheUser = nil;
    
    [super dealloc];
}

- (NSString *)fileNameForKey:(NSString *)key
{
    NSString * pathName = nil;
    
    if ( self.cacheUser && [self.cacheUser length] )
    {
        pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
    }
    else
    {
        pathName = self.cachePath;
    }
    
    if ( NO == [_fileManager fileExistsAtPath:pathName] )
    {
        [_fileManager createDirectoryAtPath:pathName
                withIntermediateDirectories:YES
                                 attributes:nil
                                      error:NULL];
    }
    
    return [pathName stringByAppendingString:key];
}

- (BOOL)hasObjectForKey:(id)key
{
    return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
    return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key
{
    if ( nil == object )
    {
        [self removeObjectForKey:key];
    }
    else
    {
        NSData * data = [object asNSData];
        if ( data )
        {
            [data writeToFile:[self fileNameForKey:key]
                      options:NSDataWritingAtomic
                        error:NULL];
        }
    }
}

- (void)removeObjectForKey:(NSString *)key
{
    [_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
    [_fileManager removeItemAtPath:_cachePath error:NULL];
    [_fileManager createDirectoryAtPath:_cachePath
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:NULL];
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    [self setObject:obj forKey:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionFileCache )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

