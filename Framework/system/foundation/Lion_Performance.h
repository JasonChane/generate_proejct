//
//  Lion_Performance.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Singleton.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionPerformance, performance );

#pragma mark -

#define PERF_TAG( __X )				[NSString stringWithFormat:@"%s %s", __PRETTY_FUNCTION__, __X]
#define PERF_TAG1( __X )			[NSString stringWithFormat:@"enter - %s %s", __PRETTY_FUNCTION__, __X]
#define PERF_TAG2( __X )			[NSString stringWithFormat:@"leave - %s %s", __PRETTY_FUNCTION__, __X]

#if __Lion_PERFORMANCE__

#define	PERF_MARK( __X )			[[LionPerformance sharedInstance] markTag:PERF_TAG(#__X)];
#define	PERF_TIME( __X1, __X2 )		[[LionPerformance sharedInstance] betweenTag:PERF_TAG(#__X1) andTag:PERF_TAG(#__X2)]

#define PERF_ENTER					[[LionPerformance sharedInstance] markTag:PERF_TAG1("")];
#define PERF_LEAVE \
[[LionPerformance sharedInstance] markTag:PERF_TAG2("")]; \
[[LionPerformance sharedInstance] recordName:PERF_TAG("") \
andTime:[[LionPerformance sharedInstance] betweenTag:PERF_TAG1("") andTag:PERF_TAG2("")]];

#define PERF_ENTER_( __X )			[[LionPerformance sharedInstance] markTag:PERF_TAG1(#__X)];
#define PERF_LEAVE_( __X ) \
[[LionPerformance sharedInstance] markTag:PERF_TAG2(#__X)]; \
[[LionPerformance sharedInstance] recordName:PERF_TAG(#__X) \
andTime:[[LionPerformance sharedInstance] betweenTag:PERF_TAG1(#__X) andTag:PERF_TAG2(#__X)]];

#else	// #if __Lion_PERFORMANCE__

#define	PERF_MARK( __TAG )
#define	PERF_TIME( __TAG1, __TAG2 )	(0.0f)

#define PERF_ENTER
#define PERF_LEAVE

#define PERF_ENTER_( __X )
#define PERF_LEAVE_( __X )

#endif	// #if __Lion_PERFORMANCE__

#pragma mark -

@interface LionPerformanceRecord : NSObject
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, assign) NSTimeInterval	time;
@end

#pragma mark -

@interface LionPerformance : NSObject

AS_SINGLETON( LionPerformance );

@property (nonatomic, readonly) NSArray *		records;
@property (nonatomic, assign) NSTimeInterval	valve;

- (double)timestamp;

- (double)markTag:(NSString *)tag;
- (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2;
- (double)betweenTag:(NSString *)tag1 andTag:(NSString *)tag2 shouldRemove:(BOOL)remove;

- (void)watchClass:(Class)clazz;
- (void)watchClass:(Class)clazz andSelector:(SEL)selector;

- (void)recordName:(NSString *)name andTime:(NSTimeInterval)time;

@end
