//
//  Lion_FileCache.h
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
#import <Foundation/Foundation.h>

#pragma mark -

AS_PACKAGE( LionPackage_System, LionFileCache, fileCache );

#pragma mark -

@interface LionFileCache : NSObject<LionCacheProtocol>

@property (nonatomic, retain) NSString *	cachePath;
@property (nonatomic, retain) NSString *	cacheUser;

AS_SINGLETON( LionFileCache );

- (NSString *)fileNameForKey:(NSString *)key;

@end
