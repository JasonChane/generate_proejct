//
//  NSObject+LionNotification.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_UnitTest.h"
#import "Lion_Log.h"
#import "Lion_Runtime.h"

#import "NSObject+LionNotification.h"
#import "NSObject+LionProperty.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNotification(LionNotification)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

#pragma mark -

@implementation NSObject(LionNotification)

+ (NSString *)NOTIFICATION
{
    return [self NOTIFICATION_TYPE];
}

+ (NSString *)NOTIFICATION_TYPE
{
    return [NSString stringWithFormat:@"notify.%@.", [self description]];
}

- (void)handleNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    
    NSArray * array = [notificationName componentsSeparatedByString:@"."];
    if ( array && array.count > 1 )
    {
        //		NSString * prefix = (NSString *)[array objectAtIndex:0];
        NSString * clazz = (NSString *)[array objectAtIndex:1];
        NSString * name = (NSString *)[array objectAtIndex:2];
        
        {
            NSString * selectorName;
            SEL selector;
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@_%@:", clazz, name];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
            
            selectorName = [NSString stringWithFormat:@"handleNotification_%@:", clazz];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:notificationName
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray * methods = [LionRuntime allInstanceMethodsOf:[self class] withPrefix:@"handleNotification_"];
    if ( nil == methods || 0 == methods.count )
    {
        return;
    }
    
    for ( NSString * selectorName in methods )
    {
        SEL sel = NSSelectorFromString( selectorName );
        if ( NULL == sel )
            continue;
        
        NSMutableString * notificationName = [self performSelector:sel];
        if ( nil == notificationName  )
            continue;
        
        [self observeNotification:notificationName];
    }
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)postNotification:(NSString *)name
{
    INFO( @"Notification '%@'", [name stringByReplacingOccurrencesOfString:@"notify." withString:@""] );
    
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(NSObject *)object
{
    return [[self class] postNotification:name withObject:object];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionNotification )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
