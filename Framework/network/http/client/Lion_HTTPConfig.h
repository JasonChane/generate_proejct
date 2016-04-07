//
//  Lion_HTTPConfig.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPPackage.h"

#pragma mark -

AS_PACKAGE( LionPackage_HTTP, LionHTTPConfig, config );

#pragma mark -

@interface LionHTTPConfig : NSObject

AS_SINGLETON( LionHTTPConfig )

@property (nonatomic, assign) NSUInteger	concurrentForWIFI;
@property (nonatomic, assign) NSUInteger	concurrentForWLAN;
@property (nonatomic, retain) NSString *	userAgent;

@end
