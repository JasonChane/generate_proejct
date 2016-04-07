//
//  Lion_Reachability.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"

#pragma mark -

AS_PACKAGE( LionPackage, LionReachability, reachability );

#pragma mark -

@class LionReachability;
@compatibility_alias LionNetworkReachability LionReachability;

#pragma mark -

@interface LionReachability : NSObject

AS_NOTIFICATION( WIFI_REACHABLE )
AS_NOTIFICATION( WLAN_REACHABLE )
AS_NOTIFICATION( UNREACHABLE )

AS_NOTIFICATION( CHANGED )

AS_SINGLETON( LionReachability )

@property (nonatomic, readonly) BOOL		isReachable;
@property (nonatomic, readonly) BOOL		isReachableViaWIFI;
@property (nonatomic, readonly) BOOL		isReachableViaWLAN;

@property (nonatomic, readonly) NSString *	localIP;
@property (nonatomic, readonly) NSString *	publicIP;

+ (BOOL)isReachable;
+ (BOOL)isReachableViaWIFI;
+ (BOOL)isReachableViaWLAN;

+ (NSString *)localIP;
+ (NSString *)publicIP;

@end
