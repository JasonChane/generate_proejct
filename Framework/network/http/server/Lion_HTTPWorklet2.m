//
//  Lion_HTTPWorklet2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPWorklet2.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPServerConfig2.h"
#import "Lion_HTTPServerRouter2.h"

#import "Lion_Reachability.h"

#pragma mark -

@implementation LionHTTPWorklet2

@synthesize prio = _prio;
@synthesize name = _name;

+ (LionHTTPWorklet2 *)worklet
{
    return [self worklet:nil];
}

+ (LionHTTPWorklet2 *)worklet:(NSString *)name
{
    LionHTTPWorklet2 * worklet = [[[self alloc] init] autorelease];
    if ( worklet )
    {
        if ( name )
        {
            worklet.name = name;
        }
    }
    return worklet;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.prio = 0;
        self.name = [[self class] description];
        
        [self performLoad];
    }
    return self;
}

- (void)dealloc
{
    [self performUnload];
    
    self.name = nil;
    
    [super dealloc];
}

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)flow
{
    return YES;
}

@end
