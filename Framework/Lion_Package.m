//
//  Lion_Package.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Package.h"
#import "Lion_Singleton.h"
#import "Lion_SystemInfo.h"
#import "NSArray+LionExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

LionPackage * Lion = nil;

#pragma mark -

@implementation NSObject(AutoLoading)

+ (BOOL)autoLoad
{
    return YES;
}

@end

#pragma mark -

@interface LionPackage()
{
    NSMutableArray * _loadedPackages;
}

AS_SINGLETON( LionPackage )

@end

#pragma mark -

@implementation LionPackage

DEF_SINGLETON( LionPackage )

@synthesize loadedPackages = _loadedPackages;

+ (void)load
{
    [LionPackage sharedInstance];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _loadedPackages = [[NSMutableArray nonRetainingArray] retain];
        
        [self loadClasses];
        
        Lion = self;
    }
    return self;
}

- (void)dealloc
{
    [_loadedPackages removeAllObjects];
    [_loadedPackages release];
    
    [super dealloc];
}

- (void)loadClasses
{
    const char * autoLoadClasses[] = {
        "LionLogger",
        "LionMsc",
        
#if (TARGET_OS_MAC)
        "LionCLI",
#endif	// #if (TARGET_OS_MAC)
        
        "LionReachability",
        "LionHTTPServerConfig",
        "LionHTTPClientConfig",
        "LionActiveRecord",
        "LionModel",
        "LionController",
        "LionLanguageSetting",
        
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        "LionUIStyleManager",
        "LionUITemplateParser",
        "LionUITemplateManager",
        "LionUIKeyboard",
#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
        
        // TODO: ADD MORE CLASSES HERE
        
        "LionUnitTest",
        "LionSingleton",
        "LionService",
        
        NULL
    };
    
    NSUInteger total = 0;
    
    for ( NSInteger i = 0;; ++i )
    {
        const char * className = autoLoadClasses[i];
        if ( NULL == className )
            break;
        
        Class classType = NSClassFromString( [NSString stringWithUTF8String:className] );
        if ( classType )
        {
            BOOL succeed = [classType autoLoad];
            if ( succeed )
            {
                [_loadedPackages addObject:classType];
            }
        }
        
        total += 1;
    }
}

@end

