//
//  Lion_Sandbox.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Sandbox.h"
#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionSandbox, sandbox );

#pragma mark -

@interface LionSandbox()
{
    NSString *	_appPath;
    NSString *	_docPath;
    NSString *	_libPrefPath;
    NSString *	_libCachePath;
    NSString *	_tmpPath;
}

- (BOOL)remove:(NSString *)path;
- (BOOL)touch:(NSString *)path;
- (BOOL)touchFile:(NSString *)path;

@end

#pragma mark -

@implementation LionSandbox

DEF_SINGLETON( LionSandbox )

@dynamic appPath;
@dynamic docPath;
@dynamic libPrefPath;
@dynamic libCachePath;
@dynamic tmpPath;

+ (NSString *)appPath
{
    return [[LionSandbox sharedInstance] appPath];
}

- (NSString *)appPath
{
    if ( nil == _appPath )
    {
        NSString * exeName = [[NSBundle mainBundle] infoDictionary][@"CFBundleExecutable"];
        NSString * appPath = [[NSHomeDirectory() stringByAppendingPathComponent:exeName] stringByAppendingPathExtension:@"app"];
        
        _appPath = [appPath retain];
    }
    
    return _appPath;
}

+ (NSString *)docPath
{
    return [[LionSandbox sharedInstance] docPath];
}

- (NSString *)docPath
{
    if ( nil == _docPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _docPath = [[paths objectAtIndex:0] retain];
    }
    
    return _docPath;
}

+ (NSString *)libPrefPath
{
    return [[LionSandbox sharedInstance] libPrefPath];
}

- (NSString *)libPrefPath
{
    if ( nil == _libPrefPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
        
        [self touch:path];
        
        _libPrefPath = [path retain];
    }
    
    return _libPrefPath;
}

+ (NSString *)libCachePath
{
    return [[LionSandbox sharedInstance] libCachePath];
}

- (NSString *)libCachePath
{
    if ( nil == _libCachePath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
        
        [self touch:path];
        
        _libCachePath = [path retain];
    }
    
    return _libCachePath;
}

+ (NSString *)tmpPath
{
    return [[LionSandbox sharedInstance] tmpPath];
}

- (NSString *)tmpPath
{
    if ( nil == _tmpPath )
    {
        NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
        NSString * path = [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
        
        [self touch:path];
        
        _tmpPath = [path retain];
    }
    
    return _tmpPath;
}

+ (BOOL)remove:(NSString *)path
{
    return [[LionSandbox sharedInstance] remove:path];
}

- (BOOL)remove:(NSString *)path
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
}

+ (BOOL)touch:(NSString *)path
{
    return [[LionSandbox sharedInstance] touch:path];
}

- (BOOL)touch:(NSString *)path
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
    {
        return [[NSFileManager defaultManager] createDirectoryAtPath:path
                                         withIntermediateDirectories:YES
                                                          attributes:nil
                                                               error:NULL];
    }
    
    return YES;
}

+ (BOOL)touchFile:(NSString *)file
{
    return [[LionSandbox sharedInstance] touchFile:file];
}

- (BOOL)touchFile:(NSString *)file
{
    if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:file] )
    {
        return [[NSFileManager defaultManager] createFileAtPath:file
                                                       contents:[NSData data]
                                                     attributes:nil];
    }
    
    return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionSandbox )
{
    TIMES( 3 )
    {
        EXPECTED( nil != [LionSandbox appPath] );
        EXPECTED( nil != [LionSandbox docPath] );
        EXPECTED( nil != [LionSandbox libPrefPath] );
        EXPECTED( nil != [LionSandbox libCachePath] );
        EXPECTED( nil != [LionSandbox tmpPath] );
    }
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
