//
//  Lion_UserDefaults.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_UserDefaults.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionUserDefaults, userDefaults );

#pragma mark -

@implementation LionUserDefaults

DEF_SINGLETON( LionUserDefaults )

- (BOOL)hasObjectForKey:(id)key
{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value ? YES : NO;
}

- (id)objectForKey:(NSString *)key
{
    if ( nil == key )
        return nil;
    
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

- (void)setObject:(id)value forKey:(NSString *)key
{
    if ( nil == key || nil == value )
        return;
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( nil == key )
        return;
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAllObjects
{
    [NSUserDefaults resetStandardUserDefaults];
}

- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if ( obj )
    {
        [self setObject:obj forKey:key];
    }
    else
    {
        [self removeObjectForKey:key];
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionUserDefaults )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
