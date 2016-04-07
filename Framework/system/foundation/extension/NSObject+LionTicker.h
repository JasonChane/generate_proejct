//
//  NSObject+LionTicker.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface NSObject(LionTicker)
- (void)observeTick;
- (void)unobserveTick;
- (void)handleTick:(NSTimeInterval)elapsed;
@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
