//
//  NSNumber+LionExtension.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSNumber+LionExtension.h"

#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSNumber(LionExtension)

@dynamic dateValue;

- (NSDate *)dateValue
{
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (NSString *)stringWithDateFormat:(NSString *)format
{
#if 0
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString * result = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[self doubleValue]]];
    [dateFormatter release];
    return result;
    
#else
    
    // thanks @lancy, changed: "NSDate depend on NSNumber" to "NSNumber depend on NSDate"
    
    return [[NSDate dateWithTimeIntervalSince1970:[self doubleValue]] stringWithDateFormat:format];
    
#endif
}

- (NSString *)decimalStyleString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString * result = [formatter stringFromNumber:self];
    [formatter release];
    return result;
}

- (NSString *)currencyStyleString
{
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString * result = [formatter stringFromNumber:self];
    [formatter release];
    return result;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSNumber_LionExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
