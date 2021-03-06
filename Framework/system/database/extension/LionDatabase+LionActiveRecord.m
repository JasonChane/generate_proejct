//
//  LionDatabase+LionActiveRecord.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_ActiveObject.h"
#import "NSObject+LionDatabase.h"
#import "LionDatabase+LionActiveRecord.h"
#import "NSDictionary+LionActiveRecord.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@interface LionActiveRecord(LionActiveRecord)
+ (void)setAssociateConditions;
+ (void)setHasConditions;
@end

#pragma mark -

@implementation LionActiveRecord(LionActiveRecord)

+ (void)setAssociateConditions
{
    NSMutableDictionary * propertySet = [[self class] activePropertySet];
    
    for ( NSString * key in propertySet.allKeys )
    {
        NSDictionary * property = [propertySet objectForKey:key];
        
        NSString * name = [property objectForKey:@"name"];
        NSNumber * type = [property objectForKey:@"type"];
        
        NSString * associateClass = [property objectForKey:@"associateClass"];
        NSString * associateProperty = [property objectForKey:@"associateProperty"];
        
        NSMutableArray * values = [NSMutableArray array];
        
        if ( associateClass )
        {
            Class classType = NSClassFromString( associateClass );
            if ( classType )
            {
                NSArray * objs = [super.DB associateObjectsFor:classType];
                for ( NSObject * obj in objs )
                {
                    if ( associateProperty )
                    {
                        NSObject * value = [obj valueForKey:associateProperty];
                        [values addObject:value];
                    }
                    else
                    {
                        NSObject * value = [obj valueForKey:classType.activePrimaryKey];
                        [values addObject:value];
                    }
                }
            }
        }
        
        for ( NSObject * value in values )
        {
            if ( value && NO == [value isKindOfClass:[LionNonValue class]] )
            {
                if ( LionTypeEncoding.NSNUMBER == type.intValue )
                {
                    value = [value asNSNumber];
                }
                else if ( LionTypeEncoding.NSSTRING == type.intValue )
                {
                    value = [value asNSString];
                }
                else if ( LionTypeEncoding.NSDATE == type.intValue )
                {
                    value = [[value asNSDate] description];
                }
                else
                {
                    //					value = [value asNSNumber];
                }
                
                super.DB.WHERE( name, value );
            }
        }
    }
}

+ (void)setHasConditions
{
    NSArray * objs = [super.DB hasObjects];
    for ( NSObject * obj in objs )
    {
        // TODO:
        
        //		Class clazz = [obj class];
        //		super.DB.WHERE( name, value );
    }
}

@end

#pragma mark -

@implementation LionDatabase(LionActiveRecord)

@dynamic SAVE;
@dynamic SAVE_DATA;
@dynamic SAVE_STRING;
@dynamic SAVE_ARRAY;
@dynamic SAVE_DICTIONARY;

@dynamic GET_RECORDS;
@dynamic FIRST_RECORD;
@dynamic FIRST_RECORD_BY_ID;
@dynamic LAST_RECORD;
@dynamic LAST_RECORD_BY_ID;

- (LionDatabaseObjectBlockN)SAVE
{
    LionDatabaseObjectBlockN block = ^ id ( id first, ... )
    {
        if ( [first isKindOfClass:[NSArray class]] )
        {
            return [self saveArray:(NSArray *)first];
        }
        else if ( [first isKindOfClass:[NSDictionary class]] )
        {
            return [self saveDictionary:(NSDictionary *)first];
        }
        else if ( [first isKindOfClass:[NSString class]] )
        {
            return [self saveString:(NSString *)first];
        }
        else if ( [first isKindOfClass:[NSData class]] )
        {
            return [self saveData:(NSData *)first];
        }
        else if ( [first isKindOfClass:[LionActiveRecord class]] )
        {
            LionActiveRecord * record = (LionActiveRecord *)first;
            record.changed = YES;
            record.SAVE();
            return record;
        }
        
        return nil;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)SAVE_DATA
{
    LionDatabaseObjectBlockN block = ^ id ( id first, ... )
    {
        return [self saveData:(NSData *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)SAVE_STRING
{
    LionDatabaseObjectBlockN block = ^ id ( id first, ... )
    {
        return [self saveString:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)SAVE_ARRAY
{
    LionDatabaseObjectBlockN block = ^ id ( id first, ... )
    {
        return [self saveArray:(NSArray *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)SAVE_DICTIONARY
{
    LionDatabaseObjectBlockN block = ^ id ( id first, ... )
    {
        return [self saveDictionary:(NSDictionary *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseArrayBlock)GET_RECORDS
{
    LionDatabaseArrayBlock block = ^ NSArray * ( void )
    {
        return [self getRecords];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlock)FIRST_RECORD
{
    LionDatabaseObjectBlock block = ^ NSArray * ( void )
    {
        return [self firstRecord];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)FIRST_RECORD_BY_ID
{
    LionDatabaseObjectBlockN block = ^ NSArray * ( id first, ... )
    {
        return [self firstRecord:nil byID:first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlock)LAST_RECORD
{
    LionDatabaseObjectBlock block = ^ NSArray * ( void )
    {
        return [self lastRecord];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseObjectBlockN)LAST_RECORD_BY_ID
{
    LionDatabaseObjectBlockN block = ^ NSArray * ( id first, ... )
    {
        return [self lastRecord:nil byID:first];
    };
    
    return [[block copy] autorelease];
}

- (id)saveData:(NSData *)data
{
    NSObject * obj = [data objectFromJSONData];
    if ( nil == obj )
        return nil;
    
    if ( [obj isKindOfClass:[NSArray class]] )
    {
        return [self saveArray:(NSArray *)obj];
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return [self saveDictionary:(NSDictionary *)obj];
    }
    
    return nil;
}

- (id)saveString:(NSString *)string
{
    if ( string && [string rangeOfString:@"'"].length > 0 )
    {
        string = [string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    
    NSError * error = nil;
    NSObject * obj = [(NSString *)string objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:&error];
    
    if ( nil == obj )
    {
        ERROR( @"%@", error );
        return nil;
    }
    
    if ( [obj isKindOfClass:[NSArray class]] )
    {
        return [self saveArray:(NSArray *)obj];
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return [self saveDictionary:(NSDictionary *)obj];
    }
    
    return nil;
}

- (id)saveArray:(NSArray *)array
{
    NSMutableArray * results = [NSMutableArray array];
    
    self.BATCH_BEGIN();
    
    for ( NSObject * obj in array )
    {
        if ( [obj isKindOfClass:[NSDictionary class]] )
        {
            id result = [self saveDictionary:(NSDictionary *)obj];
            if ( result )
            {
                [results addObject:result];
            }
        }
        else if ( [obj isKindOfClass:[LionActiveRecord class]] )
        {
            LionActiveRecord * record = (LionActiveRecord *)obj;
            if ( record )
            {
                record.changed = YES;
                record.SAVE();
                
                [results addObject:record];
            }
        }
    }
    
    self.BATCH_END();
    
    return results;
}

- (id)saveDictionary:(NSDictionary *)dict
{
    Class classType = self.classType;
    if ( NO == [classType isSubclassOfClass:[LionActiveRecord class]] )
        return nil;
    
    LionActiveRecord * record = [dict objectToActiveRecord:classType];
    if ( record )
    {
        record.changed = YES;
        record.SAVE();
        
        return record;
    }
    
    return nil;
}

- (id)firstRecord
{
    return [self firstRecord:nil];
}

- (id)firstRecord:(NSString *)table
{
    NSArray * array = [self getRecords:table limit:1 offset:0];
    if ( array && array.count )
    {
        return [array safeObjectAtIndex:0];
    }
    
    return nil;
}

- (id)firstRecordByID:(id)key
{
    return [self firstRecord:nil byID:key];
}

- (id)firstRecord:(NSString *)table byID:(id)key
{
    if ( nil == key )
        return nil;
    
    [self __internalResetResult];
    
    Class classType = [self classType];
    if ( NULL == classType )
        return nil;
    
    NSString * primaryKey = [LionActiveRecord activePrimaryKeyFor:classType];
    if ( nil == primaryKey )
        return nil;
    
    [classType setAssociateConditions];
    [classType setHasConditions];
    
    self.WHERE( primaryKey, key ).OFFSET( 0 ).LIMIT( 1 ).GET();
    if ( NO == self.succeed )
        return nil;
    
    NSArray * array = self.resultArray;
    if ( nil == array || 0 == array.count )
        return nil;
    
    NSDictionary * dict = [array safeObjectAtIndex:0];
    if ( dict && [dict isKindOfClass:[NSDictionary class]] )
    {
        return [[[classType alloc] initWithDictionary:dict] autorelease];
    }
    
    return nil;
}

- (id)lastRecord
{
    return [self lastRecord:nil];
}

- (id)lastRecord:(NSString *)table
{
    NSArray * array = [self getRecords:table limit:1 offset:0];
    if ( array && array.count )
    {
        return array.lastObject;
    }
    
    return nil;
}

- (id)lastRecordByID:(id)key
{
    return [self lastRecord:nil byID:key];
}

- (id)lastRecord:(NSString *)table byID:(id)key
{
    if ( nil == key )
        return nil;
    
    [self __internalResetResult];
    
    Class classType = [self classType];
    if ( NULL == classType )
        return nil;
    
    NSString * primaryKey = [LionActiveRecord activePrimaryKeyFor:classType];
    if ( nil == primaryKey )
        return nil;
    
    [classType setAssociateConditions];
    [classType setHasConditions];
    
    self.WHERE( primaryKey, key ).OFFSET( 0 ).LIMIT( 1 ).GET();
    if ( NO == self.succeed )
        return nil;
    
    NSArray * array = self.resultArray;
    if ( nil == array || 0 == array.count )
        return nil;
    
    NSDictionary * dict = array.lastObject;
    if ( dict )
    {
        return [[[classType alloc] initWithDictionary:dict] autorelease];
    }
    
    return nil;
}

- (NSArray *)getRecords
{
    return [self getRecords:nil limit:0 offset:0];
}

- (NSArray *)getRecords:(NSString *)table
{
    return [self getRecords:table limit:0 offset:0];
}

- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit
{
    return [self getRecords:table limit:limit offset:0];
}

- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset
{
    [self __internalResetResult];
    
    Class classType = [self classType];
    if ( NULL == classType )
        return [NSArray array];
    
    NSString * primaryKey = [LionActiveRecord activePrimaryKeyFor:classType];
    if ( nil == primaryKey )
        return [NSArray array];
    
    if ( table )
    {
        self.FROM( table );
    }
    
    if ( offset )
    {
        self.OFFSET( offset );
    }
    
    if ( limit )
    {
        self.LIMIT( limit );
    }
    
    [classType setAssociateConditions];
    [classType setHasConditions];
    
    self.GET();
    if ( NO == self.succeed )
        return [NSArray array];
    
    NSArray * array = self.resultArray;
    if ( nil == array || 0 == array.count )
        return [NSArray array];
    
    NSMutableArray * activeRecords = [[[NSMutableArray alloc] init] autorelease];
    
    for ( NSDictionary * dict in array )
    {
        LionActiveRecord * object = [[[classType alloc] initWithDictionary:dict] autorelease];
        [activeRecords addObject:object];
    }
    
    [self __internalSetResult:activeRecords];
    
    return activeRecords;
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

@interface __TestUser : LionActiveRecord
@property (nonatomic, retain) NSNumber *		uid;
@property (nonatomic, retain) NSString *		name;
@property (nonatomic, retain) NSString *		gender;
@property (nonatomic, retain) NSDate *			birth;
@end

@implementation __TestUser

@synthesize uid;
@synthesize name;
@synthesize gender;
@synthesize birth;

+ (void)mapRelation
{
    [super mapRelation];
    [super useJSON];
    [super useAutoIncrement];
}

@end

TEST_CASE( LionDatabase_LionActiveRecord )
{
    TIMES( 3 )
    {
        HERE( "open and close DB", {
            [LionDatabase closeSharedDatabase];
            EXPECTED( nil == [LionDatabase sharedDatabase] );
            
            [LionDatabase openSharedDatabase:@"ar"];
            EXPECTED( [LionDatabase sharedDatabase] );
        });
    }
    
    TIMES( 3 )
    {
        HERE( "empty DB", {
            __TestUser.DB.EMPTY();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 0 );
        });
        
        HERE( "insert and get", {
            __TestUser.DB.SET( @"name", @"gavin" ).SET( @"gender", @"male" ).SET( @"birth", [NSDate date] ).INSERT();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 1 );
            
            __TestUser.DB.WHERE( @"name", @"gavin" ).GET();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.resultCount == 1 );
            
            NSDictionary * user = [__TestUser.DB.resultArray objectAtIndex:0];
            EXPECTED( user );
            EXPECTED( [[user objectForKey:@"name"] isEqualToString:@"gavin"] );
            EXPECTED( [[user objectForKey:@"gender"] isEqualToString:@"male"] );
            EXPECTED( [user objectForKey:@"birth"] );
        });
        
        HERE( "insert and get again", {
            __TestUser.DB.SET( @"name", @"amanda" ).SET( @"gender", @"female" ).SET( @"birth", [NSDate date] ).INSERT();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 2 );
            
            __TestUser.DB.WHERE( @"name", @"amanda" ).GET();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.resultCount == 1 );
            
            NSDictionary * user2 = [__TestUser.DB.resultArray objectAtIndex:0];
            EXPECTED( user2 );
            EXPECTED( [[user2 objectForKey:@"name"] isEqualToString:@"amanda"] );
            EXPECTED( [[user2 objectForKey:@"gender"] isEqualToString:@"female"] );
            EXPECTED( [user2 objectForKey:@"birth"] );
        });
        
        HERE( "update", {
            __TestUser.DB.SET( @"birth", [NSDate date] ).WHERE( @"name", @"gavin" ).UPDATE();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 2 );
        });
        
        HERE( "delete", {
            __TestUser.DB.WHERE( @"name", @"gavin" ).DELETE();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 1 );
            
            __TestUser.DB.WHERE( @"name", @"amanda" ).DELETE();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.total == 0 );
        });
        
        HERE( "count", {
            __TestUser.DB.COUNT();
            EXPECTED( __TestUser.DB.succeed );
            EXPECTED( __TestUser.DB.resultCount == 0 );
        });
    }
    
    [LionDatabase closeSharedDatabase];
    EXPECTED( nil == [LionDatabase sharedDatabase] );
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
