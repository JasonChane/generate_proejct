//
//  NSArray+LionActiveRecord.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSArray+LionActiveRecord.h"
#import "NSDictionary+LionActiveRecord.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSArray(LionActiveRecord)

- (LionDatabaseBoolBlock)SAVE
{
    LionDatabaseBoolBlock block = ^ BOOL ( void )
    {
        BOOL allSucceed = YES;
        
        for ( NSObject * elem in self )
        {
            if ( [elem isKindOfClass:[LionActiveRecord class]] )
            {
                LionActiveRecord * record = (LionActiveRecord *)elem;
                record.changed = YES;
                BOOL succeed = record.SAVE();
                if ( NO == succeed )
                {
                    allSucceed = NO;
                }
            }
        }
        
        return allSucceed;
    };
    
    return [[block copy] autorelease];
}

- (NSArray *)objectToActiveRecord:(Class)clazz
{
    NSMutableArray * array = [NSMutableArray array];
    
    for ( NSObject * obj in self )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            LionActiveRecord * record = [(NSDictionary *)obj objectToActiveRecord:clazz];
            if ( record )
            {
                [array addObject:record];
            }
        }
    }
    
    return array;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSArray_LionActiveRecord )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
