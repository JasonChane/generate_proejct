//
//  Lion_Log.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Package.h"
#import "Lion_Singleton.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionLogger, logger );

#pragma mark -

typedef enum
{
    LionLogLevelNone		= 0,
    LionLogLevelInfo		= 100,
    LionLogLevelPerf		= 200,
    LionLogLevelWarn		= 300,
    LionLogLevelError	= 400
} LionLogLevel;

#pragma mark -

#if __Lion_LOG__

#if __Lion_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[LionLogger sharedInstance] file:@(__FILE__) line:__LINE__ function:@(__PRETTY_FUNCTION__) level:LionLogLevelNone format:__VA_ARGS__];

#else	// #if __Lion_DEVELOPMENT__

#undef	CC
#define CC( ... )		[[LionLogger sharedInstance] level:LionLogLevelNone format:__VA_ARGS__];

#undef	INFO
#define INFO( ... )		[[LionLogger sharedInstance] level:LionLogLevelInfo format:__VA_ARGS__];

#undef	PERF
#define PERF( ... )		[[LionLogger sharedInstance] level:LionLogLevelPerf format:__VA_ARGS__];

#undef	WARN
#define WARN( ... )		[[LionLogger sharedInstance] level:LionLogLevelWarn format:__VA_ARGS__];

#undef	ERROR
#define ERROR( ... )	[[LionLogger sharedInstance] level:LionLogLevelError format:__VA_ARGS__];

#undef	PRINT
#define PRINT( ... )	[[LionLogger sharedInstance] level:LionLogLevelNone format:__VA_ARGS__];

#endif	// #if __Lion_DEVELOPMENT__

#undef	VAR_DUMP
#define VAR_DUMP( __obj )	PRINT( [__obj description] );

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )	PRINT( [__obj objectToDictionary] );

#else	// #if __Lion_LOG__

#undef	CC
#define CC( ... )

#undef	INFO
#define INFO( ... )

#undef	PERF
#define PERF( ... )

#undef	WARN
#define WARN( ... )

#undef	ERROR
#define ERROR( ... )

#undef	PRINT
#define PRINT( ... )

#undef	VAR_DUMP
#define VAR_DUMP( __obj )

#undef	OBJ_DUMP
#define OBJ_DUMP( __obj )

#endif	// #if __Lion_LOG__

#undef	TODO
#define TODO( desc, ... )

#pragma mark -

@interface LionBacklog : NSObject
@property (nonatomic, retain) NSString *		module;
@property (nonatomic, assign) LionLogLevel		level;
@property (nonatomic, readonly) NSString *		levelString;
@property (nonatomic, retain) NSString *		file;
@property (nonatomic, assign) NSUInteger		line;
@property (nonatomic, retain) NSString *		func;
@property (nonatomic, retain) NSDate *			time;
@property (nonatomic, retain) NSString *		text;
@end

#pragma mark -

@interface LionLogger : NSObject

AS_SINGLETON( LionLogger );

@property (nonatomic, assign) BOOL				showLevel;
@property (nonatomic, assign) BOOL				showModule;
@property (nonatomic, assign) BOOL				enabled;
@property (nonatomic, retain) NSMutableArray *	backlogs;
@property (nonatomic, assign) NSUInteger		indentTabs;

- (void)toggle;
- (void)enable;
- (void)disable;

- (void)indent;
- (void)indent:(NSUInteger)tabs;
- (void)unindent;
- (void)unindent:(NSUInteger)tabs;

#if __Lion_DEVELOPMENT__
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(LionLogLevel)level format:(NSString *)format, ...;
- (void)file:(NSString *)file line:(NSUInteger)line function:(NSString *)function level:(LionLogLevel)level format:(NSString *)format args:(va_list)args;
#else	// #if __Lion_DEVELOPMENT__
- (void)level:(LionLogLevel)level format:(NSString *)format, ...;
- (void)level:(LionLogLevel)level format:(NSString *)format args:(va_list)args;
#endif	// #if __Lion_DEVELOPMENT__

@end

#pragma mark -

#if __cplusplus
extern "C" {
#endif
    
    void LionLog( NSString * format, ... );
    
#if __cplusplus
};
#endif
