//
//  Lion_LanguageSetting.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Language.h"

#pragma mark -

#undef	__TEXT
#define __TEXT( __x )	[[LionLanguageSetting currentLanguage] stringWithName:(__x)]

#pragma mark -

@interface LionLanguageSetting : NSObject

AS_SINGLETON( LionLanguageSetting )

AS_NOTIFICATION( CHANGED )

@property (nonatomic, retain) NSString *	name;

+ (LionLanguage *)currentLanguage;
- (LionLanguage *)currentLanguage;

+ (BOOL)setCurrentLanguage:(LionLanguage *)lang;
- (BOOL)setCurrentLanguage:(LionLanguage *)lang;

+ (BOOL)setCurrentLanguageName:(NSString *)name;
- (BOOL)setCurrentLanguageName:(NSString *)name;

+ (BOOL)setSystemLanguage;
- (BOOL)setSystemLanguage;

+ (NSString *)stringWithName:(NSString *)name;
- (NSString *)stringWithName:(NSString *)name;

@end
