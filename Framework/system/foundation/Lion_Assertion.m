//
//  Lion_Assertion.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Assertion.h"
#import "Lion_SystemInfo.h"
#import "Lion_Runtime.h"
#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

static BOOL	__enabled = YES;

void LionAssertToggle( void )
{
    __enabled = __enabled ? NO : YES;
}

void LionAssertEnable( void )
{
    __enabled = YES;
}

void LionAssertDisable( void )
{
    __enabled = NO;
}

void LionAssert( BOOL flag, const char * expr, const char * function, const char * file, int line )
{
#if __Lion_DEVELOPMENT__
    if ( NO == flag )
    {
        if ( __enabled )
        {
            ERROR( @"assertion failed @ '%s' #%d\n%s\n{\n\t...\n\t%s\n\t...\n}", file, line, function, expr );
            abort();
        }
    }
#endif	// #if __Lion_DEVELOPMENT__
}

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionAssert )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
