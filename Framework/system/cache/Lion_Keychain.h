//
//  Lion_Keychain.h
//  generate
//
//  Created by guang on 15/4/21.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"
#import "Lion_CacheProtocol.h"

#pragma mark -


AS_PACKAGE( LionPackage_System, LionKeychain, keychain );

#pragma mark -

#define AS_KEYCHAIN( __name )	AS_STATIC_PROPERTY( __name )
#define DEF_KEYCHAIN( __name )	DEF_STATIC_PROPERTY3( __name, @"keychain", [self description] )

#pragma mark -

@interface LionKeychain : NSObject<LionCacheProtocol>

@property (nonatomic, retain) NSString * defaultDomain;

AS_SINGLETON( BeeKeychain )

+ (void)setDefaultDomain:(NSString *)domain;

+ (NSString *)readValueForKey:(NSString *)key;
+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)writeValue:(NSString *)value forKey:(NSString *)key;
+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

+ (void)deleteValueForKey:(NSString *)key;
+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain;

@end


