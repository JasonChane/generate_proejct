//
//  Lion_Log.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Log.h"
#import "Lion_SystemInfo.h"
#import "Lion_UnitTest.h"
#import "NSArray+LionExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionLogger, logger );

#pragma mark -

#undef	MAX_BACKLOG
#define MAX_BACKLOG	(50)

#pragma mark -

@implementation LionBacklog

@synthesize module = _module;
@synthesize level = _level;
@dynamic levelString;
@synthesize file = _file;
@synthesize line = _line;
@synthesize func = _func;
@synthesize time = _time;
@synthesize text = _text;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.level = LionLogLevelNone;
        self.time = [NSDate date];
    }
    return self;
}

- (void)dealloc
{
    self.module = nil;
    self.file = nil;
    self.func = nil;
    self.time = nil;
    self.text = nil;
    
    [super dealloc];
}

- (NSString *)levelString
{
    if ( LionLogLevelInfo == self.level )
    {
        return @"INFO";
    }
    else if ( LionLogLevelPerf == self.level )
    {
        return @"PERF";
    }
    else if ( LionLogLevelWarn == self.level )
    {
        return @"WARN";
    }
    else if ( LionLogLevelError == self.level )
    {
        return @"ERROR";
    }
    
    return @"SYSTEM";
}

@end

#pragma mark -

@interface LionLogger()
{
    BOOL				_showLevel;
    BOOL				_showModule;
    
    BOOL				_enabled;
    NSMutableArray *	_backlogs;
    NSUInteger			_indentTabs;
}

- (void)printLogo;

@end

#pragma mark -

@implementation LionLogger

DEF_SINGLETON( LionLogger );

@synthesize showLevel = _showLevel;
@synthesize showModule = _showModule;

@synthesize enabled = _enabled;
@synthesize backlogs = _backlogs;
@synthesize indentTabs = _indentTabs;

+ (BOOL)autoLoad
{
    [[LionLogger sharedInstance] printLogo];
    
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
#if __Lion_DEVELOPMENT__
        self.showLevel = YES;
        self.showModule = NO;
#else	// #if __Lion_DEVELOPMENT__
        self.showLevel = YES;
        self.showModule = NO;
#endif	// #if __Lion_DEVELOPMENT__
        
        self.enabled = YES;
        self.backlogs = [NSMutableArray array];
        self.indentTabs = 0;
    }
    return self;
}

- (void)dealloc
{
    self.backlogs = nil;
    
    [super dealloc];
}

- (void)printLogo
{
#if TARGET_OS_IPHONE
    NSString * homePath;
    homePath = [NSBundle mainBundle].bundlePath;
    homePath = [homePath stringByReplacingOccurrencesOfString:@" " withString:@"\\ "];
    
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "    	 ______    ______    ______					\n" );
    fprintf( stderr, "    	/\\  __ \\  /\\  ___\\  /\\  ___\\			\n" );
    fprintf( stderr, "    	\\ \\  __<  \\ \\  __\\_ \\ \\  __\\_		\n" );
    fprintf( stderr, "    	 \\ \\_____\\ \\ \\_____\\ \\ \\_____\\		\n" );
    fprintf( stderr, "    	  \\/_____/  \\/_____/  \\/_____/			\n" );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "    	version %s									\n", [Lion_VERSION UTF8String] );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "%s	\n", [LionSystemInfo OSVersion].UTF8String );
    fprintf( stderr, "%s	\n", [LionSystemInfo deviceModel].UTF8String );
    fprintf( stderr, "    												\n" );
    fprintf( stderr, "UUID: %s	\n", [LionSystemInfo deviceUUID].UTF8String );
    fprintf( stderr, "Home: %s	\n", homePath.UTF8String );
    fprintf( stderr, "    												\n" );
#endif	// #if TARGET_OS_IPHONE
}

- (void)toggle
{
    _enabled = _enabled ? NO : YES;
}

- (void)enable
{
    _enabled = YES;
}

- (void)disable
{
    _enabled = NO;
}

- (void)indent
{
    _indentTabs += 1;
}

- (void)indent:(NSUInteger)tabs
{
    _indentTabs += tabs;
}

- (void)unindent
{
    if ( _indentTabs > 0 )
    {
        _indentTabs -= 1;
    }
}

- (void)unindent:(NSUInteger)tabs
{
    if ( _indentTabs < tabs )
    {
        _indentTabs = 0;
    }
    else
    {
        _indentTabs -= tabs;
    }
}

#if __Lion_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(LionLogLevel)level format:(NSString *)format, ...
#else	// #if __Lion_DEVELOPMENT__
- (void)level:(LionLogLevel)level format:(NSString *)format, ...
#endif	// #if __Lion_DEVELOPMENT__
{
#if (__ON__ == __Lion_LOG__)
    
    if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
        return;
    
    va_list args;
    va_start( args, format );
    
#if __Lion_DEVELOPMENT__
    [self file:file line:line function:function level:level format:format args:args];
#else	// #if __Lion_DEVELOPMENT__
    [self level:level format:format args:args];
#endif	// #if __Lion_DEVELOPMENT__
    
    va_end( args );
    
#endif	// #if (__ON__ == __Lion_LOG__)
}

#if __Lion_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(LionLogLevel)level format:(NSString *)format args:(va_list)args
#else	// #if __Lion_DEVELOPMENT__
- (void)level:(LionLogLevel)level format:(NSString *)format args:(va_list)args
#endif	// #if __Lion_DEVELOPMENT__
{
#if (__ON__ == __Lion_LOG__)
    
    if ( NO == _enabled )
        return;
    
    // formatting
    
    NSMutableString * text = [NSMutableString string];
    NSMutableString * tabs = nil;
    
    if ( _indentTabs > 0 )
    {
        tabs = [NSMutableString string];
        
        for ( int i = 0; i < _indentTabs; ++i )
        {
            [tabs appendString:@"\t"];
        }
    }
    
    NSString * module = nil;
    
#if __Lion_DEVELOPMENT__
    module = [[file lastPathComponent] stringByDeletingPathExtension];
    if ( [module hasPrefix:@"Lion_"] )
    {
        module = [module substringFromIndex:@"Lion_".length];
    }
#endif	// #if __Lion_DEVELOPMENT__
    
    if ( self.showLevel || self.showModule )
    {
        NSMutableString * temp = [NSMutableString string];
        
        if ( self.showLevel )
        {
            if ( LionLogLevelInfo == level )
            {
                [temp appendString:@"[INFO]"];
            }
            else if ( LionLogLevelPerf == level )
            {
                [temp appendString:@"[PERF]"];
            }
            else if ( LionLogLevelWarn == level )
            {
                [temp appendString:@"[WARN]"];
            }
            else if ( LionLogLevelError == level )
            {
                [temp appendString:@"[ERROR]"];
            }
        }
        
        if ( self.showModule )
        {
            if ( module && module.length )
            {
                [temp appendFormat:@" [%@]", module];
            }
        }
        
        if ( temp.length )
        {
            NSString * temp2 = [temp stringByPaddingToLength:((temp.length / 8) + 1) * 8 withString:@" " startingAtIndex:0];
            [text appendString:temp2];
        }
    }
    
    if ( tabs && tabs.length )
    {
        [text appendString:tabs];
    }
    
    //#if __Lion_DEVELOPMENT__
    //	if ( file )
    //	{
    //		[text appendFormat:@"%@(#%d) ", [file lastPathComponent], line];
    //	}
    //#endif	// #if __Lion_DEVELOPMENT__
    
    NSString * content = [[[NSString alloc] initWithFormat:(NSString *)format arguments:args] autorelease];
    if ( content && content.length )
    {
        [text appendString:content];
    }
    
    if ( [text rangeOfString:@"\n"].length )
    {
        [text replaceOccurrencesOfString:@"\n"
                              withString:[NSString stringWithFormat:@"\n%@", tabs ? tabs : @"\t\t"]
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange( 0, text.length )];
    }
    
    if ( [text rangeOfString:@"%"].length )
    {
        [text replaceOccurrencesOfString:@"%"
                              withString:@"%%"
                                 options:NSCaseInsensitiveSearch
                                   range:NSMakeRange( 0, text.length )];
    }
    
    // print to console
    
    fprintf( stderr, [text UTF8String], NULL );
    fprintf( stderr, "\n", NULL );
    
    // back log
    
#if __Lion_DEVELOPMENT__
    if ( LionLogLevelError == level || LionLogLevelWarn == level )
    {
        LionBacklog * log = [[[LionBacklog alloc] init] autorelease];
        if ( log )
        {
            log.level = level;
            log.text = text;
            log.module = module;
            log.file = file;
            log.line = line;
            log.func = function;
            
            [_backlogs pushTail:log];
            [_backlogs keepTail:MAX_BACKLOG];
        }
    }
#endif	// #if __Lion_DEVELOPMENT__
#endif	// #if (__ON__ == __Lion_LOG__)
}

@end

#if __cplusplus
extern "C"
#endif	// #if __cplusplus
void LionLog( NSString * format, ... )
{
#if (__ON__ == __Lion_LOG__)
    
    if ( nil == format || NO == [format isKindOfClass:[NSString class]] )
        return;
    
    va_list args;
    va_start( args, format );
    
#if __Lion_DEVELOPMENT__
    [[LionLogger sharedInstance] file:nil line:0 function:nil level:LionLogLevelInfo format:format args:args];
#else	// #if __Lion_DEVELOPMENT__
    [[LionLogger sharedInstance] level:LionLogLevelInfo format:format args:args];
#endif	// #if __Lion_DEVELOPMENT__
    
    va_end( args );
    
#endif	// #if (__ON__ == __Lion_LOG__)
}

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionLog )
{
    TIMES( 3 )
    {
        HERE( "output log", {
            CC( nil );
            CC( @"" );
            CC( @"format %@", @"" );
        });
        
        HERE( "test info", {
            INFO( nil );
            INFO( nil, nil );
            INFO( nil, @"" );
            INFO( nil, @"format %@", @"" );
            
            INFO( @"a", nil );
            INFO( @"a", @"" );
            INFO( @"a", @"format %@", @"" );
        });
        
        HERE( "test warn", {
            WARN( nil );
            WARN( nil, nil );
            WARN( nil, @"" );
            WARN( nil, @"format %@", @"" );
            
            WARN( @"a", nil );
            WARN( @"a", @"" );
            WARN( @"a", @"format %@", @"" );
        });
        
        HERE( "test error", {
            ERROR( nil );
            ERROR( nil, nil );
            ERROR( nil, @"" );
            ERROR( nil, @"format %@", @"" );
            
            ERROR( @"a", nil );
            ERROR( @"a", @"" );
            ERROR( @"a", @"format %@", @"" );
        });
    }
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
