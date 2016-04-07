//
//  Lion_HTTPClientConfig.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPPackage.h"
#import "Lion_HTTPClient.h"

#pragma mark -

AS_PACKAGE( LionHTTPClient, LionHTTPClientConfig, config );

#pragma mark -

@interface LionHTTPClientConfig : NSObject

AS_SINGLETON( LionHTTPClientConfig )

@property (nonatomic, assign) NSUInteger	concurrentForWIFI;
@property (nonatomic, assign) NSUInteger	concurrentForWLAN;
@property (nonatomic, retain) NSString *	userAgent;

@end
