//
//  ProcessingLog.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "ProcessingLog.h"

#pragma mark -

@implementation ProcessingLog

- (void)load
{
    self.prio = 100;
}

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)flow
{
    INFO( @"path = %@", flow.connection.request.resource );
    
    return YES;
}

@end
