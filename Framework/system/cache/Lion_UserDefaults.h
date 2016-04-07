//
//  Lion_UserDefaults.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"
#import "Lion_CacheProtocol.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionUserDefaults, userDefaults );

#pragma mark -

#define AS_USERDEFAULT( __name )	AS_STATIC_PROPERTY( __name )
#define DEF_USERDEFAULT( __name )	DEF_STATIC_PROPERTY3( __name, @"userdefault", [self description] )

#pragma mark -

@interface LionUserDefaults : NSObject<LionCacheProtocol>

AS_SINGLETON( LionUserDefaults )

@end