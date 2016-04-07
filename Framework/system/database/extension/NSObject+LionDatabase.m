//
//  NSObject+LionDatabase.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionDatabase.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionDatabase)

+ (LionDatabase *)DB
{
    LionDatabase * db = [LionDatabase sharedDatabase];
    if ( nil == db )
    {
        NSBundle * bundle = [NSBundle mainBundle];
        NSString * bundleName = [bundle objectForInfoDictionaryKey:@"CFBundleName"];
        if ( nil == bundleName )
        {
            bundleName = @"default";
        }
        
        NSString * dbName = [NSString stringWithFormat:@"%@.sqlite", bundleName];
        BOOL succeed = [LionDatabase openSharedDatabase:dbName];
        if ( succeed )
        {
            db = [LionDatabase sharedDatabase];
        }
        
        if ( db )
        {
            [db clearState];
        }
    }
    return db;
}

- (LionDatabase *)DB
{
    return [NSObject DB];
}

- (NSString *)tableName
{
    return [[self class] tableName];
}

+ (NSString *)tableName
{
    return [LionDatabase tableNameForClass:self];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionDatabase )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

