//
//  NSTimer+LionExtension.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSTimer+LionExtension.h"

#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSTimer(LionExtension)

@dynamic name;

- (NSString *)name
{
    NSObject * obj = objc_getAssociatedObject( self, "NSTimer.name" );
    if ( obj && [obj isKindOfClass:[NSString class]] )
        return (NSString *)obj;
    
    return nil;
}

- (void)setName:(NSString *)value
{
    objc_setAssociatedObject( self, "NSTimer.name", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSTimer_LionExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
