//
//  Lion_MIME2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

@interface LionMIME2 : NSObject

+ (NSString *)text_plain;
+ (NSString *)text_html;
+ (NSString *)octet_stream;

+ (NSString *)fromFileExtension:(NSString *)fileExt;

@end