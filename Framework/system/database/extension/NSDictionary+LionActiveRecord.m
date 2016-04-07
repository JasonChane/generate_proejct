//
//  NSDictionary+LionActiveRecord.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSDictionary+LionActiveRecord.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSDictionary(LionActiveRecord)

- (LionActiveRecord *)objectToActiveRecord:(Class)clazz
{
    if ( NO == [clazz isSubclassOfClass:[LionActiveRecord class]] )
        return nil;
    
    return [[[clazz alloc] initWithDictionary:self] autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSDictionary_LionActiveRecord )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
