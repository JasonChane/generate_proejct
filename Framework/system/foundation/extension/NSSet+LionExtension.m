//
//  NSSet+LionExtension.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSSet+LionExtension.h"

#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }

#pragma mark -

@implementation NSMutableSet(LionExtension)

+ (NSMutableSet *)nonRetainingSet	// copy from Three20
{
    CFSetCallBacks callbacks = kCFTypeSetCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return [(NSMutableSet *)CFSetCreateMutable( nil, 0, &callbacks ) autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSSet_LionExtension )
{
}
TEST_CASE_END

TEST_CASE( NSMutableSet_LionExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

