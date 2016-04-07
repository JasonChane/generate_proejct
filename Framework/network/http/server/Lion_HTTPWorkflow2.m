//
//  Lion_HTTPWorkflow2.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPWorklet2.h"

#pragma mark -

@interface LionHTTPWorkflow2()
{
    NSMutableArray *		_worklets;
    LionHTTPConnection2 *	_connection;
}
@end

#pragma mark -

@implementation LionHTTPWorkflow2

@synthesize worklets = _worklets;
@synthesize connection = _connection;

static NSMutableArray * __stack = nil;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.connection = nil;
        self.worklets = [NSMutableArray array];
        
        NSArray * workletClasses = [LionRuntime allSubClassesOf:[LionHTTPWorklet2 class]];
        if ( workletClasses && workletClasses.count )
        {
            for ( Class workletClass in workletClasses )
            {
                LionHTTPWorklet2 * worklet = [workletClass worklet];
                if ( worklet )
                {
                    [self.worklets addObject:worklet];
                }
            }
        }
        
        [self.worklets sortUsingComparator:^ NSComparisonResult (id obj1, id obj2) {
            LionHTTPWorklet2 * left = obj1;
            LionHTTPWorklet2 * right = obj2;
            return (left.prio < right.prio) ? NSOrderedAscending : ((left.prio > right.prio) ? NSOrderedDescending : NSOrderedSame);
        }];
        
        [self performLoad];
    }
    return self;
}

- (void)dealloc
{
    [self performUnload];
    
    self.connection = nil;
    self.worklets = nil;
    
    [super dealloc];
}

+ (LionHTTPWorkflow2 *)processingWorkflow
{
    if ( nil == __stack )
    {
        return nil;
    }
    
    return __stack.lastObject;
}

+ (BOOL)process:(LionHTTPConnection2 *)conn
{
    if ( nil == __stack )
    {
        __stack = [NSMutableArray nonRetainingArray];
    }
    
    LionHTTPWorkflow2 * workflow = [[[LionHTTPWorkflow2 alloc] init] autorelease];
    if ( workflow )
    {
        [__stack addObject:workflow];
        
        workflow.connection = conn;
        [workflow process];
        
        [__stack removeLastObject];
    }
    
    return YES;
}

- (BOOL)process
{
    BOOL succeed = NO;
    
    INFO( @"Start workflow" );
    
    for ( LionHTTPWorklet2 * worklet in self.worklets )
    {
        succeed = [worklet processWithWorkflow:self];
        if ( succeed )
        {
            INFO( @"	-> '%@', OK", worklet.name );
        }
        else
        {
            ERROR( @"	-> '%@', FAILED", worklet.name );
        }
    }
    
    INFO( @"End workflow" );
    
    return succeed;
}

@end
