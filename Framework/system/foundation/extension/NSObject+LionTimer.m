//
//  NSObject+LionTimer.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionTimer.h"

#import "Lion_UnitTest.h"
#import "NSDictionary+LionExtension.h"
#import "NSTimer+LionExtension.h"
#import "NSArray+LionExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface TimerAgent : NSObject
{
    NSMutableArray * _timers;
}

@property (nonatomic, retain) NSMutableArray * timers;

@end

#pragma mark -

@implementation TimerAgent

@synthesize timers = _timers;

- (id)init
{
    self = [super init];
    if ( self )
    {
        _timers = [[NSMutableArray nonRetainingArray] retain];
    }
    return self;
}

- (void)dealloc
{
    for ( NSTimer * timer in _timers )
    {
        [timer invalidate];
    }
    
    [_timers removeAllObjects];
    [_timers release];
    
    [super dealloc];
}

- (NSTimer *)timerForName:(NSString *)name
{
    for ( NSTimer * timer in _timers )
    {
        if ( [timer.name isEqualToString:name] )
            return timer;
    }
    
    return nil;
}

@end

#pragma mark -

@implementation NSObject(LionTimer)

- (TimerAgent *)__timerAgent
{
    TimerAgent * agent = objc_getAssociatedObject( self, "NSObject.timerAgent" );
    if ( nil == agent )
    {
        agent = [[[TimerAgent alloc] init] autorelease];
        
        objc_setAssociatedObject( self, "NSObject.timerAgent", agent, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }
    
    return agent;
}

- (NSTimer *)timer:(NSTimeInterval)interval
{
    return [self timer:interval repeat:NO name:nil];
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat
{
    return [self timer:interval repeat:repeat name:nil];
}

- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name
{
    TimerAgent * agent = [self __timerAgent];
    
    NSTimer * timer = [agent timerForName:name];
    if ( nil == timer )
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                 target:self
                                               selector:@selector(handleTimer:)
                                               userInfo:nil
                                                repeats:repeat];
        timer.name = name;
        [agent.timers addObject:timer];
    }
    
    return timer;
}

- (void)cancelTimer:(NSString *)name
{
    TimerAgent * agent = [self __timerAgent];
    
    NSTimer * timer = [agent timerForName:name];
    if ( timer )
    {
        [timer invalidate];
        [agent.timers removeObject:timer];
    }
}

- (void)cancelAllTimers
{
    TimerAgent * agent = [self __timerAgent];
    
    for ( NSTimer * timer in agent.timers )
    {
        [timer invalidate];
    }
    
    [agent.timers removeAllObjects];
}

- (void)handleTimer:(NSTimer *)timer
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionTimer )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
