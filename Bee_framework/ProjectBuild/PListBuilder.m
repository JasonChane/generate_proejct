//
//  PListBuilder.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/11.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PListBuilder.h"
#import "NSString+LionExtension.h"
#import "PBXNode.h"

@implementation PListBuilder

+ (NSString *)wrapString:(NSString *)string
{
    if ( nil == string || 0 == string.length )
        return nil;
    
    if ( NSNotFound != [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\t @+-=<>()[]"]].location )
    {
        return [NSString stringWithFormat:@"\"%@\"", string];
    }
    
    return string;
}

+ (NSString *)objectToString:(id)obj indent:(int)indent
{
    return [self objectToString:obj indent:indent key:nil];
}

+ (NSString *)objectToString:(id)obj indent:(int)indent key:(NSString *)parentKey
{
    NSMutableString *	content = [NSMutableString string];
    NSString *			prefix = [@"\t" repeat:indent];
    
    if ( [obj isKindOfClass:[PBXNode class]] )
    {
        content.APPEND( prefix );
        content.APPEND( @"%@ = {\n", [(PBXNode *)obj key] );
        
        Class classType = [obj class];
        
        for ( ;; )
        {
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( classType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                NSString *	name = [NSString stringWithUTF8String:property_getName(properties[i])];
                id			value = [obj valueForKey:name];
                
                if ( nil == value )
                    continue;
                
                if ( [value isKindOfClass:[PBXNode class]] )
                {
                    content.APPEND( prefix );
                    content.APPEND( @"%@", [self objectToString:value indent:indent + 1] );
                }
                else if ( [value isKindOfClass:[NSNumber class]] )
                {
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @"%@ = %@;\n", name, value );
                }
                else if ( [value isKindOfClass:[NSString class]] )
                {
                    if ( 0 == [(NSString *)value length] || NSNotFound != [value rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@" @+-=<>()[]"]].location )
                    {
                        content.APPEND( prefix );
                        content.APPEND( @"\t" );
                        content.APPEND( @"%@ = \"%@\";\n", name, value );
                    }
                    else
                    {
                        content.APPEND( prefix );
                        content.APPEND( @"\t" );
                        content.APPEND( @"%@ = %@;\n", name, value );
                    }
                }
                else if ( [value isKindOfClass:[NSArray class]] )
                {
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @"%@ = (\n", name );
                    
                    for ( id subVal in (NSArray *)value )
                    {
                        content.APPEND( prefix );
                        //	content.APPEND( @"\t" );
                        content.APPEND( @"%@,\n", [self objectToString:subVal indent:indent] );
                    }
                    
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @");\n" );
                }
                else if ( [value isKindOfClass:[NSDictionary class]] )
                {
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @"%@ = {\n", name );
                    
                    for ( NSString * key in (NSDictionary *)value )
                    {
                        id subVal = [(NSDictionary *)value objectForKey:key];
                        
                        content.APPEND( prefix );
                        //	content.APPEND( @"\t" );
                        content.APPEND( @"%@;\n", [self objectToString:subVal indent:indent key:key] );
                    }
                    
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @"};\n" );
                }
                else
                {
                    content.APPEND( prefix );
                    content.APPEND( @"\t" );
                    content.APPEND( @"%@;\n", [self objectToString:value indent:indent] );
                }
            }
            
            free( properties );
            
            classType = class_getSuperclass( classType );
            if ( nil == classType || classType == [NSObject class] || classType == [PBXNode class] )
                break;
        }
        
        content.APPEND( prefix );
        content.APPEND( @"};\n" );
    }
    else
    {
        content.APPEND( prefix );
        
        if ( parentKey )
        {
            content.APPEND( @"%@ = ", [self wrapString:parentKey] );
        }
        
        if ( [obj isKindOfClass:[NSNumber class]] )
        {
            content.APPEND( @"%@", obj );
        }
        else if ( [obj isKindOfClass:[NSString class]] )
        {
            content.APPEND( @"%@", [self wrapString:obj] );
        }
        else if ( [obj isKindOfClass:[NSArray class]] )
        {
            content.APPEND( @"(\n" );
            
            for ( id subVal in (NSArray *)obj )
            {
                content.APPEND( prefix );
                content.APPEND( @"%@,\n", [self objectToString:subVal indent:indent + 1] );
            }
            
            content.APPEND( prefix );
            content.APPEND( @"\t" );
            content.APPEND( @")" );
        }
        else if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            content.APPEND( @"{\n" );
            
            for ( NSString * key in (NSDictionary *)obj )
            {
                id subVal = [(NSDictionary *)obj objectForKey:key];
                
                content.APPEND( prefix );
                content.APPEND( @"%@ = %@;\n", [self wrapString:key], [self objectToString:subVal indent:indent + 1] );
            }
            
            content.APPEND( prefix );
            content.APPEND( @"\t" );
            content.APPEND( @"}" );
        }
    }
    
    return content;
}

@end
