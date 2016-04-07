//
//  NSBundle+LionExtension.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@interface NSBundle(LionExntension)

@property (nonatomic, readonly) NSString *	fullPath;
@property (nonatomic, readonly) NSString *	pathName;

- (NSData *)data:(NSString *)resName;
- (UIImage *)image:(NSString *)resName;
- (NSString *)string:(NSString *)resName;

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
