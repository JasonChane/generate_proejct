//
//  NSNumber+LionExtension.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#pragma mark -

#undef	__INT
#define __INT( __x )			[NSNumber numberWithInteger:(NSInteger)__x]

#undef	__UINT
#define __UINT( __x )			[NSNumber numberWithUnsignedInt:(NSUInteger)__x]

#undef	__FLOAT
#define	__FLOAT( __x )			[NSNumber numberWithFloat:(float)__x]

#undef	__DOUBLE
#define	__DOUBLE( __x )			[NSNumber numberWithDouble:(double)__x]

#undef	__BOOL
#define __BOOL( __x )			[NSNumber numberWithBool:(BOOL)__x]

#pragma mark -

@interface NSNumber(LionExtension)

@property (nonatomic, readonly) NSDate *	dateValue;

- (NSString *)stringWithDateFormat:(NSString *)format;

- (NSString *)decimalStyleString;

- (NSString *)currencyStyleString;

@end
