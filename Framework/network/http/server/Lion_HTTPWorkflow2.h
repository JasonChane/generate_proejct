//
//  Lion_HTTPWorkflow2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPConnection2.h"

#pragma mark -

@interface LionHTTPWorkflow2 : NSObject

@property (nonatomic, retain) NSMutableArray *		worklets;
@property (nonatomic, assign) LionHTTPConnection2 *	connection;

+ (LionHTTPWorkflow2 *)processingWorkflow;

+ (BOOL)process:(LionHTTPConnection2 *)conn;
- (BOOL)process;

@end