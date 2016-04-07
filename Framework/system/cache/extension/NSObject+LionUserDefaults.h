//
//  NSObject+LionUserDefaults.h
//  generate
//
//  Created by guang on 15/4/28.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_UserDefaults.h"

#pragma mark -

@interface NSObject(LionUserDefaults)

// for key value

+ (id)userDefaultsRead:(NSString *)key;
- (id)userDefaultsRead:(NSString *)key;

+ (void)userDefaultsWrite:(id)value forKey:(NSString *)key;
- (void)userDefaultsWrite:(id)value forKey:(NSString *)key;

+ (void)userDefaultsRemove:(NSString *)key;
- (void)userDefaultsRemove:(NSString *)key;

// for object

+ (id)readObject;
+ (id)readObjectForKey:(NSString *)key;

+ (void)saveObject:(id)obj;
+ (void)saveObject:(id)obj forKey:(NSString *)key;

+ (void)removeObject;
+ (void)removeObjectForKey:(NSString *)key;

+ (id)readFromUserDefaults:(NSString *)key;
- (id)readFromUserDefaults:(NSString *)key;

- (void)saveToUserDefaults:(NSString *)key;
- (void)removeFromUserDefaults:(NSString *)key;

@end
