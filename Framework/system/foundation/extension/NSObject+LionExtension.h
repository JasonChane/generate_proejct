//
//  NSObject+LionExtension.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#pragma mark -

#undef	DISPOSABLE
#define	DISPOSABLE( __class, __name ) \
__class * __name = [__class disposable]

#pragma mark -

@interface NSObject(LionExtension)

+ (instancetype)object;
+ (instancetype)disposable;

- (void)load;
- (void)unload;

- (void)performLoad;
- (void)performUnload;

- (void)performSelectorAlongChain:(SEL)sel;
- (void)performSelectorAlongChainReversed:(SEL)sel;

- (void)copyPropertiesFrom:(id)obj;

@end

