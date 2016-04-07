//
//  Lion_Version.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Singleton.h"

#pragma mark -

AS_PACKAGE( LionPackage, LionVersion, ver );

#pragma mark -

@interface LionVersion : NSObject

AS_SINGLETON( LionVersion )

@property (nonatomic, readonly) NSUInteger	major;
@property (nonatomic, readonly) NSUInteger	minor;
@property (nonatomic, readonly) NSUInteger	tiny;
@property (nonatomic, readonly) NSString *	pre;

@end

