//
//  Lion_Ticker.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//


#import "Lion_Ticker.h"
#import "Lion_UnitTest.h"
#import "NSArray+LionExtension.h"
#import "NSObject+LionTicker.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage, LionTicker, ticker );

#pragma mark -

@interface LionTicker()
{
    CADisplayLink *		_timer;
    NSTimeInterval		_interval;
    NSTimeInterval		_timestamp;
    NSMutableArray *	_receivers;
}

- (void)performTick;

@end

#pragma mark -

@implementation LionTicker

@synthesize timer = _timer;
@synthesize interval = _interval;
@synthesize timestamp = _timestamp;

DEF_SINGLETON( LionTicker )

- (id)init
{
    self = [super init];
    if ( self )
    {
        _interval = (1.0f / 3.0f);
        _receivers = [[NSMutableArray nonRetainingArray] retain];
    }
    
    return self;
}

- (void)addReceiver:(NSObject *)obj
{
    if ( NO == [_receivers containsObject:obj] )
    {
        [_receivers addObject:obj];
        
        if ( nil == _timer )
        {
            _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(performTick)];
            [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            
            _timestamp = [NSDate timeIntervalSinceReferenceDate];
        }
    }
}

- (void)removeReceiver:(NSObject *)obj
{
    [_receivers removeObject:obj];
    
    if ( 0 == _receivers.count )
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)performTick
{
    NSTimeInterval tick = [NSDate timeIntervalSinceReferenceDate];
    NSTimeInterval elapsed = tick - _timestamp;
    
    if ( elapsed >= _interval )
    {
        NSArray * array = [NSArray arrayWithArray:_receivers];
        
        for ( NSObject * obj in array )
        {
            if ( [obj respondsToSelector:@selector(handleTick:)] )
            {
                [obj handleTick:elapsed];
            }
        }
        
        _timestamp = tick;
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [_receivers removeAllObjects];
    [_receivers release];
    
    [super dealloc];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

#pragma mark -

TEST_CASE( LionTicker )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
