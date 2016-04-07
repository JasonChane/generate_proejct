//
//  Lion_Thread.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Thread.h"
#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage, LionThread, thread );
DEF_PACKAGE( LionPackage, LionThread, taskQueue );

#pragma mark -

@interface LionThread()
{
    dispatch_queue_t _foreQueue;
    dispatch_queue_t _backQueue;
}
@end

@implementation LionThread

DEF_SINGLETON( LionThread )

@dynamic MAIN;
@dynamic FORK;

- (id)init
{
    self = [super init];
    if ( self )
    {
        _foreQueue = dispatch_get_main_queue();
        _backQueue = dispatch_queue_create( "com.Lion.taskQueue", nil );
    }
    
    return self;
}

+ (dispatch_queue_t)foreQueue
{
    return [[LionThread sharedInstance] foreQueue];
}

- (dispatch_queue_t)foreQueue
{
    return _foreQueue;
}

+ (dispatch_queue_t)backQueue
{
    return [[LionThread sharedInstance] backQueue];
}

- (dispatch_queue_t)backQueue
{
    return _backQueue;
}

- (void)dealloc
{
    [super dealloc];
}

+ (void)enqueueForeground:(dispatch_block_t)block
{
    return [[LionThread sharedInstance] enqueueForeground:block];
}

- (void)enqueueForeground:(dispatch_block_t)block
{
    dispatch_async( _foreQueue, block );
}

+ (void)enqueueBackground:(dispatch_block_t)block
{
    return [[LionThread sharedInstance] enqueueBackground:block];
}

- (void)enqueueBackground:(dispatch_block_t)block
{
    dispatch_async( _backQueue, block );
}

+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    [[LionThread sharedInstance] enqueueForegroundWithDelay:ms block:block];
}

- (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
    dispatch_after( time, _foreQueue, block );
}

+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    [[LionThread sharedInstance] enqueueBackgroundWithDelay:ms block:block];
}

- (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block
{
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, ms * USEC_PER_SEC);
    dispatch_after( time, _backQueue, block );
}

- (LionThreadBlock)MAIN
{
    LionThreadBlock block = ^ LionThread * ( dispatch_block_t block )
    {
        [self enqueueForeground:block];
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionThreadBlock)FORK
{
    LionThreadBlock block = ^ LionThread * ( dispatch_block_t block )
    {
        [self enqueueBackground:block];
        return self;
    };
    
    return [[block copy] autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

#pragma mark -

TEST_CASE( LionThread )
{
    static int __flag = 0;
    
    HERE( "run in background", {
        
        BACKGROUND_BEGIN
        {
            EXPECTED( NO == [NSThread isMainThread] );
            EXPECTED( 0 == __flag );
            
            __flag = 1;
            
            FOREGROUND_BEGIN
            {
                EXPECTED( YES == [NSThread isMainThread] );
                EXPECTED( 1 == __flag );
                
                __flag = 0;
                
                BACKGROUND_BEGIN
                {
                    EXPECTED( NO == [NSThread isMainThread] );
                    EXPECTED( 0 == __flag );
                    
                    __flag = 1;
                    
                    FOREGROUND_BEGIN
                    {
                        EXPECTED( YES == [NSThread isMainThread] );
                        EXPECTED( 1 == __flag );
                        
                        __flag = 2;
                        
                        // done
                    }
                    FOREGROUND_COMMIT
                }
                BACKGROUND_COMMIT
            }
            FOREGROUND_COMMIT
        }
        BACKGROUND_COMMIT
    });
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
