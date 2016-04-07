//
//  Lion_Keychain.m
//  generate
//
//  Created by guang on 15/4/21.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Keychain.h"
#import "Lion_SystemInfo.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

//DEF_PACKAGE( LionPackage_System, LionKeychain, keychain );

#pragma mark -

#undef	DEFAULT_DOMAIN
#define DEFAULT_DOMAIN	@"LionKeychain"

#pragma mark -

@interface LionKeychain()
{
    NSString *	_defaultDomain;
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain;
- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain;

@end

#pragma mark -

@implementation LionKeychain

DEF_SINGLETON( LionKeychain )

@synthesize defaultDomain = _defaultDomain;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.defaultDomain = DEFAULT_DOMAIN;
    }
    return self;
}

- (void)dealloc
{
    self.defaultDomain = nil;
    
    [super dealloc];
}

+ (void)setDefaultDomain:(NSString *)domain
{
    [[LionKeychain sharedInstance] setDefaultDomain:domain];
}

+ (NSString *)readValueForKey:(NSString *)key
{
    return [[LionKeychain sharedInstance] readValueForKey:key andDomain:nil];
}

+ (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    return [[LionKeychain sharedInstance] readValueForKey:key andDomain:domain];
}

- (NSString *)readValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return nil;
    
    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;
        
        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }
    
    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }
    
    domain = [domain stringByAppendingString:[LionSystemInfo appIdentifier]];
    
    NSArray * keys = [[[NSArray alloc] initWithObjects: (NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil] autorelease];
    NSArray * objects = [[[NSArray alloc] initWithObjects: (NSString *) kSecClassGenericPassword, key, domain, nil] autorelease];
    
    NSMutableDictionary * query = [[[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
    NSMutableDictionary * attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(id) kSecReturnAttributes];
    
    NSDictionary * attributeResult = NULL;
    OSStatus status = SecItemCopyMatching( (CFDictionaryRef)attributeQuery, (CFTypeRef *)&attributeResult );
    
    [attributeResult release];
    [attributeQuery release];
    
    if ( noErr != status )
        return nil;
    
    NSMutableDictionary * passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    
    NSData * resultData = nil;
    status = SecItemCopyMatching( (CFDictionaryRef)passwordQuery, (CFTypeRef *)&resultData );
    
    [resultData autorelease];
    [passwordQuery release];
    
    if ( noErr != status )
        return nil;
    
    if ( nil == resultData )
        return nil;
    
    NSString * password = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    return [password autorelease];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key
{
    [[LionKeychain sharedInstance] writeValue:value forKey:key andDomain:nil];
}

+ (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain
{
    [[LionKeychain sharedInstance] writeValue:value forKey:key andDomain:domain];
}

- (void)writeValue:(NSString *)value forKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return;
    
    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;
        
        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }
    
    if ( nil == value )
    {
        value = @"";
    }
    
    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }
    
    domain = [domain stringByAppendingString:[LionSystemInfo appIdentifier]];
    
    OSStatus status = 0;
    
    NSString * password = [LionKeychain readValueForKey:key andDomain:domain];
    if ( password )
    {
        if ( [password isEqualToString:value] )
            return;
        
        NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, nil] autorelease];
        NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, nil] autorelease];
        
        NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
        status = SecItemUpdate( (CFDictionaryRef)query, (CFDictionaryRef)[NSDictionary dictionaryWithObject:[value dataUsingEncoding:NSUTF8StringEncoding] forKey:(NSString *)kSecValueData] );
    }
    else
    {
        NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrService, kSecAttrLabel, kSecAttrAccount, kSecValueData, nil] autorelease];
        NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, domain, domain, key, [value dataUsingEncoding:NSUTF8StringEncoding], nil] autorelease];
        
        NSDictionary * query = [[[NSDictionary alloc] initWithObjects: objects forKeys: keys] autorelease];
        status = SecItemAdd( (CFDictionaryRef)query, NULL);
    }
    
    if ( noErr != status )
    {
        ERROR( @"writeValue, status = %d", status );
    }
}

+ (void)deleteValueForKey:(NSString *)key
{
    [[LionKeychain sharedInstance] deleteValueForKey:key andDomain:nil];
}

+ (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    [[LionKeychain sharedInstance] deleteValueForKey:key andDomain:domain];
}

- (void)deleteValueForKey:(NSString *)key andDomain:(NSString *)domain
{
    if ( nil == key )
        return;
    
    if ( NSNotFound != [key rangeOfString:@"/" options:NSCaseInsensitiveSearch].location )
    {
        NSUInteger	offset = 0;
        
        domain	= [key substringFromIndex:0 untilCharset:[NSCharacterSet characterSetWithCharactersInString:@"/"] endOffset:&offset];
        key		= [key substringFromIndex:offset];
    }
    
    if ( nil == domain )
    {
        domain = self.defaultDomain;
        if ( nil == domain )
        {
            domain = DEFAULT_DOMAIN;
        }
    }
    
    domain = [domain stringByAppendingString:[LionSystemInfo appIdentifier]];
    
    NSArray * keys = [[[NSArray alloc] initWithObjects:(NSString *)kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil] autorelease];
    NSArray * objects = [[[NSArray alloc] initWithObjects:(NSString *)kSecClassGenericPassword, key, domain, kCFBooleanTrue, nil] autorelease];
    
    NSDictionary * query = [[[NSDictionary alloc] initWithObjects:objects forKeys:keys] autorelease];
    SecItemDelete( (CFDictionaryRef)query );
}

- (BOOL)hasObjectForKey:(id)key
{
    id obj = [self readValueForKey:key andDomain:nil];
    return obj ? YES : NO;
}

- (id)objectForKey:(id)key
{
    return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)object forKey:(id)key
{
    [self writeValue:object forKey:key andDomain:nil];
}

- (void)removeObjectForKey:(id)key
{
    [self deleteValueForKey:key andDomain:nil];
}

- (void)removeAllObjects
{
    // TODO:
}

- (id)objectForKeyedSubscript:(id)key
{
    if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
        return nil;
    
    return [self readValueForKey:key andDomain:nil];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
    if ( nil == key || NO == [key isKindOfClass:[NSString class]] )
        return;
    
    if ( nil == obj )
    {
        [self deleteValueForKey:key andDomain:nil];
    }
    else
    {
        [self writeValue:obj forKey:key andDomain:nil];
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__

TEST_CASE( BeeKeychain )
{
    // TODO:
}
TEST_CASE_END

#endif	// #if defined(__BEE_UNITTEST__) && __BEE_UNITTEST__


