//
//  Lion_Language.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

@interface LionLanguage : NSObject

@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSMutableDictionary *	strings;

+ (LionLanguage *)language;
+ (LionLanguage *)language:(id)data;

- (void)addString:(NSString *)string forName:(NSString *)name;
- (NSString *)stringWithName:(NSString *)name;
- (NSString *)stringWithCstr:(const char *)name;

@end
