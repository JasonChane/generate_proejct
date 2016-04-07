//
//  Lion_Singleton.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Singleton.h"
#import "Lion_Runtime.h"
#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

#undef	__PRELOAD_SINGLETON__
#define __PRELOAD_SINGLETON__	(__OFF__)

#pragma mark -

@implementation LionSingleton

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__
    
    INFO( @"Loading singletons ..." );
    
    [[LionLogger sharedInstance] indent];
    //	[[LionLogger sharedInstance] disable];
    
    NSMutableArray * availableClasses = [NSMutableArray arrayWithArray:[LionRuntime allSubClassesOf:[NSObject class]]];
    [availableClasses sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 description] compare:[obj2 description]];
    }];
    
    for ( Class classType in availableClasses )
    {
        if ( [classType instancesRespondToSelector:@selector(sharedInstance)] )
        {
            [classType sharedInstance];
            
            //			[[LionLogger sharedInstance] enable];
            INFO( @"%@ loaded", [classType description] );
            //			[[LionLogger sharedInstance] disable];
        }
    }
    
    [[LionLogger sharedInstance] unindent];
    //	[[LionLogger sharedInstance] enable];
    
#endif	// #if defined(__PRELOAD_SINGLETON__) && __PRELOAD_SINGLETON__
    
    return YES;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

@interface SingletonTest : NSObject
AS_SINGLETON( SingletonTest )
@end

@implementation SingletonTest
DEF_SINGLETON( SingletonTest )
@end

TEST_CASE( LionSingleton )
{
    TIMES( 3 )
    {
        SingletonTest * a = [SingletonTest sharedInstance];
        SingletonTest * b = [SingletonTest sharedInstance];
        
        EXPECTED( nil != a );
        EXPECTED( nil != b );
        EXPECTED( a == b );
    }
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
