//
//  Lion_Service.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Service.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
#import "Lion_UIApplication.h"
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE_( LionPackage, LionPackage_Service, services );

#pragma mark -

#undef	__PRELOAD_SERVICES__
#define __PRELOAD_SERVICES__	(__ON__)

#pragma mark -

@interface LionService()
{
    BOOL					_running;
    BOOL					_activating;
    
    NSString *				_name;
    NSBundle *				_bundle;
    NSDictionary *			_launchParameters;
}

- (void)initSelf;

@end

#pragma mark -

@implementation LionService

@synthesize name = _name;
@synthesize bundle = _bundle;
@synthesize launchParameters = _launchParameters;

@synthesize running = _running;
@synthesize activating = _activating;

@dynamic ON;
@dynamic OFF;

static NSMutableDictionary * __services = nil;

+ (BOOL)autoLoad
{
#if defined(__PRELOAD_SERVICES__) && __PRELOAD_SERVICES__
    
    INFO( @"Loading services ..." );
    
    [[LionLogger sharedInstance] indent];
    //	[[LionLogger sharedInstance] disable];
    
    NSArray * availableClasses = [LionRuntime allSubClassesOf:[LionService class]];
    
    for ( Class classType in availableClasses )
    {
        if ( [classType serviceAutoLoading] )
        {
            LionService * service = [classType sharedInstance];
            if ( service )
            {
                //				[[LionLogger sharedInstance] enable];
                INFO( @"Service '%@' loaded", [classType description] );
                //				[[LionLogger sharedInstance] disable];
            }
        }
    }
    
    [[LionLogger sharedInstance] unindent];
    //	[[LionLogger sharedInstance] enable];
    
#endif	// #if defined(__PRELOAD_SERVICES__) && __PRELOAD_SERVICES__
    
    return YES;
}

+ (instancetype)sharedInstance
{
    LionService * service = [__services objectForKey:self.description];
    if ( nil == service )
    {
        BOOL succeed = [self servicePreLoad];
        if ( succeed )
        {
            LionService * service = [[[self alloc] init] autorelease];
            if ( service )
            {
                [self serviceDidLoad];
                
#if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
                if ( [self serviceAutoPowerOn] )
                {
                    service.ON();
                }
#endif	// #if !(TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
            }
        }
    }
    
    return service;
}

+ (BOOL)serviceAutoLoading
{
    return NO;
}

+ (BOOL)serviceAutoPowerOn
{
    return NO;
}

+ (BOOL)serviceHasUI
{
    return NO;
}

+ (BOOL)serviceHasDock
{
    return NO;
}

+ (BOOL)servicePreLoad
{
    return YES;
}

+ (void)serviceDidLoad
{
}

- (void)initSelf
{
    self.name = [[self class] description];
    
    Class serviceClass = [self class];
    for ( ;; )
    {
        NSString * bundlePath = [[NSBundle mainBundle] pathForResource:[serviceClass description] ofType:@"bundle"];
        NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
        
        if ( nil != bundle )
        {
            self.bundle = bundle;
            break;
        }
        
        serviceClass = class_getSuperclass( serviceClass );
        if ( nil == serviceClass || serviceClass == [NSObject class] )
            break;
    }
    
    if ( nil == __services )
    {
        __services = [[NSMutableDictionary alloc] init];
    }
    
    [__services setObject:self forKey:[[self class] description]];
    
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    [self observeNotification:LionUIApplication.LAUNCHED];
    [self observeNotification:LionUIApplication.STATE_CHANGED];
    [self observeNotification:LionUIApplication.TERMINATED];
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        [self initSelf];
        //		[self load];
        [self performLoad];
    }
    return self;
}

- (void)dealloc
{
    if ( _running )
    {
        [self powerOff];
    }
    
    //	[self unload];
    [self performUnload];
    
    self.name = nil;
    self.bundle = nil;
    
    [self unobserveAllNotifications];
    
    [super dealloc];
}

- (void)load
{
}

- (void)unload
{
}

- (NSArray *)loadedServices
{
    return __services.allValues;
}

- (BOOL)running
{
    return _running;
}

- (void)powerOn
{
}

- (void)powerOff
{
}

- (void)serviceWillActive
{
}

- (void)serviceDidActived
{
}

- (void)serviceWillDeactive
{
}

- (void)serviceDidDeactived
{
}

- (LionServiceBlock)ON
{
    LionServiceBlock block = ^ void ( void )
    {
        if ( NO == _running )
        {
            [self powerOn];
            
            _running = YES;
        }
    };
    
    return [[block copy] autorelease];
}

- (LionServiceBlock)OFF
{
    LionServiceBlock block = ^ void ( void )
    {
        if ( _running )
        {
            [self powerOff];
            
            _running = NO;
        }
    };
    
    return [[block copy] autorelease];
}

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

ON_NOTIFICATION3( LionUIApplication, STATE_CHANGED, notification )
{
    if ( [LionUIApplication sharedInstance].inBackground )
    {
        INFO( @"Service '%@' deactivating", [[self class] description] );
        
        if ( _activating )
        {
            [self serviceWillDeactive];
            
            _activating = NO;
            
            [self serviceDidDeactived];
        }
    }
    else
    {
        INFO( @"Service '%@' activating", [[self class] description] );
        
        if ( NO == _activating )
        {
            [self serviceWillActive];
            
            _activating = YES;
            
            [self serviceDidActived];
        }
    }
}

ON_NOTIFICATION3( LionUIApplication, LAUNCHED, notification )
{
    if ( [notification.object isKindOfClass:[NSDictionary class]] )
    {
        self.launchParameters = [NSDictionary dictionaryWithDictionary:(NSDictionary *)notification.object];
    }
    else
    {
        self.launchParameters = nil;
    }
    
    if ( [[self class] serviceAutoPowerOn] )
    {
        self.ON();
    }
}

ON_NOTIFICATION3( LionUIApplication, TERMINATED, notification )
{
    self.OFF();
}

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionService )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
