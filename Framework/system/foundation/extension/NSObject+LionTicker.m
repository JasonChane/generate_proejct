//
//  NSObject+LionTicker.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionTicker.h"

#import "Lion_Ticker.h"
#import "Lion_UnitTest.h"
#import "NSArray+LionExtension.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionTicker)

- (void)observeTick
{
    [[LionTicker sharedInstance] addReceiver:self];
}

- (void)unobserveTick
{
    [[LionTicker sharedInstance] removeReceiver:self];
}

- (void)handleTick:(NSTimeInterval)elapsed
{
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionTicker )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

