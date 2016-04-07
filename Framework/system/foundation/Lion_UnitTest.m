//
//  Lion_UnitTest.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_UnitTest.h"
#import "Lion_Runtime.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation LionTestCase

+ (BOOL)runTests
{
    return YES;
}

@end

#pragma mark -

@implementation LionUnitTest

static NSUInteger __failedCount = 0;
static NSUInteger __succeedCount = 0;

+ (BOOL)autoLoad
{
    [self runTests];
    
    return YES;
}

+ (NSUInteger)failedCount
{
    return __failedCount;
}

+ (NSUInteger)succeedCount
{
    return __succeedCount;
}

+ (BOOL)runTests
{
#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
    
    __failedCount = 0;
    __succeedCount = 0;
    
    INFO( @"Unit testing ..." );
    
    [[LionLogger sharedInstance] indent];
    
    NSArray * availableClasses = [LionRuntime allSubClassesOf:[LionTestCase class]];
    for ( Class classType in availableClasses )
    {
        [[LionLogger sharedInstance] disable];
        
        BOOL ret = [classType runTests];
        
        [[LionLogger sharedInstance] enable];
        
        NSString * classTypeDesc = [classType description];
        NSString * classTypePadding = [classTypeDesc stringByPaddingToLength:48 withString:@" " startingAtIndex:0];
        
        if ( ret )
        {
            __succeedCount += 1;
            
            PRINT( [NSString stringWithFormat:@"%@\t\t\t\t[PASS]", classTypePadding] );
        }
        else
        {
            __failedCount += 1;
            
            PRINT( [NSString stringWithFormat:@"%@\t\t\t\t[FAIL]", classTypePadding] );
        }
    }
    
    INFO( @"" );
    INFO( @"Failed:  %d", __failedCount );
    INFO( @"Pass:    %.1f", (__succeedCount * 1.0f) / ((__succeedCount + __failedCount) * 1.0f) * 100 );
    
    [[LionLogger sharedInstance] unindent];
    
    return __failedCount ? NO : YES;
    
#else	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
    
    return YES;
    
#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

#pragma mark -

TEST_CASE( LionUnitTest )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
