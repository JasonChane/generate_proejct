//
//  NSObject+LionKeychain.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionKeychain.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionKeychain)

+ (NSString *)keychainRead:(NSString *)key
{
    return [LionKeychain readValueForKey:key andDomain:[[self class] description]];
}

+ (void)keychainWrite:(NSString *)value forKey:(NSString *)key
{
    [LionKeychain writeValue:value forKey:key andDomain:[[self class] description]];
}

+ (void)keychainDelete:(NSString *)key
{
    [LionKeychain deleteValueForKey:key andDomain:[[self class] description]];
}

- (NSString *)keychainRead:(NSString *)key
{
    return [LionKeychain readValueForKey:key andDomain:[[self class] description]];
}

- (void)keychainWrite:(NSString *)value forKey:(NSString *)key
{
    [LionKeychain writeValue:value forKey:key andDomain:[[self class] description]];
}

- (void)keychainDelete:(NSString *)key
{
    [LionKeychain deleteValueForKey:key andDomain:[[self class] description]];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionKeychain )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
