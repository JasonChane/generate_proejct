//
//  NSObject+LionDatabase.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Database.h"

#pragma mark -

@interface NSObject(LionDatabase)

@property (nonatomic, readonly) LionDatabase * DB;

+ (LionDatabase *)DB;

- (NSString *)tableName;
+ (NSString *)tableName;

@end
