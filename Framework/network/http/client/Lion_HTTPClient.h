//
//  Lion_HTTPClient.h
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

AS_PACKAGE( LionPackage_HTTP, LionHTTPClient, client );

#pragma mark -

@interface LionHTTPClient : NSObject

AS_SINGLETON( LionHTTPClient )

@end