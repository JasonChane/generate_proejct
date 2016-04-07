//
//  Lion_HTTPWorklet2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPWorkflow2.h"
#import "Lion_HTTPConnection2.h"
#import "Lion_HTTPConnectionPool2.h"

#pragma mark -

@interface LionHTTPWorklet2 : NSObject

@property (nonatomic, assign) NSUInteger	prio;
@property (nonatomic, retain) NSString *	name;

+ (LionHTTPWorklet2 *)worklet;
+ (LionHTTPWorklet2 *)worklet:(NSString *)name;

- (BOOL)processWithWorkflow:(LionHTTPWorkflow2 *)flow;

@end