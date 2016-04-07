//
//  Lion_ActiveBuilder.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_ActiveBuilder.h"
#import "Lion_ActiveObject.h"
#import "Lion_ActiveProtocol.h"

#import "Lion_Database.h"
#import "NSObject+LionDatabase.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface LionActiveBuilder()
{
    NSMutableDictionary * _builtFlags;
}

AS_SINGLETON( LionActiveBuilder )

@end

#pragma mark -

@implementation LionActiveBuilder

DEF_SINGLETON( LionActiveBuilder )

+ (void)load
{
    [LionActiveBuilder sharedInstance];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        _builtFlags = [[NSMutableDictionary alloc] init];
        
        [self observeNotification:LionDatabase.SHARED_DB_OPEN];
        [self observeNotification:LionDatabase.SHARED_DB_CLOSE];
    }
    return self;
}

- (void)dealloc
{
    [self unobserveAllNotifications];
    
    [_builtFlags release];
    
    [super dealloc];
}

+ (void)buildTableFor:(Class)clazz
{
    [[LionActiveBuilder sharedInstance] buildTableFor:clazz untilRootClass:[NSObject class]];
}

+ (void)buildTableFor:(Class)clazz untilRootClass:(Class)rootClass
{
    [[LionActiveBuilder sharedInstance] buildTableFor:clazz untilRootClass:rootClass];
}

- (void)buildTableFor:(Class)clazz untilRootClass:(Class)rootClass
{
    NSString * className = [clazz description];
    NSNumber * builtFlag = [_builtFlags objectForKey:className];
    if ( builtFlag && builtFlag.boolValue )
        return;
    
    // Step1, map relation between property and field
    
    [clazz mapRelation];
    
    // Step2, create table
    
    [NSObject DB].TABLE( clazz.tableName );
    [NSObject DB].FIELD( clazz.activePrimaryKey, @"INTEGER" ).UNIQUE().PRIMARY_KEY();
    
    if ( [clazz usingAutoIncrement] )
    {
        [NSObject DB].AUTO_INREMENT();
    }
    
    if ( [clazz usingJSON] )
    {
        [NSObject DB]
        .TABLE( clazz.tableName )
        .FIELD( clazz.activeJSONKey, @"TEXT" ).DEFAULT( @"" );
    }
    
    NSDictionary * propertySet = clazz.activePropertySet;
    if ( propertySet && propertySet.count )
    {
        for ( Class clazzType = clazz; clazzType != rootClass; )
        {
            unsigned int		propertyCount = 0;
            objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
            
            for ( NSUInteger i = 0; i < propertyCount; i++ )
            {
                const char *	name = property_getName(properties[i]);
                NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                
                NSMutableDictionary * property = [propertySet objectForKey:propertyName];
                if ( property )
                {
                    const char *	attr = property_getAttributes(properties[i]);
                    NSUInteger		type = [LionTypeEncoding typeOf:attr];
                    
                    NSString *		field = [property objectForKey:@"field"];
                    NSObject *		value = [property objectForKey:@"value"];
                    
                    if ( LionTypeEncoding.NSNUMBER == type )
                    {
                        [NSObject DB].FIELD( field, @"INTEGER" );
                    }
                    else if ( LionTypeEncoding.NSSTRING == type )
                    {
                        [NSObject DB].FIELD( field, @"TEXT" );
                    }
                    else if ( LionTypeEncoding.NSDATE == type )
                    {
                        [NSObject DB].FIELD( field, @"TEXT" );
                    }
                    else if ( LionTypeEncoding.NSDICTIONARY == type )
                    {
                        [NSObject DB].FIELD( field, @"TEXT" );			// save as JSON
                    }
                    else if ( LionTypeEncoding.NSARRAY == type )
                    {
                        [NSObject DB].FIELD( field, @"TEXT" );			// save as "id,id,id" or JSON
                    }
                    else if ( LionTypeEncoding.OBJECT == type )
                    {
                        Class fieldClass = [LionTypeEncoding classOfAttribute:attr];
                        if ( [fieldClass isSubclassOfClass:rootClass] )
                        {
                            [NSObject DB].FIELD( field, @"INTEGER" );	// save as primary ID
                        }
                        else
                        {
                            [NSObject DB].FIELD( field, @"TEXT" );		// save as JSON
                        }
                    }
                    else
                    {
                        [NSObject DB].FIELD( field, @"INTEGER" );
                    }
                    
                    if ( [clazzType usingAutoIncrementForProperty:field] )
                    {
                        [NSObject DB].AUTO_INREMENT();
                    }
                    
                    if ( [clazzType usingUniqueForProperty:field] )
                    {
                        [NSObject DB].UNIQUE();
                    }
                    
                    if ( value && NO == [value isKindOfClass:[LionNonValue class]] )
                    {
                        [NSObject DB].DEFAULT( value );
                    }
                    
                    [property setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
                }
            }
            
            free( properties );
            
            clazzType = class_getSuperclass( clazzType );
            if ( nil == clazzType )
                break;
        }
    }
    
    [NSObject DB].CREATE_IF_NOT_EXISTS();
    
    // Step3, do migration if needed
    
    // TODO:
    //	"pragma table_info(\"test\")";
    //	"alter table \"test\" add column name";
    
    // Step4, create index
    
    [NSObject DB].TABLE( clazz.tableName ).INDEX_ON( clazz.activePrimaryKey, nil );
    
    [_builtFlags setObject:[NSNumber numberWithBool:YES] forKey:className];
}

+ (BOOL)isTableBuiltFor:(Class)clazz
{
    return [[LionActiveBuilder sharedInstance] isTableBuiltFor:clazz];
}

- (BOOL)isTableBuiltFor:(Class)clazz
{
    NSString * className = [clazz description];
    
    NSNumber * builtFlag = [_builtFlags objectForKey:className];	
    if ( builtFlag && builtFlag.boolValue )
    {
        return YES;
    }
    
    return NO;
}

- (void)handleNotification:(NSNotification *)notice
{
    if ( [notice is:LionDatabase.SHARED_DB_OPEN] )
    {
        // TODO:
    }
    else if ( [notice is:LionDatabase.SHARED_DB_CLOSE] )
    {
        [_builtFlags removeAllObjects];
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionActiveBuilder )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
