//
//  Lion_MemoryCache.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_CacheProtocol.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionMemoryCache, memoryCache );

#pragma mark -

@interface LionMemoryCache : NSObject<LionCacheProtocol>

@property (nonatomic, assign) BOOL					clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger			maxCacheCount;
@property (nonatomic, assign) NSUInteger			cachedCount;
@property (atomic, retain) NSMutableArray *			cacheKeys;
@property (atomic, retain) NSMutableDictionary *	cacheObjs;

AS_SINGLETON( LionMemoryCache );

@end
