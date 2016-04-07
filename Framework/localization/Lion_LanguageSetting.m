//
//  Lion_LanguageSetting.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_LanguageSetting.h"

#pragma mark -

@interface LionLanguageSetting()
{
    LionLanguage *		_current;
    NSMutableArray *	_languages;
}

- (LionLanguage *)currentLanguage;
- (LionLanguage *)findLanguage:(NSString *)name;
- (void)applyLanguage:(LionLanguage *)lang;

@end

#pragma mark -

@implementation LionLanguageSetting

@dynamic name;

DEF_SINGLETON( LionLanguageSetting )

DEF_NOTIFICATION( CHANGED )

+ (BOOL)autoLoad
{
    [LionLanguageSetting setSystemLanguage];
    return YES;
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _current = nil;
        _languages = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_languages removeAllObjects];
    [_languages release];
    
    [super dealloc];
}

- (NSString *)name
{
    LionLanguage * lang = [self currentLanguage];
    if ( lang )
    {
        return lang.name;
    }
    
    return nil;
}

- (void)setName:(NSString *)n
{
    if ( n && n.length )
    {
        [self setCurrentLanguageName:n];
    }
    else
    {
        [self setSystemLanguage];
    }
}

- (LionLanguage *)findLanguage:(NSString *)name
{
    for ( LionLanguage * lang in _languages )
    {
        if ( [lang.name isEqualToString:name] )
        {
            return lang;
        }
    }
    
    return nil;
}

- (void)applyLanguage:(LionLanguage *)lang
{
    BOOL shouldNotify = _current ? YES : NO;
    
    LionLanguage * lang2 = [self findLanguage:lang.name];
    if ( nil == lang2 )
    {
        [_languages addObject:lang];
    }
    
    _current = lang;
    
    if ( shouldNotify )
    {
        [self postNotification:self.CHANGED];
    }
}

+ (LionLanguage *)currentLanguage
{
    return [[LionLanguageSetting sharedInstance] currentLanguage];
}

- (LionLanguage *)currentLanguage
{
    return _current;
}

+ (BOOL)setCurrentLanguage:(LionLanguage *)lang
{
    return [[LionLanguageSetting sharedInstance] setCurrentLanguage:lang];
}

- (BOOL)setCurrentLanguage:(LionLanguage *)lang
{
    if ( nil == lang )
        return NO;
    
    [self applyLanguage:lang];
    return YES;
}

+ (BOOL)setCurrentLanguageName:(NSString *)name
{
    return [[LionLanguageSetting sharedInstance] setCurrentLanguageName:name];
}

- (BOOL)setCurrentLanguageName:(NSString *)name
{
    LionLanguage * lang = [self findLanguage:name];
    if ( nil == lang )
    {
        NSString * langPath = [[NSBundle mainBundle] pathForResource:name ofType:@"xml"];
        NSString * langPath2 = [[NSBundle mainBundle] pathForResource:name ofType:@"lang"];
        
        NSString * content = [NSString stringWithContentsOfFile:langPath encoding:NSUTF8StringEncoding error:NULL];
        if ( nil == content )
        {
            content = [NSString stringWithContentsOfFile:langPath2 encoding:NSUTF8StringEncoding error:NULL];
        }
        
        if ( content )
        {
            lang = [LionLanguage language:content];
        }
    }
    
    if ( lang )
    {
        lang.name = name;
        
        [self applyLanguage:lang];
        return YES;
    }
    
    return NO;
}

+ (BOOL)setSystemLanguage
{
    return [[LionLanguageSetting sharedInstance] setSystemLanguage];
}

- (BOOL)setSystemLanguage
{
    BOOL succeed = NO;
    
    NSString * langName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    if ( langName )
    {
        succeed = [self setCurrentLanguageName:langName];
    }
    
    if ( NO == succeed )
    {
        succeed = [self setCurrentLanguageName:@"en-us"];
        if ( NO == succeed )
        {
            succeed = [self setCurrentLanguageName:@"default"];
        }
    }
    
    return succeed;
}

+ (NSString *)stringWithName:(NSString *)name
{
    return [[LionLanguageSetting sharedInstance] stringWithName:name];
}

- (NSString *)stringWithName:(NSString *)name
{
    if ( nil == name || 0 == name.length )
        return nil;
    
    LionLanguage * lang = [LionLanguageSetting currentLanguage];
    if ( lang )
    {
        NSString * text = [lang stringWithName:name];
        if ( text )
        {
            return  text;
        }
    }
    
    return NSLocalizedString( name, name );
}

@end
