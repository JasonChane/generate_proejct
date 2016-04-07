//
//  Lion_Thread.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Singleton.h"

#pragma mark -

AS_PACKAGE( LionPackage, LionThread, thread );
AS_PACKAGE( LionPackage, LionThread, taskQueue );

#pragma mark -

@class LionThread;
@compatibility_alias LionTaskQueue LionThread;

typedef LionThread * (^LionThreadBlock)( dispatch_block_t block );

#pragma mark -

#define FOREGROUND_BEGIN		[LionThread enqueueForeground:^{
#define FOREGROUND_BEGIN_(x)	[LionThread enqueueForegroundWithDelay:(dispatch_time_t)x block:^{
#define FOREGROUND_COMMIT		}];

#define BACKGROUND_BEGIN		[LionThread enqueueBackground:^{
#define BACKGROUND_BEGIN_(x)	[LionThread enqueueBackgroundWithDelay:(dispatch_time_t)x block:^{
#define BACKGROUND_COMMIT		}];

#pragma mark -

@interface LionThread : NSObject

@property (nonatomic, readonly) LionThreadBlock	MAIN;
@property (nonatomic, readonly) LionThreadBlock	FORK;

AS_SINGLETON( LionThread )

+ (dispatch_queue_t)foreQueue;
+ (dispatch_queue_t)backQueue;

+ (void)enqueueForeground:(dispatch_block_t)block;
+ (void)enqueueBackground:(dispatch_block_t)block;
+ (void)enqueueForegroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;
+ (void)enqueueBackgroundWithDelay:(dispatch_time_t)ms block:(dispatch_block_t)block;

@end
