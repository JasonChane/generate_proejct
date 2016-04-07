//
//  Lion_CLI.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_CLI.h"

#if (TARGET_OS_MAC)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage, LionCLI, cli );

#pragma mark -

@interface LionCLI()
{
    NSString *			_color;
    BOOL				_autoChangeBack;
    
    NSString *			_workingDirectory;
    NSString *			_execPath;
    NSString *			_execName;
    NSMutableArray *	_arguments;
}
@end

#pragma mark -

@implementation LionCLI

DEF_SINGLETON( LionCLI );

@dynamic ECHO;
@dynamic LINE;

@dynamic NO_COLOR;

@dynamic RED;
@dynamic BLUE;
@dynamic CYAN;
@dynamic GREEN;
@dynamic YELLOW;

@dynamic LIGHT_RED;
@dynamic LIGHT_BLUE;
@dynamic LIGHT_CYAN;
@dynamic LIGHT_GREEN;
@dynamic LIGHT_YELLOW;

@synthesize color = _color;
@synthesize autoChangeBack = _autoChangeBack;

@synthesize workingDirectory = _workingDirectory;
@synthesize execPath = _execPath;
@synthesize execName = _execName;
@synthesize arguments = _arguments;

+ (BOOL)autoLoad
{
    [LionCLI sharedInstance];
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        char	buff[256] = { 0 };
        char *	result = getcwd( buff, 256 - 1 );
        
        if ( result )
        {
            self.workingDirectory = [NSString stringWithUTF8String:buff];
        }
        
        self.arguments = [NSMutableArray array];
        self.autoChangeBack = YES;
    }
    return self;
}

- (void)dealloc
{
    self.workingDirectory = nil;
    self.execPath = nil;
    self.execName = nil;
    self.arguments = nil;
    
    self.color = nil;
    
    [super dealloc];
}

- (LionCLIBlockN)ECHO
{
    LionCLIBlockN block = ^ LionCLI * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        if ( first && [first isKindOfClass:[NSString class]] )
        {
#if (TARGET_OS_MAC)
            if ( self.color )
            {
                fprintf( stderr, "%s", [self.color UTF8String] );
            }
#endif	// #if (TARGET_OS_MAC)
            
            NSString * text = [[NSString alloc] initWithFormat:(NSString *)first arguments:args];
            fprintf( stderr, "%s", [text UTF8String] );
            [text release];
        }
        
#if (TARGET_OS_MAC)
        if ( self.color )
        {
            if ( self.autoChangeBack )
            {
                fprintf( stderr, "\e[0m" );
            }
        }
#endif	// #if (TARGET_OS_MAC)
        
        va_end( args );
        
        if ( self.autoChangeBack )
        {
            self.color = nil;
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlockN)LINE
{
    LionCLIBlockN block = ^ LionCLI * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        if ( first && [first isKindOfClass:[NSString class]] )
        {
#if (TARGET_OS_MAC)
            if ( self.color )
            {
                fprintf( stderr, "%s", [self.color UTF8String] );
            }
#endif	// #if (TARGET_OS_MAC)
            
            NSString * text = [[NSString alloc] initWithFormat:(NSString *)first arguments:args];
            fprintf( stderr, "%s", [text UTF8String] );
            [text release];
        }
        
#if (TARGET_OS_MAC)
        if ( self.color )
        {
            if ( self.autoChangeBack )
            {
                fprintf( stderr, "\e[0m" );
            }
        }
#endif	// #if (TARGET_OS_MAC)
        
        va_end( args );
        
        if ( self.autoChangeBack )
        {
            self.color = nil;
        }
        
        fprintf( stderr, "\n" );
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)NO_COLOR
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)RED
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0;31m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)BLUE
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0;34m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)CYAN
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0;36m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)GREEN
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0;32m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)YELLOW
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[0;33m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)LIGHT_RED
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[1;31m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)LIGHT_BLUE
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[1;34m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)LIGHT_CYAN
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[1;36m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)LIGHT_GREEN
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[1;32m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionCLIBlock)LIGHT_YELLOW
{
    LionCLIBlock block = ^ LionCLI * ( void )
    {
        self.color = @"\e[1;33m";
        return self;
    };
    
    return [[block copy] autorelease];
}

- (void)argc:(int)argc argv:(const char * [])argv//获取schema参数
{
    if ( 0 == argc )
        return;
    
    NSString * exec = [NSString stringWithUTF8String:argv[0]];
    
    self.execPath = [exec stringByDeletingLastPathComponent];
    self.execName = [exec lastPathComponent];
    self.arguments = [NSMutableArray array];
    
    for ( NSUInteger i = 1; i < argc; ++i )
    {
        NSString * arg = [NSString stringWithUTF8String:argv[i]];
        
        [_arguments addObject:arg];
    }
}

- (NSString *)pathArgumentAtIndex:(NSUInteger)index//获取json路径
{
    if ( index >= self.arguments.count )
        return nil;
    
    NSString * currentPath = self.workingDirectory;
    NSString * fullPath = [self.arguments objectAtIndex:index];
    
    if ( NO == [currentPath hasSuffix:@"/"] )
    {
        currentPath = [currentPath stringByAppendingString:@"/"];
    }
    
    if ( NSNotFound == [fullPath rangeOfString:@"/"].location )
    {
        fullPath = [NSString stringWithFormat:@"./%@", fullPath];
    }
    
    NSString * resultFile = [fullPath lastPathComponent].trim.unwrap;
    NSString * resultPath = fullPath;
    
    resultPath = [resultPath stringByReplacingOccurrencesOfString:resultFile withString:@""];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"~" withString:NSHomeDirectory()];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"./" withString:currentPath];
    resultPath = [resultPath stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
    resultPath = resultPath.trim.unwrap;
    
    return resultPath;
}

- (NSString *)fileArgumentAtIndex:(NSUInteger)index
{
    if ( index >= self.arguments.count )
        return nil;
    
    NSString * fullPath = [self.arguments objectAtIndex:index];
    NSString * resultPath = [self pathArgumentAtIndex:index];
    NSString * resultFile = [fullPath lastPathComponent].trim.unwrap;
    
    return [resultPath stringByAppendingString:resultFile];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionCLI )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

#endif	// #if (TARGET_OS_MAC)
