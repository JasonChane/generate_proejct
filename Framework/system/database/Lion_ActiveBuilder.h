//
//  Lion_ActiveBuilder.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//


#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

@interface LionActiveBuilder : NSObject

+ (void)buildTableFor:(Class)clazz;
+ (void)buildTableFor:(Class)clazz untilRootClass:(Class)rootClass;

+ (BOOL)isTableBuiltFor:(Class)clazz;

@end
