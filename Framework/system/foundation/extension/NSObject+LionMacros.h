//
//  NSObject+LionMacros.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//


#import "Lion_Precompile.h"

#pragma mark -

#undef	CLASS_LOAD
#define	CLASS_LOAD \
+ (void)load

#undef	CLASS_UNLOAD
#define	CLASS_UNLOAD \
+ (void)unload

#pragma mark -

#undef	ON_LOAD
#define	ON_LOAD \
- (void)load

#undef	ON_UNLOAD
#define	ON_UNLOAD \
- (void)unload