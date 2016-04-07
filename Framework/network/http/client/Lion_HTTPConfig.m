//
//  Lion_HTTPConfig.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPConfig.h"
#import "Lion_HTTPRequestQueue.h"
#import "Lion_Reachability.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_HTTP, LionHTTPConfig, config );

#pragma mark -

#undef	CONCURRENT_FOR_WIFI
#define	CONCURRENT_FOR_WIFI	(8)

#undef	CONCURRENT_FOR_WLAN
#define	CONCURRENT_FOR_WLAN	(4)

#pragma mark -

@interface LionHTTPConfig()
{
    NSUInteger	_concurrentForWIFI;
    NSUInteger	_concurrentForWLAN;
    NSString *	_userAgent;
}

- (void)switchWIFI;
- (void)switchWLAN;

@end

#pragma mark -

@implementation LionHTTPConfig

DEF_SINGLETON( LionHTTPConfig )

@synthesize concurrentForWIFI = _concurrentForWIFI;
@synthesize concurrentForWLAN = _concurrentForWLAN;
@synthesize userAgent = _userAgent;

+ (BOOL)autoLoad
{
    [LionHTTPConfig sharedInstance];
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.concurrentForWIFI = CONCURRENT_FOR_WIFI;
        self.concurrentForWLAN = CONCURRENT_FOR_WIFI;
        self.userAgent = [NSString stringWithFormat:@"Lion/%@", LION_VERSION];
        
        [self switchWIFI];
        
        [self observeNotification:LionReachability.CHANGED];
        [self observeNotification:LionReachability.WIFI_REACHABLE];
        [self observeNotification:LionReachability.WLAN_REACHABLE];
        [self observeNotification:LionReachability.UNREACHABLE];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [super dealloc];
}

- (void)switchWIFI
{
    [[ASIHTTPRequest sharedQueue] setMaxConcurrentOperationCount:CONCURRENT_FOR_WIFI];
}

- (void)switchWLAN
{
    [[ASIHTTPRequest sharedQueue] setMaxConcurrentOperationCount:CONCURRENT_FOR_WLAN];
}

ON_NOTIFICATION( notification )
{
    if ( [notification is:LionReachability.WIFI_REACHABLE] )
    {
        [self switchWIFI];
    }
    else if ( [notification is:LionReachability.WLAN_REACHABLE] )
    {
        [self switchWLAN];
    }
    else if ( [notification is:LionReachability.UNREACHABLE] )
    {
        
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionHTTPConfig )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
