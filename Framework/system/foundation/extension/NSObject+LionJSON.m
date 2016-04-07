//
//  NSObject+LionJSON.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+LionJSON.h"

#import "Lion_UnitTest.h"
#import "Lion_Runtime.h"
#import "NSObject+LionTypeConversion.h"
#import "NSDictionary+LionExtension.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionJSON)

+ (id)objectsFromArray:(id)arr
{
    if ( nil == arr )
        return nil;
    
    if ( NO == [arr isKindOfClass:[NSArray class]] )
        return nil;
    
    NSMutableArray * results = [NSMutableArray array];
    
    for ( NSObject * obj in (NSArray *)arr )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            obj = [self objectFromDictionary:obj];
            if ( obj )
            {
                [results addObject:obj];
            }
        }
        else
        {
            [results addObject:obj];
        }
    }
    
    return results;
}

+ (id)objectsFromAny:(id)any
{
    if ( nil == any )
    {
        return nil;
    }
    
    if ( [any isKindOfClass:[NSArray class]] )
    {
        return [self objectsFromArray:any];
    }
    else if ( [any isKindOfClass:[NSDictionary class]] )
    {
        id obj = [self objectFromDictionary:any];
        if ( nil == obj )
            return nil;
        
        if ( [obj isKindOfClass:[NSArray class]] )
        {
            return obj;
        }
        else
        {
            return [NSArray arrayWithObject:obj];
        }
    }
    else if ( [any isKindOfClass:[NSString class]] )
    {
        id obj = [self objectFromString:any];
        if ( nil == obj )
            return nil;
        
        if ( [obj isKindOfClass:[NSArray class]] )
        {
            return obj;
        }
        else
        {
            return [NSArray arrayWithObject:obj];
        }
    }
    else if ( [any isKindOfClass:[NSData class]] )
    {
        id obj = [self objectFromData:any];
        if ( nil == obj )
            return nil;
        
        if ( [obj isKindOfClass:[NSArray class]] )
        {
            return obj;
        }
        else
        {
            return [NSArray arrayWithObject:obj];
        }
    }
    else
    {
        return [NSArray arrayWithObject:any];
    }
}

+ (id)objectFromDictionary:(id)dict
{
    if ( nil == dict )
    {
        return nil;
    }
    
    if ( NO == [dict isKindOfClass:[NSDictionary class]] )
    {
        return nil;
    }
    
    return [(NSDictionary *)dict objectForClass:[self class]];
}

+ (id)objectFromString:(id)str
{
    if ( nil == str )
    {
        return nil;
    }
    
    if ( NO == [str isKindOfClass:[NSString class]] )
    {
        return nil;
    }
    NSError * error = nil;
    NSObject * obj = [(NSString *)str objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
    
    if ( nil == obj )
    {
        ERROR( @"%@", error );
        return nil;
    }
    
    if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return [(NSDictionary *)obj objectForClass:[self class]];
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)obj )
        {
            if ( [elem isKindOfClass:[NSDictionary class]] )
            {
                NSObject * result = [(NSDictionary *)elem objectForClass:[self class]];
                if ( result )
                {
                    [array addObject:result];
                }
            }
        }
        
        return array;
    }
    else if ( [LionTypeEncoding isAtomClass:[obj class]] )
    {
        return obj;
    }
    
    return nil;
}

+ (id)objectFromData:(id)data
{
    if ( nil == data )
    {
        return nil;
    }
    
    if ( NO == [data isKindOfClass:[NSData class]] )
    {
        return nil;
    }
    
    NSObject * obj = [(NSData *)data objectFromJSONData];
    if ( obj )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            return [(NSDictionary *)obj objectForClass:[self class]];
        }
        else if ( [obj isKindOfClass:[NSArray class]] )
        {
            return [self objectsFromAny:obj];
        }
    }
    
    return nil;
}

+ (id)objectFromAny:(id)any
{
    if ( [any isKindOfClass:[NSArray class]] )
    {
        return [self objectsFromArray:any];
    }
    else if ( [any isKindOfClass:[NSDictionary class]] )
    {
        return [self objectFromDictionary:any];
    }
    else if ( [any isKindOfClass:[NSString class]] )
    {
        return [self objectFromString:any];
    }
    else if ( [any isKindOfClass:[NSData class]] )
    {
        return [self objectFromData:any];
    }
    
    return any;
}

- (id)objectToDictionary
{
    return [self objectToDictionaryUntilRootClass:nil];
}

- (id)objectToDictionaryUntilRootClass:(Class)rootClass
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    if ( [self isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary * dict = (NSDictionary *)self;
        
        for ( NSString * key in dict.allKeys )
        {
            NSObject * obj = [dict objectForKey:key];
            if ( obj )
            {
                NSUInteger propertyType = [LionTypeEncoding typeOfObject:obj];
                if ( LionTypeEncoding.NSNUMBER == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( LionTypeEncoding.NSSTRING == propertyType )
                {
                    [result setObject:obj forKey:key];
                }
                else if ( LionTypeEncoding.NSARRAY == propertyType )
                {
                    NSMutableArray * array = [NSMutableArray array];
                    
                    for ( NSObject * elem in (NSArray *)obj )
                    {
                        NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                        if ( dict )
                        {
                            [array addObject:dict];
                        }
                        else
                        {
                            if ( [LionTypeEncoding isAtomClass:[elem class]] )
                            {
                                [array addObject:elem];
                            }
                        }
                    }
                    
                    [result setObject:array forKey:key];
                }
                else if ( LionTypeEncoding.NSDICTIONARY == propertyType )
                {
                    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                    
                    for ( NSString * key in ((NSDictionary *)obj).allKeys )
                    {
                        NSObject * val = [(NSDictionary *)obj objectForKey:key];
                        if ( val )
                        {
                            NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                            if ( subresult )
                            {
                                [dict setObject:subresult forKey:key];
                            }
                            else
                            {
                                if ( [LionTypeEncoding isAtomClass:[val class]] )
                                {
                                    [dict setObject:val forKey:key];
                                }
                            }
                        }
                    }
                    
                    [result setObject:dict forKey:key];
                }
                else if ( LionTypeEncoding.NSDATE == propertyType )
                {
                    [result setObject:[obj description] forKey:key];
                }
                else
                {
                    obj = [obj objectToDictionaryUntilRootClass:rootClass];
                    if ( obj )
                    {
                        [result setObject:obj forKey:key];
                    }
                    else
                    {
                        [result setObject:[NSDictionary dictionary] forKey:key];
                    }
                }
            }
            //			else
            //			{
            //				[result setObject:[NSNull null] forKey:key];
            //			}
        }
    }
    else
    {
        for ( Class clazzType = [self class];; )
        {
            if ( rootClass )
            {
                if ( clazzType == rootClass )
                    break;
            }
            else
            {
                if ( [LionTypeEncoding isAtomClass:clazzType] )
                    break;
            }
            
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                const char *	attr = property_getAttributes(properties[i]);
                
                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                NSUInteger		propertyType = [LionTypeEncoding typeOf:attr];
                
                NSObject * obj = [self valueForKey:propertyName];
                if ( obj )
                {
                    if ( LionTypeEncoding.NSNUMBER == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( LionTypeEncoding.NSSTRING == propertyType )
                    {
                        [result setObject:obj forKey:propertyName];
                    }
                    else if ( LionTypeEncoding.NSARRAY == propertyType )
                    {
                        NSMutableArray * array = [NSMutableArray array];
                        
                        for ( NSObject * elem in (NSArray *)obj )
                        {
                            NSUInteger elemType = [LionTypeEncoding typeOfObject:elem];
                            
                            if ( LionTypeEncoding.NSNUMBER == elemType )
                            {
                                [array addObject:elem];
                            }
                            else if ( LionTypeEncoding.NSSTRING == elemType )
                            {
                                [array addObject:elem];
                            }
                            else
                            {
                                NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
                                if ( dict )
                                {
                                    [array addObject:dict];
                                }
                                else
                                {
                                    if ( [LionTypeEncoding isAtomClass:[elem class]] )
                                    {
                                        [array addObject:elem];
                                    }
                                }
                            }
                        }
                        
                        [result setObject:array forKey:propertyName];
                    }
                    else if ( LionTypeEncoding.NSDICTIONARY == propertyType )
                    {
                        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                        
                        for ( NSString * key in ((NSDictionary *)obj).allKeys )
                        {
                            NSObject * val = [(NSDictionary *)obj objectForKey:key];
                            if ( val )
                            {
                                NSDictionary * subresult = [val objectToDictionaryUntilRootClass:rootClass];
                                if ( subresult )
                                {
                                    [dict setObject:subresult forKey:key];
                                }
                                else
                                {
                                    if ( [LionTypeEncoding isAtomClass:[val class]] )
                                    {
                                        [dict setObject:val forKey:key];
                                    }
                                }
                            }
                        }
                        
                        [result setObject:dict forKey:propertyName];
                    }
                    else if ( LionTypeEncoding.NSDATE == propertyType )
                    {
                        [result setObject:[obj description] forKey:propertyName];
                    }
                    else
                    {
                        obj = [obj objectToDictionaryUntilRootClass:rootClass];
                        if ( obj )
                        {
                            [result setObject:obj forKey:propertyName];
                        }
                        else
                        {
                            [result setObject:[NSDictionary dictionary] forKey:propertyName];
                        }
                    }
                }
                //				else
                //				{
                //					[result setObject:[NSNull null] forKey:propertyName];
                //				}
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }
    
    return result.count ? result : nil;
}

- (id)objectZerolize
{
    return [self objectZerolizeUntilRootClass:nil];
}

- (id)objectZerolizeUntilRootClass:(Class)rootClass
{
    for ( Class clazzType = [self class];; )
    {
        if ( rootClass )
        {
            if ( clazzType == rootClass )
                break;
        }
        else
        {
            if ( [LionTypeEncoding isAtomClass:clazzType] )
                break;
        }
        
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            const char *	attr = property_getAttributes(properties[i]);
            
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            NSUInteger		propertyType = [LionTypeEncoding typeOfAttribute:attr];
            
            if ( LionTypeEncoding.NSNUMBER == propertyType )
            {
                [self setValue:[NSNumber numberWithInt:0] forKey:propertyName];
            }
            else if ( LionTypeEncoding.NSSTRING == propertyType )
            {
                [self setValue:@"" forKey:propertyName];
            }
            else if ( LionTypeEncoding.NSARRAY == propertyType )
            {
                [self setValue:[NSMutableArray array] forKey:propertyName];
            }
            else if ( LionTypeEncoding.NSDICTIONARY == propertyType )
            {
                [self setValue:[NSMutableDictionary dictionary] forKey:propertyName];
            }
            else if ( LionTypeEncoding.NSDATE == propertyType )
            {
                [self setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:propertyName];
            }
            else if ( LionTypeEncoding.OBJECT == propertyType )
            {
                Class clazz = [LionTypeEncoding classOfAttribute:attr];
                if ( clazz )
                {
                    NSObject * newObj = [[[clazz alloc] init] autorelease];
                    [self setValue:newObj forKey:propertyName];
                }
                else
                {
                    [self setValue:nil forKey:propertyName];
                }
            }
            else
            {
                [self setValue:nil forKey:propertyName];
            }
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
    
    return self;
}

- (id)objectToString
{
    return [self objectToStringUntilRootClass:nil];
}

- (id)objectToStringUntilRootClass:(Class)rootClass
{
    NSString *	json = nil;
    NSUInteger	propertyType = [LionTypeEncoding typeOfObject:self];
    
    if ( LionTypeEncoding.NSNUMBER == propertyType )
    {
        json = [self asNSString];
    }
    else if ( LionTypeEncoding.NSSTRING == propertyType )
    {
        json = [self asNSString];
    }
    else if ( LionTypeEncoding.NSARRAY == propertyType )
    {
        NSMutableArray * array = [NSMutableArray array];
        
        for ( NSObject * elem in (NSArray *)self )
        {
            NSDictionary * dict = [elem objectToDictionaryUntilRootClass:rootClass];
            if ( dict )
            {
                [array addObject:dict];
            }
            else
            {
                if ( [LionTypeEncoding isAtomClass:[elem class]] )
                {
                    [array addObject:elem];
                }
            }
        }
        
        json = [array JSONString];
    }
    else if ( LionTypeEncoding.NSDICTIONARY == propertyType )
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( dict )
        {
            json = [dict JSONString];
        }
    }
    else if ( LionTypeEncoding.NSDATE == propertyType )
    {
        json = [self description];
    }
    else
    {
        NSDictionary * dict = [self objectToDictionaryUntilRootClass:rootClass];
        if ( nil == dict )
        {
            dict = [NSDictionary dictionary];
        }
        
        json = [dict JSONString];
    }
    
    if ( nil == json || 0 == json.length )
        return nil;
    
    return [NSMutableString stringWithString:json];
}

- (id)objectToData
{
    return [self objectToDataUntilRootClass:nil];
}

- (id)objectToDataUntilRootClass:(Class)rootClass
{
    NSString * string = [self objectToStringUntilRootClass:rootClass];
    if ( nil == string )
        return nil;
    
    return [string dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)serializeObject
{
    NSUInteger type = [LionTypeEncoding typeOfObject:self];
    
    if ( LionTypeEncoding.NSNUMBER == type )
    {
        return self;
    }
    else if ( LionTypeEncoding.NSSTRING == type )
    {
        return self;
    }
    else if ( LionTypeEncoding.NSDATE == type )
    {
        return self;
    }
    else if ( LionTypeEncoding.NSARRAY == type )
    {
        NSArray *			array = (NSArray *)self;
        NSMutableArray *	result = [NSMutableArray array];
        
        for ( NSObject * elem in array )
        {
            NSObject * val = [elem serializeObject];
            if ( val )
            {
                [result addObject:val];
            }
        }
        
        return result;
    }
    else if ( LionTypeEncoding.NSDICTIONARY == type )
    {
        NSDictionary *			dict = (NSDictionary *)self;
        NSMutableDictionary *	result = [NSMutableDictionary dictionary];
        
        for ( NSString * key in dict.allKeys )
        {
            NSObject * val = [dict objectForKey:key];
            NSObject * val2 = [val serializeObject];
            
            if ( val2 )
            {
                [result setObject:val2 forKey:key];
            }
        }
        
        return result;
    }
    else if ( LionTypeEncoding.OBJECT == type )
    {
        return [self objectToDictionary];
    }
    
    return nil;
}

+ (id)unserializeObject:(id)obj
{
    NSUInteger type = [LionTypeEncoding typeOfObject:obj];
    
    if ( LionTypeEncoding.NSNUMBER == type )
    {
        return self;
    }
    else if ( LionTypeEncoding.NSSTRING == type )
    {
        return [self objectFromString:obj];
    }
    else if ( LionTypeEncoding.NSDATE == type )
    {
        return self;
    }
    else if ( LionTypeEncoding.NSARRAY == type )
    {
        return [self objectsFromArray:obj];
    }
    else if ( LionTypeEncoding.NSDICTIONARY == type )
    {
        return [self objectFromDictionary:obj];
    }
    else if ( LionTypeEncoding.OBJECT == type )
    {
        return self;
    }
    
    return nil;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionJSON )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
