//
//  Lion_Version.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Version.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage, LionVersion, ver );

#pragma mark -

@interface LionVersion()
{
    NSUInteger	_major;
    NSUInteger	_minor;
    NSUInteger	_tiny;
    NSString *	_pre;
}
@end

#pragma mark -

@implementation LionVersion

DEF_SINGLETON( LionVersion )

@synthesize major = _major;
@synthesize minor = _minor;
@synthesize tiny = _tiny;
@synthesize pre = _pre;

+ (BOOL)autoLoad
{
    [LionVersion sharedInstance];
    
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        NSArray * array = [LION_VERSION componentsSeparatedByString:@" "];
        if ( array.count > 0 )
        {
            if ( array.count > 1 )
            {
                _pre = [[array objectAtIndex:1] retain];
            }
            else
            {
                _pre = [@"" retain];
            }
            
            NSArray * subvers = [[array objectAtIndex:0] componentsSeparatedByString:@"."];
            if ( subvers.count >= 1 )
            {
                _major = [[subvers objectAtIndex:0] intValue];
            }
            if ( subvers.count >= 2 )
            {
                _minor = [[subvers objectAtIndex:1] intValue];
            }
            if ( subvers.count >= 3 )
            {
                _tiny = [[subvers objectAtIndex:2] intValue];
            }
        }
    }
    return self;
}

- (void)dealloc
{
    [_pre release];
    
    [super dealloc];
}

@end
