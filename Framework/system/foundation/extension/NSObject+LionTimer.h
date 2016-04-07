//
//  NSObject+LionTimer.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#pragma mark -

@interface NSObject(LionTimer)
- (NSTimer *)timer:(NSTimeInterval)interval;
- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat;
- (NSTimer *)timer:(NSTimeInterval)interval repeat:(BOOL)repeat name:(NSString *)name;
- (void)cancelTimer:(NSString *)name;
- (void)cancelAllTimers;
- (void)handleTimer:(NSTimer *)timer;
@end
