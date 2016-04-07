//
//  Lion_Reachability.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Reachability.h"
#import "Lion_HTTPRequestQueue.h"
#import "Reachability.h"

#import "NSObject+LionNotification.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage, LionReachability, reachability );

#pragma mark -

@interface LionReachability()
{
    Reachability *	_reach;
}

- (BOOL)isReachable;
- (BOOL)isReachableViaWIFI;
- (BOOL)isReachableViaWLAN;

@end

#pragma mark -

@implementation LionReachability

DEF_SINGLETON( LionReachability )

DEF_NOTIFICATION( WIFI_REACHABLE )
DEF_NOTIFICATION( WLAN_REACHABLE )
DEF_NOTIFICATION( UNREACHABLE )

DEF_NOTIFICATION( CHANGED )

@dynamic isReachable;
@dynamic isReachableViaWIFI;
@dynamic isReachableViaWLAN;

@dynamic localIP;
@dynamic publicIP;

+ (BOOL)autoLoad
{
    [LionReachability sharedInstance];
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        [self observeNotification:kReachabilityChangedNotification];
        
        _reach = [[Reachability reachabilityWithHostName:@"www.apple.com"] retain];
        [_reach startNotifier];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [_reach release];
    _reach = nil;
    
    [super dealloc];
}

+ (BOOL)isReachable
{
    return [[LionReachability sharedInstance] isReachable];
}

- (BOOL)isReachable
{
    return [_reach isReachable];
}

+ (BOOL)isReachableViaWIFI
{
    return [[LionReachability sharedInstance] isReachableViaWIFI];
}

- (BOOL)isReachableViaWIFI
{
    if ( NO == [_reach isReachable] )
    {
        return NO;
    }
    
    return [_reach isReachableViaWiFi];
}

+ (BOOL)isReachableViaWLAN
{
    return [[LionReachability sharedInstance] isReachableViaWLAN];
}

- (BOOL)isReachableViaWLAN
{
    if ( NO == [_reach isReachable] )
    {
        return NO;
    }
    
    return [_reach isReachableViaWWAN];
}

+ (NSString *)localIP
{
    return [[LionReachability sharedInstance] localIP];
}

- (NSString *)localIP
{
    NSString *			ipAddr = nil;
    struct ifaddrs *	addrs = NULL;
    
    int ret = getifaddrs( &addrs );
    if ( 0 == ret )
    {
        const struct ifaddrs * cursor = addrs;
        
        while ( cursor )
        {
            if ( AF_INET == cursor->ifa_addr->sa_family && 0 == (cursor->ifa_flags & IFF_LOOPBACK) )
            {
                ipAddr = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
                break;
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs( addrs );
    }
    
    return ipAddr;
}

+ (NSString *)publicIP
{
    return [[LionReachability sharedInstance] publicIP];
}

- (NSString *)publicIP
{
    return nil;
}

ON_NOTIFICATION( notification )
{
    if ( [notification is:kReachabilityChangedNotification] )
    {
        if ( NO == [_reach isReachable] )
        {
            [self postNotification:LionReachability.UNREACHABLE];
        }
        else
        {
            if ( [_reach isReachableViaWiFi] )
            {
                [self postNotification:LionReachability.WIFI_REACHABLE];
            }
            else if ( [_reach isReachableViaWWAN] )
            {
                [self postNotification:LionReachability.WLAN_REACHABLE];
            }
        }
        
        [self postNotification:LionReachability.CHANGED];
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionReachability )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

