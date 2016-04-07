//
//  NSObject+LionUserDefaults.m
//  generate
//
//  Created by guang on 15/4/28.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionUserDefaults.h"
#import "Lion_UserDefaults.h"
#import "Lion_SystemInfo.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionUserDefaults)

+ (NSString *)persistenceKey:(NSString *)key
{
    if ( key )
    {
        key = [NSString stringWithFormat:@"%@.%@", [self description], key];
    }
    else
    {
        key = [NSString stringWithFormat:@"%@", [self description]];
    }
    
    key = [key stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    key = [key stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    return key.uppercaseString;
}

+ (id)userDefaultsRead:(NSString *)key
{
    if ( nil == key )
        return nil;
    
    key = [self persistenceKey:key];
    
    return [[LionUserDefaults sharedInstance] objectForKey:key];
}

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
    if ( nil == key || nil == value )
        return;
    
    key = [self persistenceKey:key];
    
    [[LionUserDefaults sharedInstance] setObject:value forKey:key];
}

+ (void)userDefaultsRemove:(NSString *)key
{
    if ( nil == key )
        return;
    
    key = [self persistenceKey:key];
    
    [[LionUserDefaults sharedInstance] removeObjectForKey:key];
}

- (id)userDefaultsRead:(NSString *)key
{
    return [[self class] userDefaultsRead:key];
}

- (void)userDefaultsWrite:(id)value forKey:(NSString *)key
{
    [[self class] userDefaultsWrite:value forKey:key];
}

- (void)userDefaultsRemove:(NSString *)key
{
    [[self class] userDefaultsRemove:key];
}

+ (id)readObject
{
    return [self readObjectForKey:nil];
}

+ (id)readObjectForKey:(NSString *)key
{
    key = [self persistenceKey:key];
    
    id value = [[LionUserDefaults sharedInstance] objectForKey:key];
    if ( value )
    {
        return [self objectFromAny:value];
    }
    
    return nil;
}

+ (void)saveObject:(id)obj
{
    [self saveObject:obj forKey:nil];
}

+ (void)saveObject:(id)obj forKey:(NSString *)key
{
    if ( nil == obj )
        return;
    
    key = [self persistenceKey:key];
    
    NSString * value = [obj objectToString];
    if ( value && value.length )
    {
        [[LionUserDefaults sharedInstance] setObject:value forKey:key];
    }
    else
    {
        [[LionUserDefaults sharedInstance] removeObjectForKey:key];
    }
}

+ (void)removeObject
{
    [self removeObjectForKey:nil];
}

+ (void)removeObjectForKey:(NSString *)key
{
    key = [self persistenceKey:key];
    
    [[LionUserDefaults sharedInstance] removeObjectForKey:key];
}

+ (id)readFromUserDefaults:(NSString *)key
{
    if ( nil == key )
        return nil;
    
    NSString * jsonString = [self userDefaultsRead:key];
    if ( nil == jsonString || NO == [jsonString isKindOfClass:[NSString class]] )
        return nil;
    
    NSObject * decodedObject = [jsonString objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:nil];
    if ( nil == decodedObject )
        return nil;
    
    return [self objectFromAny:decodedObject];
}

- (id)readFromUserDefaults:(NSString *)key
{
    id object = [[self class] readFromUserDefaults:key];
    if ( nil == object )
    {
        return self;
    }
    
    if ( [self isKindOfClass:[NSNumber class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSString class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSArray class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSDictionary class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSDate class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSObject class]] )
    {
        return object;
    }
    else if ( [self isKindOfClass:[NSMutableArray class]] )
    {
        NSMutableArray * mutableArray = (NSMutableArray *)self;
        [mutableArray addObjectsFromArray:object];
        return self;
    }
    else if ( [self isKindOfClass:[NSMutableDictionary class]] )
    {
        NSMutableDictionary * mutableDict = (NSMutableDictionary *)self;
        [mutableDict addEntriesFromDictionary:object];
        return self;
    }
    else
    {
        [self copyPropertiesFrom:object];
        return self;
    }
}

- (void)saveToUserDefaults:(NSString *)key
{
    if ( nil == key )
        return;
    
    NSString * jsonString = [self objectToString];
    if ( nil == jsonString || 0 == jsonString.length )
        return;
    
    [self userDefaultsWrite:jsonString forKey:key];
}

- (void)removeFromUserDefaults:(NSString *)key
{
    [[self class] userDefaultsRemove:key];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionUserDefaults )
{
    [self userDefaultsWrite:@"value" forKey:@"key"];
    
    NSString * value = [self userDefaultsRead:@"key"];
    ASSERT( nil != value && [value isEqualToString:@"value"] );
    
    [self userDefaultsRemove:@"key"];
    
    NSString * value2 = [self userDefaultsRead:@"key"];
    ASSERT( nil == value2 );
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
