//
//  Lion_Ticker.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Singleton.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

AS_PACKAGE( LionPackage, LionTicker, ticker );

#pragma mark -

#undef	ON_TICK
#define ON_TICK( __time ) \
- (void)handleTick:(NSTimeInterval)__time

#pragma mark -

@interface LionTicker : NSObject

@property (nonatomic, readonly)	CADisplayLink *		timer;
@property (nonatomic, readonly)	NSTimeInterval		timestamp;
@property (nonatomic, assign) NSTimeInterval		interval;

AS_SINGLETON( LionTicker )

- (void)addReceiver:(NSObject *)obj;
- (void)removeReceiver:(NSObject *)obj;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
