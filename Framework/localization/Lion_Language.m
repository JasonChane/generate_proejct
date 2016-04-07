//
//  Lion_Language.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Language.h"

#pragma mark -

@interface LionLanguage()
{
    NSString *				_name;
    NSMutableDictionary *	_strings;
}

- (BOOL)parseData:(NSData *)data;
- (BOOL)parseText:(NSString *)text;

@end

#pragma mark -

@implementation LionLanguage

@synthesize name = _name;
@synthesize strings = _strings;

- (id)init
{
    self = [super init];
    if ( self )
    {
        self.name = nil;
        self.strings = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)dealloc
{
    [_name release];
    
    [_strings removeAllObjects];
    [_strings release];
    
    [super dealloc];
}

- (void)addString:(NSString *)string forName:(NSString *)name
{
    if ( nil == string || nil == name )
        return;
    
    [_strings setObject:string forKey:name];
}

- (NSString *)stringWithName:(NSString *)name
{
    if ( nil == _strings )
    {
        return nil; // name;
    }
    
    NSString * result = [_strings objectForKey:name];
    if ( nil == result )
    {
        return nil; // name;
    }
    
    return result;
}

- (NSString *)stringWithCstr:(const char *)name
{
    if ( nil == _strings )
        return nil;
    
    return [_strings objectForKey:[NSString stringWithUTF8String:name]];
}

#pragma mark -

- (void)parseString:(CXMLElement *)elem
{
    NSString *	stringName = [[elem attributeForName:@"name"] stringValue];
    NSString *	stringContent = nil;
    
    for ( CXMLElement * child in elem.children )
    {
        if ( child.kind == CXMLTextKind )
        {
            stringContent = child.stringValue;
        }
    }
    
    if ( stringName && stringContent )
    {
        [_strings setObject:stringContent forKey:stringName];
    }
}

- (void)parseResource:(CXMLElement *)elem
{
    for ( CXMLElement * child in elem.children )
    {
        if ( child.kind == CXMLElementKind )
        {
            [self parseString:child];
        }
    }
}

- (void)parseElement:(CXMLElement *)elem
{
    if ( [elem.name matchAnyOf:@[@"resources"]] )
    {
        [self parseResource:elem];
    }
    else if ( [elem.name matchAnyOf:@[@"string"]] )
    {
        [self parseString:elem];
    }
}

#pragma mark -

- (BOOL)parseData:(NSData *)data
{
    if ( nil == data )
        return NO;
    
    NSError * error = nil;
    CXMLDocument * doc = [[[CXMLDocument alloc] initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error] autorelease];
    if ( nil == doc )
    {
        ERROR( @"Failed to open XML document" );
        return NO;
    }
    
    CXMLElement * root = doc.rootElement;
    if ( nil == root )
    {
        ERROR( @"Root node not found" );
        return NO;
    }
    
    [self parseElement:root];
    
    return YES;
}

- (BOOL)parseText:(NSString *)text
{
    return [self parseData:[text asNSData]];
}

+ (LionLanguage *)language
{
    return [[[LionLanguage alloc] init] autorelease];
}

+ (LionLanguage *)language:(id)data
{
    LionLanguage * lang = [[[LionLanguage alloc] init] autorelease];
    if ( lang )
    {
        if ( [data isKindOfClass:[NSData class]] )
        {
            [lang parseData:(NSData *)data];
        }
        else if ( [data isKindOfClass:[NSString class]] )
        {
            [lang parseText:(NSString *)data];
        }
    }
    
    return lang;
}

@end
