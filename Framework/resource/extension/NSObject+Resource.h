//
//  NSObject+Resource.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#pragma mark -

@interface NSObject(Resource)

+ (NSString *)stringFromResource:(NSString *)resName;
- (NSString *)stringFromResource:(NSString *)resName;

+ (NSData *)dataFromResource:(NSString *)resName;
- (NSData *)dataFromResource:(NSString *)resName;

+ (id)objectFromResource:(NSString *)resName;

@end
