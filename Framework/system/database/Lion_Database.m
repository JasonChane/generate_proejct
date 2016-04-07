//
//  Lion_Database.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Database.h"
#import "Lion_ActiveProtocol.h"
#import "NSObject+LionDatabase.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

DEF_PACKAGE( LionPackage_System, LionDatabase, db );

#pragma mark -

#undef	__USE_WRITE_QUEUE__
#define __USE_WRITE_QUEUE__		(__ON__)

#pragma mark -

@interface LionDatabase()
{
    BOOL					_autoOptimize;	// TO BE DONE
    BOOL					_batch;
    NSInteger				_identifier;
    NSString *				_filePath;
    
    BOOL					_shadow;
    FMDatabase *			_database;
    NSMutableArray *		_writeQueue;
    NSCondition *			_condition;
    
    NSMutableArray *		_select;
    BOOL					_distinct;
    NSMutableArray *		_from;
    NSMutableArray *		_where;
    NSMutableArray *		_like;
    NSMutableArray *		_groupby;
    NSMutableArray *		_having;
    NSMutableArray *		_keys;
    NSUInteger				_limit;
    NSUInteger				_offset;
    NSMutableArray *		_orderby;
    NSMutableDictionary *	_set;
    
    NSMutableArray *		_resultArray;
    NSUInteger				_resultCount;
    NSInteger				_lastInsertID;
    BOOL					_lastSucceed;
    
    NSMutableArray *		_table;
    NSMutableArray *		_field;
    NSMutableArray *		_index;
    
    NSMutableArray *		_classType;
    NSMutableArray *		_associate;
    NSMutableArray *		_has;
    
    NSTimeInterval			_lastQuery;
    NSTimeInterval			_lastUpdate;
}

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier;
+ (NSString *)tableNameForIdentifier:(NSString *)identifier;

- (void)initSelf;
- (NSString *)internalCreateAliasFromTable:(NSString *)name;
- (void)internalGroupBy:(NSString *)by;
- (void)internalSelect:(NSString *)select alias:(NSString *)alias type:(NSString *)type;
- (void)internalWhere:(NSString *)key expr:(NSString *)expr value:(NSObject *)value type:(NSString *)type;
- (void)internalLike:(NSString *)field match:(NSObject *)match type:(NSString *)type side:(NSString *)side invert:(BOOL)invert;
- (void)internalHaving:(NSString *)key value:(NSObject *)value type:(NSString *)type;
- (void)internalOrderBy:(NSString *)by direction:(NSString *)direction;

- (NSString *)internalCompileInsert:(NSString *)table values:(NSMutableArray *)values;
- (NSString *)internalCompileUpdate:(NSString *)table values:(NSMutableArray *)values;
- (NSString *)internalCompileSelect:(NSString *)override;
- (NSString *)internalCompileCreate:(NSString *)table;
- (NSString *)internalCompileDelete:(NSString *)table;
- (NSString *)internalCompileEmpty:(NSString *)table;
- (NSString *)internalCompileTrunc:(NSString *)table;
- (NSString *)internalCompileIndex:(NSString *)table;
- (NSString *)internalCompileExist:(NSString *)table as:(NSString *)value;

// create

- (LionDatabase *)table:(NSString *)name;
- (LionDatabase *)field:(NSString *)name type:(NSString *)type size:(NSUInteger)size;
- (LionDatabase *)unsignedType;
- (LionDatabase *)notNull;
- (LionDatabase *)primaryKey;
- (LionDatabase *)autoIncrement;
- (LionDatabase *)defaultZero;
- (LionDatabase *)defaultNull;
- (LionDatabase *)defaultValue:(id)value;
- (LionDatabase *)unique;
- (BOOL)createTableIfNotExists;
- (BOOL)createTableIfNotExists:(NSString *)table;
- (BOOL)indexTable:(NSString *)table on:(NSArray *)fields;
- (BOOL)existsTable:(NSString *)table;

// select

- (LionDatabase *)select:(NSString *)select;
- (LionDatabase *)selectMax:(NSString *)select;
- (LionDatabase *)selectMax:(NSString *)select alias:(NSString *)alias;
- (LionDatabase *)selectMin:(NSString *)select;
- (LionDatabase *)selectMin:(NSString *)select alias:(NSString *)alias;
- (LionDatabase *)selectAvg:(NSString *)select;
- (LionDatabase *)selectAvg:(NSString *)select alias:(NSString *)alias;
- (LionDatabase *)selectSum:(NSString *)select;
- (LionDatabase *)selectSum:(NSString *)select alias:(NSString *)alias;

- (LionDatabase *)distinct:(BOOL)flag;
- (LionDatabase *)from:(NSString *)from;

- (LionDatabase *)where:(NSString *)key value:(id)value;
- (LionDatabase *)orWhere:(NSString *)key value:(id)value;
- (LionDatabase *)where:(NSString *)key expr:(NSString *)expr value:(id)value;
- (LionDatabase *)orWhere:(NSString *)key expr:(NSString *)expr value:(id)value;

- (LionDatabase *)whereIn:(NSString *)key values:(NSArray *)values;
- (LionDatabase *)orWhereIn:(NSString *)key values:(NSArray *)values;
- (LionDatabase *)whereNotIn:(NSString *)key values:(NSArray *)values;
- (LionDatabase *)orWhereNotIn:(NSString *)key values:(NSArray *)values;

- (LionDatabase *)like:(NSString *)field match:(id)value;
- (LionDatabase *)notLike:(NSString *)field match:(id)value;
- (LionDatabase *)orLike:(NSString *)field match:(id)value;
- (LionDatabase *)orNotLike:(NSString *)field match:(id)value;

- (LionDatabase *)groupBy:(NSString *)by;

- (LionDatabase *)having:(NSString *)key value:(id)value;
- (LionDatabase *)orHaving:(NSString *)key value:(id)value;

- (LionDatabase *)orderAscendBy:(NSString *)by;
- (LionDatabase *)orderDescendBy:(NSString *)by;
- (LionDatabase *)orderRandomBy:(NSString *)by;
- (LionDatabase *)orderBy:(NSString *)by direction:(NSString *)direction;

- (LionDatabase *)limit:(NSUInteger)limit;
- (LionDatabase *)offset:(NSUInteger)offset;

- (LionDatabase *)classInfo:(id)obj;

// write

- (LionDatabase *)set:(NSString *)key;
- (LionDatabase *)set:(NSString *)key value:(id)value;

- (NSArray *)get;
- (NSArray *)get:(NSString *)table;
- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit;
- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset;

- (NSUInteger)count;
- (NSUInteger)count:(NSString *)table;

- (NSInteger)insert;
- (NSInteger)insert:(NSString *)table;

- (BOOL)update;
- (BOOL)update:(NSString *)table;

- (BOOL)empty;
- (BOOL)empty:(NSString *)table;

- (BOOL)truncate;
- (BOOL)truncate:(NSString *)table;

- (BOOL)delete;
- (BOOL)delete:(NSString *)table;

// active record

- (void)classType:(Class)clazz;
- (void)associate:(NSObject *)obj;
- (void)has:(NSObject *)obj;

- (void)executeWriteOperations;
- (void)executeWriteOperation;

@end

#pragma mark -

@implementation LionDatabase

@dynamic autoOptimize;
@dynamic ready;
@dynamic total;
@synthesize shadow = _shadow;
@synthesize database = _database;
@synthesize filePath = _filePath;
@synthesize identifier = _identifier;

@dynamic TABLE;
@dynamic FIELD;
@dynamic FIELD_WITH_SIZE;
@dynamic UNSIGNED;
@dynamic NOT_NULL;
@dynamic PRIMARY_KEY;
@dynamic AUTO_INREMENT;
@dynamic DEFAULT_ZERO;
@dynamic DEFAULT_NULL;
@dynamic DEFAULT;
@dynamic UNIQUE;
@dynamic CREATE_IF_NOT_EXISTS;
@dynamic INDEX_ON;

@dynamic SELECT;
@dynamic SELECT_MAX;
@dynamic SELECT_MAX_ALIAS;
@dynamic SELECT_MIN;
@dynamic SELECT_MIN_ALIAS;
@dynamic SELECT_AVG;
@dynamic SELECT_AVG_ALIAS;
@dynamic SELECT_SUM;
@dynamic SELECT_SUM_ALIAS;

@dynamic DISTINCT;
@dynamic FROM;

@dynamic WHERE;
@dynamic OR_WHERE;

@dynamic WHERE_OPERATOR;
@dynamic OR_WHERE_OPERATOR;

@dynamic WHERE_IN;
@dynamic OR_WHERE_IN;
@dynamic WHERE_NOT_IN;
@dynamic OR_WHERE_NOT_IN;

@dynamic LIKE;
@dynamic NOT_LIKE;
@dynamic OR_LIKE;
@dynamic OR_NOT_LIKE;

@dynamic GROUP_BY;

@dynamic HAVING;
@dynamic OR_HAVING;

@dynamic ORDER_ASC_BY;
@dynamic ORDER_DESC_BY;
@dynamic ORDER_RAND_BY;
@dynamic ORDER_BY;

@dynamic LIMIT;
@dynamic OFFSET;

@dynamic SET;
@dynamic SET_NULL;

@dynamic GET;
@dynamic COUNT;

@dynamic INSERT;
@dynamic UPDATE;
@dynamic EMPTY;
@dynamic TRUNCATE;
@dynamic DELETE;

@dynamic BATCH_BEGIN;
@dynamic BATCH_END;

@dynamic CLASS_TYPE;
@dynamic ASSOCIATE;
@dynamic HAS;

@dynamic LOCK;		// for multi-thread
@dynamic UNLOCK;	// for multi-thread

@dynamic resultArray;
@dynamic resultCount;
@dynamic insertID;
@dynamic succeed;

@synthesize lastQuery = _lastQuery;
@synthesize lastUpdate = _lastUpdate;

DEF_NOTIFICATION( SHARED_DB_OPEN )
DEF_NOTIFICATION( SHARED_DB_CLOSE )

static NSMutableArray *	__shadowDBs = nil;
static LionDatabase *	__sharedDB = nil;
static NSUInteger		__identSeed = 1;

#pragma mark -

- (NSArray *)resultArray
{
    [self __internalResetSelect];
    [self __internalResetWrite];
    [self __internalResetCreate];
    
    //	[self __internalResetResult];
    
    return [[[NSMutableArray alloc] initWithArray:_resultArray] autorelease];
}

- (NSUInteger)resultCount
{
    [self __internalResetSelect];
    [self __internalResetWrite];
    [self __internalResetCreate];
    
    return _resultCount;
}

- (NSInteger)insertID
{
    [self __internalResetSelect];
    [self __internalResetWrite];
    [self __internalResetCreate];
    
    return _lastInsertID;
}

- (BOOL)succeed
{
    [self __internalResetSelect];
    [self __internalResetWrite];
    [self __internalResetCreate];
    
    return _lastSucceed;
}

- (NSUInteger)total
{
    NSUInteger count = [self count];
    
    [self __internalResetSelect];
    [self __internalResetWrite];
    [self __internalResetCreate];
    
    return count;
}

#pragma mark -

+ (BOOL)openSharedDatabase:(NSString *)path
{
    if ( __sharedDB.ready && [__sharedDB.filePath isEqualToString:path] )
        return YES;
    
    [self closeSharedDatabase];
    
    __sharedDB = [[[self class] alloc] initWithPath:path];
    if ( __sharedDB )
    {
        if ( NO == __sharedDB.ready )
        {
            [__sharedDB release];
            __sharedDB = nil;
        }
    }
    
    BOOL succeed = (__sharedDB && __sharedDB.ready) ? YES : NO;
    if ( succeed )
    {
        [self postNotification:self.SHARED_DB_OPEN];
    }
    return succeed;
}

+ (BOOL)existsSharedDatabase:(NSString *)path
{
    return [LionDatabase exists:path];
}

+ (void)closeSharedDatabase
{
    if ( __shadowDBs )
    {
        for ( LionDatabase * db in __shadowDBs )
        {
            [db close];
        }
        
        [__shadowDBs removeAllObjects];
        [__shadowDBs release];
        __shadowDBs = nil;
    }
    
    [__sharedDB close];
    [__sharedDB release];
    __sharedDB = nil;
    
    [self postNotification:self.SHARED_DB_CLOSE];
}

+ (void)setSharedDatabase:(LionDatabase *)db
{
    if ( db != __sharedDB )
    {
        [self postNotification:self.SHARED_DB_CLOSE];
        
        [db retain];
        
        if ( __shadowDBs )
        {
            for ( LionDatabase * db in __shadowDBs )
            {
                [db close];
            }
            
            [__shadowDBs removeAllObjects];
            [__shadowDBs release];
            __shadowDBs = nil;
        }
        
        [__sharedDB close];
        [__sharedDB release];
        __sharedDB = db;
        
        [self postNotification:self.SHARED_DB_OPEN];
    }
}

+ (LionDatabase *)sharedDatabase
{
    if ( __shadowDBs.count )
    {
        return (LionDatabase *)__shadowDBs.lastObject;
    }
    
    return __sharedDB;
}

+ (LionDatabase *)sharedInstance
{
    return [self sharedDatabase];
}

+ (void)scopeEnter
{
    if ( __sharedDB )
    {
        LionDatabase * db = [[LionDatabase alloc] initWithDatabase:__sharedDB.database];
        if ( db )
        {
            db.shadow = YES;
            
            if ( nil == __shadowDBs )
            {
                __shadowDBs = [[NSMutableArray alloc] init];
            }
            
            [__shadowDBs addObject:db];
            
            [db release];
        }
    }
}

+ (void)scopeLeave
{
    if ( __shadowDBs && __shadowDBs.count )
    {
        [__shadowDBs removeObject:__shadowDBs.lastObject];
    }
}

#pragma mark -

- (void)initSelf
{
    _select = [[NSMutableArray alloc] init];
    _distinct = NO;
    _from = [[NSMutableArray alloc] init];
    _where = [[NSMutableArray alloc] init];
    _like = [[NSMutableArray alloc] init];
    _groupby = [[NSMutableArray alloc] init];
    _having = [[NSMutableArray alloc] init];
    _keys = [[NSMutableArray alloc] init];
    _limit = 0;
    _offset = 0;
    _orderby = [[NSMutableArray alloc] init];
    _set = [[NSMutableDictionary alloc] init];
    _classType = [[NSMutableArray alloc] init];
    
    _associate = [[NSMutableArray nonRetainingArray] retain];
    _has = [[NSMutableArray nonRetainingArray] retain];
    
    _table = [[NSMutableArray alloc] init];
    _field = [[NSMutableArray alloc] init];
    _index = [[NSMutableArray alloc] init];
    
    _writeQueue = [[NSMutableArray alloc] init];
    _resultArray = [[NSMutableArray alloc] init];
    _resultCount = 0;
    
    _identifier = __identSeed++;
    
    _condition = [[NSCondition alloc] init];
    [_condition setName:[NSString stringWithFormat:@"db-%ld", (long)_identifier]];
    
    _lastQuery = [NSDate timeIntervalSinceReferenceDate];
    _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
}

- (id)init
{
    self = [super init];
    if ( self )
    {
        [self initSelf];
    }
    return self;
}

- (id)initWithDatabase:(FMDatabase *)db
{
    self = [super init];
    if ( self )
    {
        [self initSelf];
        
        self.database = db;
        self.filePath = db.databasePath;
    }
    return self;
}

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if ( self )
    {
        [self initSelf];
        [self open:path];
    }
    return self;
}

- (void)dealloc
{
    [self executeWriteOperations];
    [self close];
    
    [_database release];
    _database = nil;
    
    [_condition release];
    _condition = nil;
    
    [_filePath release];
    
    [_select removeAllObjects];
    [_select release];
    
    [_from removeAllObjects];
    [_from release];
    
    [_where removeAllObjects];
    [_where release];
    
    [_like removeAllObjects];
    [_like release];
    
    [_groupby removeAllObjects];
    [_groupby release];
    
    [_having removeAllObjects];
    [_having release];
    
    [_keys removeAllObjects];
    [_keys release];
    
    [_orderby removeAllObjects];
    [_orderby release];
    
    [_set removeAllObjects];
    [_set release];
    
    [_field removeAllObjects];
    [_field release];
    
    [_table removeAllObjects];
    [_table release];
    
    [_index removeAllObjects];
    [_index release];
    
    [_resultArray removeAllObjects];
    [_resultArray release];
    
    [_classType removeAllObjects];
    [_classType release];
    
    [_associate removeAllObjects];
    [_associate release];
    
    [_has removeAllObjects];
    [_has release];
    
    [super dealloc];
}

#pragma mark -

+ (NSString *)sqliteFileName:(NSString *)path
{
    BOOL isFullPath = [path rangeOfString:@"/"].length > 0 ? YES : NO;
    if ( isFullPath )
    {
        return path;
    }
    else
    {
        NSString * fullPath = [NSString stringWithFormat:@"%@/%@/Database/", [LionSandbox docPath], [LionSystemInfo appVersion]];
        if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:NULL] )
        {
            BOOL ret = [[NSFileManager defaultManager] createDirectoryAtPath:fullPath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:nil];
            if ( NO == ret )
                return nil;
        }
        
        return [fullPath stringByAppendingPathComponent:path];
    }
}

+ (BOOL)exists:(NSString *)path;
{
    NSString * fullName = [LionDatabase sqliteFileName:path];
    if ( nil == fullName )
        return NO;
    
    BOOL isDirectory = NO;
    BOOL returnValue = [[NSFileManager defaultManager] fileExistsAtPath:fullName isDirectory:&isDirectory];
    if ( NO == returnValue || YES == isDirectory )
        return NO;
    
    return YES;
}

- (BOOL)ready
{
    if ( nil == _database )
        return NO;
    
    return _database.open;
}

- (BOOL)open:(NSString *)path
{
    if ( _filePath && [_filePath isEqualToString:path] )
        return YES;
    
    [self close];
    
    NSString * fullName = [LionDatabase sqliteFileName:path];
    if ( nil == fullName )
        return NO;
    
    INFO( @"'%@' opened", fullName );
    
    _database = [[FMDatabase alloc] initWithPath:fullName];
    if ( nil == _database )
        return NO;
    
    BOOL ret = [_database open];
    if ( NO == ret )
    {
        [_database release];
        _database = nil;
    }
    else
    {
#if defined(__Lion_DEVELOPMENT__) && __Lion_DEVELOPMENT__
        //		[_database setShouldCacheStatements:YES];
        //		_database.crashOnErrors = YES;
        _database.traceExecution = YES;
        _database.logsErrors = YES;
#endif	// #if defined(__Lion_DEVELOPMENT__) && __Lion_DEVELOPMENT__
        
        self.filePath = path;
    }
    
    return ret;
}

- (void)close
{
    if ( _database )
    {
        if ( NO == _shadow )
        {
            INFO( @"'%p' closed", _database );
            
            [_database close];
        }
        
        [_database release];
        _database = nil;
    }
    
    _lastQuery = [NSDate timeIntervalSinceReferenceDate];
    _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
}

- (void)clearState
{
    [self __internalResetCreate];
    [self __internalResetWrite];
    [self __internalResetSelect];
}

#pragma mark -

- (LionDatabase *)table:(NSString *)name
{
    if ( nil == _database )
        return self;
    
    if ( nil == name )
        return self;
    
    name = [LionDatabase tableNameForIdentifier:name];
    
    for ( NSString * table in _table )
    {
        if ( NSOrderedSame == [table compare:name options:NSCaseInsensitiveSearch] )
            return self;
    }
    
    [_table addObject:name];
    return self;
}

- (LionDatabase *)field:(NSString *)name type:(NSString *)type size:(NSUInteger)size
{
    if ( nil == _database )
        return self;
    
    BOOL found = NO;
    
    for ( NSMutableDictionary * dict in _field )
    {
        NSString * existName = [dict objectForKey:@"name"];
        if ( NSOrderedSame == [existName compare:name options:NSCaseInsensitiveSearch] )
        {
            if ( type )
            {
                [dict setObject:type forKey:@"type"];
            }
            
            if ( size )
            {
                [dict setObject:[NSNumber numberWithUnsignedLongLong:size] forKey:@"size"];
            }
            
            found = YES;
            break;
        }
    }
    
    if ( NO == found )
    {
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:name forKey:@"name"];
        [dict setObject:(type ? type : @"INT") forKey:@"type"];
        [dict setObject:[NSNumber numberWithUnsignedLongLong:size] forKey:@"size"];
        [_field addObject:dict];
    }
    
    return self;
}

- (LionDatabase *)unsignedType
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:__INT(1) forKey:@"unsigned"];
    return self;
}

- (LionDatabase *)notNull
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:__INT(1) forKey:@"notNull"];
    return self;
}

- (LionDatabase *)primaryKey
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:__INT(1) forKey:@"primaryKey"];
    return self;
}

- (LionDatabase *)autoIncrement
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:__INT(1) forKey:@"autoIncrement"];
    return self;
}

- (LionDatabase *)defaultZero
{
    return [self defaultValue:__INT(0)];
}

- (LionDatabase *)defaultNull
{
    return [self defaultValue:[NSNull null]];
}

- (LionDatabase *)defaultValue:(id)value
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:value forKey:@"default"];
    return self;
}

- (LionDatabase *)unique
{
    if ( nil == _database )
        return self;
    
    NSMutableDictionary * dict = (NSMutableDictionary *)_field.lastObject;
    if ( nil == dict )
        return self;
    
    [dict setObject:__INT(1) forKey:@"unique"];
    return self;
}

#pragma mark -

- (BOOL)createTableIfNotExists
{
    return [self createTableIfNotExists:nil];
}

- (BOOL)createTableIfNotExists:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _table.count )
            return NO;
        
        table = (NSString *)_table.lastObject;
    }
    else
    {
        table = [LionDatabase tableNameForIdentifier:table];
    }
    
    if ( nil == table || 0 == table.length )
        return NO;
    
    if ( 0 == _field.count )
        return NO;
    
    NSString * sql = [self internalCompileCreate:table];
    [self __internalResetCreate];
    
    BOOL ret = [_database executeUpdate:sql];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
    }
    
    return ret;
}

#pragma mark -

- (BOOL)indexTable:(NSString *)table on:(NSArray *)fields
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( nil == fields || 0 == fields.count )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _table.count )
            return NO;
        
        table = (NSString *)_table.lastObject;
    }
    else
    {
        table = [LionDatabase tableNameForIdentifier:table];
    }
    
    if ( nil == table || 0 == table.length )
        return NO;
    
    for ( NSString * field in fields )
    {
        [_index addObject:field];
    }
    
    if ( 0 == _index.count )
        return NO;
    
    NSString * sql = [self internalCompileIndex:table];
    [self __internalResetCreate];
    
    BOOL ret = [_database executeUpdate:sql];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
    }
    
    return ret;
}

#pragma mark -

- (BOOL)existsTable:(NSString *)table
{
    if ( nil == table )
        return NO;
    
    BOOL succeed = NO;
    BOOL exists = NO;
    
    if ( nil == table )
    {
        if ( 0 == _table.count )
            return NO;
        
        table = (NSString *)_table.lastObject;
    }
    else
    {
        table = [LionDatabase tableNameForIdentifier:table];
    }
    
    if ( nil == table || 0 == table.length )
        return NO;
    
    NSString * sql = [self internalCompileExist:table as:@"numrows"];
    
    FMResultSet * result = [_database executeQuery:sql];
    if ( result )
    {
        succeed = [result next];
        if ( succeed )
        {
            NSDictionary * dict = nil;
            
            if ( [result respondsToSelector:@selector(resultDictionary)] )
            {
                dict = [result resultDictionary];
            }
            else if ( [result respondsToSelector:@selector(resultDict)] )
            {
                dict = [result performSelector:@selector(resultDict)];
            }
            
            if ( dict )
            {
                NSNumber * numrows = [dict objectForKey:@"numrows"];
                if ( numrows )
                {
                    exists = numrows.intValue ? YES : NO;
                }
            }
        }
        
        if ( succeed )
        {
            _lastQuery = [NSDate timeIntervalSinceReferenceDate];
        }
    }
    
    return exists;
}

#pragma mark -

- (LionDatabase *)select:(NSString *)select
{
    if ( nil == _database )
        return self;
    
    if ( nil == select )
        return self;
    
    [self internalSelect:select alias:nil type:nil];
    return self;
}

- (LionDatabase *)selectMax:(NSString *)select
{
    return [self selectMax:select alias:nil];
}

- (LionDatabase *)selectMax:(NSString *)select alias:(NSString *)alias
{
    if ( nil == _database )
        return self;
    
    [self internalSelect:select alias:alias type:@"MAX"];
    return self;
}

- (LionDatabase *)selectMin:(NSString *)select
{
    return [self selectMin:select alias:nil];
}

- (LionDatabase *)selectMin:(NSString *)select alias:(NSString *)alias
{
    if ( nil == _database )
        return self;
    
    [self internalSelect:select alias:alias type:@"MIN"];
    return self;
}

- (LionDatabase *)selectAvg:(NSString *)select
{
    return [self selectAvg:select alias:nil];
}

- (LionDatabase *)selectAvg:(NSString *)select alias:(NSString *)alias
{
    if ( nil == _database )
        return self;
    
    [self internalSelect:select alias:alias type:@"AVG"];
    return self;
}

- (LionDatabase *)selectSum:(NSString *)select
{
    return [self selectSum:select alias:nil];
}

- (LionDatabase *)selectSum:(NSString *)select alias:(NSString *)alias
{
    if ( nil == _database )
        return self;
    
    [self internalSelect:select alias:alias type:@"SUM"];
    return self;
}

#pragma mark -

- (LionDatabase *)distinct:(BOOL)flag
{
    if ( nil == _database )
        return self;
    
    _distinct = flag;
    return self;
}

#pragma mark -

- (LionDatabase *)from:(NSString *)from
{
    if ( nil == _database )
        return self;
    
    if ( nil == from )
        return self;
    
    from = [LionDatabase tableNameForIdentifier:from];
    
    for ( NSString * table in _from )
    {
        if ( NSOrderedSame == [table compare:from options:NSCaseInsensitiveSearch] )
            return self;
    }
    
    [_from addObject:from];
    return self;
}

#pragma mark -

- (LionDatabase *)where:(NSString *)key value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalWhere:key expr:@"=" value:value type:@"AND"];
    return self;
}

- (LionDatabase *)orWhere:(NSString *)key value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalWhere:key expr:@"=" value:value type:@"OR"];
    return self;
}

- (LionDatabase *)where:(NSString *)key expr:(NSString *)expr value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalWhere:key expr:expr value:value type:@"AND"];
    return self;
}

- (LionDatabase *)orWhere:(NSString *)key expr:(NSString *)expr value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalWhere:key expr:expr value:value type:@"OR"];
    return self;
}

- (LionDatabase *)whereIn:(NSString *)key values:(NSArray *)values
{
    if ( nil == _database )
        return self;
    
    [self internalWhereIn:key values:values invert:NO type:@"AND"];
    return self;
}

- (LionDatabase *)orWhereIn:(NSString *)key values:(NSArray *)values
{
    if ( nil == _database )
        return self;
    
    [self internalWhereIn:key values:values invert:NO type:@"OR"];
    return self;
}

- (LionDatabase *)whereNotIn:(NSString *)key values:(NSArray *)values
{
    if ( nil == _database )
        return self;
    
    [self internalWhereIn:key values:values invert:YES type:@"AND"];
    return self;
}

- (LionDatabase *)orWhereNotIn:(NSString *)key values:(NSArray *)values
{
    if ( nil == _database )
        return self;
    
    [self internalWhereIn:key values:values invert:YES type:@"OR"];
    return self;
}

#pragma mark -

- (LionDatabase *)like:(NSString *)field match:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalLike:field match:value type:@"AND" side:@"both" invert:NO];
    return self;
}

- (LionDatabase *)notLike:(NSString *)field match:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalLike:field match:value type:@"AND" side:@"both" invert:YES];
    return self;
}

- (LionDatabase *)orLike:(NSString *)field match:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalLike:field match:value type:@"OR" side:@"both" invert:NO];
    return self;
}

- (LionDatabase *)orNotLike:(NSString *)field match:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalLike:field match:value type:@"OR" side:@"both" invert:YES];
    return self;
}

#pragma mark -

- (LionDatabase *)groupBy:(NSString *)by
{
    if ( nil == _database )
        return self;
    
    [self internalGroupBy:by];
    return self;
}

#pragma mark -

- (LionDatabase *)having:(NSString *)key value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalHaving:key value:value type:@"AND"];
    return self;
}

- (LionDatabase *)orHaving:(NSString *)key value:(id)value
{
    if ( nil == _database )
        return self;
    
    [self internalHaving:key value:value type:@"OR"];
    return self;
}

#pragma mark -

- (LionDatabase *)orderAscendBy:(NSString *)by
{
    return [self orderBy:by direction:@"ASC"];
}

- (LionDatabase *)orderDescendBy:(NSString *)by
{
    return [self orderBy:by direction:@"DESC"];
}

- (LionDatabase *)orderRandomBy:(NSString *)by
{
    return [self orderBy:by direction:@"RAND()"];
}

- (LionDatabase *)orderBy:(NSString *)by direction:(NSString *)direction
{
    if ( nil == _database )
        return self;
    
    if ( nil == by )
        return self;
    
    [self internalOrderBy:by direction:direction];
    return self;
}

#pragma mark -

- (LionDatabase *)limit:(NSUInteger)limit
{
    if ( nil == _database )
        return self;
    
    _limit = limit;
    return self;
}

- (LionDatabase *)offset:(NSUInteger)offset
{
    if ( nil == _database )
        return self;
    
    _offset = offset;
    return self;
}

- (LionDatabase *)classInfo:(id)obj
{
    if ( nil == obj )
        return self;
    
    [_classType addObject:obj];
    return self;
}

#pragma mark -

- (LionDatabase *)set:(NSString *)key
{
    return [self set:key value:nil];
}

- (LionDatabase *)set:(NSString *)key value:(id)value
{
    if ( nil == _database )
        return self;
    
    if ( nil == key || nil == value )
        return self;
    
    [_set setObject:value forKey:key];
    return self;
}

#pragma mark -

- (NSArray *)get
{
    return [self get:nil limit:0 offset:0];
}

- (NSArray *)get:(NSString *)table
{
    return [self get:table limit:0 offset:0];
}

- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit
{
    return [self get:table limit:limit offset:0];
}

- (NSArray *)get:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return nil;
    
    if ( table )
    {
        [self from:table];
    }
    
    if ( limit )
    {
        [self limit:limit];
    }
    
    if ( offset )
    {
        [self offset:offset];
    }
    
    NSString * sql = [self internalCompileSelect:nil];
    
    [self __internalResetSelect];
    
    FMResultSet * result = [_database executeQuery:sql];
    if ( result )
    {
        while ( [result next] )
        {
            NSDictionary * dict = nil;
            
            if ( [result respondsToSelector:@selector(resultDictionary)] )
            {
                dict = [result resultDictionary];
            }
            else if ( [result respondsToSelector:@selector(resultDict)] )
            {
                dict = [result performSelector:@selector(resultDict)];
            }
            
            if ( dict )
            {
                [_resultArray addObject:dict];
            }
        }
        
        _resultCount = _resultArray.count;
        
        _lastQuery = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
    }
    
    return _resultArray;
}

#pragma mark -

- (NSUInteger)count
{
    return [self count:nil];
}

- (NSUInteger)count:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return 0;
    
    if ( table )
    {
        [self from:table];
    }
    
    NSString * sql = [self internalCompileSelect:@"SELECT COUNT(*) AS numrows"];
    [self __internalResetSelect];
    
    BOOL succeed = NO;
    
    FMResultSet * result = [_database executeQuery:sql];
    if ( result )
    {
        succeed = [result next];
        if ( succeed )
        {
            _resultCount = (NSUInteger)[result unsignedLongLongIntForColumn:@"numrows"];
            
            _lastQuery = [NSDate timeIntervalSinceReferenceDate];
            _lastSucceed = YES;
        }
    }
    
    return _resultCount;
}

#pragma mark -

- (NSInteger)insert
{
    return [self insert:nil];
}

- (NSInteger)insert:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return -1;
    
    if ( 0 == _set.count )
        return -1;
    
    if ( nil == table )
    {
        if ( 0 == _from.count )
            return -1;
        
        table = [_from objectAtIndex:0];
    }
    
    NSMutableArray * allValues = [NSMutableArray array];
    NSString * sql = [self internalCompileInsert:table values:allValues];
    
    [self __internalResetWrite];
    
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:allValues];
    if ( ret )
    {
        _lastInsertID = (NSInteger)_database.lastInsertRowId;
        
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
    }
    
    return _lastInsertID;
}

#pragma mark -

- (BOOL)update
{
    return [self update:nil];
}

- (BOOL)update:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( 0 == _set.count )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _from.count )
            return NO;
        
        table = [_from objectAtIndex:0];
    }
    
    NSMutableArray * allValues = [NSMutableArray array];
    NSString * sql = [self internalCompileUpdate:table values:allValues];
    
    [self __internalResetWrite];
    
    BOOL ret = [_database executeUpdate:sql withArgumentsInArray:allValues];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
        
        // TODO: ...
    }
    
    return ret;
}

#pragma mark -

- (BOOL)empty
{
    return [self empty:nil];
}

- (BOOL)empty:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _from.count )
            return NO;
        
        table = [_from objectAtIndex:0];
    }
    else
    {
        table = [LionDatabase tableNameForIdentifier:table];
    }
    
    NSString * sql = [self internalCompileEmpty:table];
    
    [self __internalResetWrite];
    
    BOOL ret = [_database executeUpdate:sql];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
        
        // TODO: ...
    }
    
    return ret;
}

#pragma mark -

- (BOOL)delete
{
    return [self delete:nil];
}

- (BOOL)delete:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _from.count )
            return NO;
        
        table = [_from objectAtIndex:0];
    }
    
    if ( 0 == _where.count && 0 == _like.count )
        return NO;
    
    NSString * sql = [self internalCompileDelete:table];
    
    [self __internalResetWrite];
    
    BOOL ret = [_database executeUpdate:sql];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
        
        // TODO: ...
    }
    
    return ret;
}

#pragma mark -

- (BOOL)truncate
{
    return [self truncate:nil];
}

- (BOOL)truncate:(NSString *)table
{
    [self __internalResetResult];
    
    if ( nil == _database )
        return NO;
    
    if ( nil == table )
    {
        if ( 0 == _from.count )
            return NO;
        
        table = [_from objectAtIndex:0];
    }
    else
    {
        table = [LionDatabase tableNameForIdentifier:table];
    }
    
    NSString * sql = [self internalCompileTrunc:table];
    
    [self __internalResetWrite];
    
    BOOL ret = [_database executeUpdate:sql];
    if ( ret )
    {
        _lastUpdate = [NSDate timeIntervalSinceReferenceDate];
        _lastSucceed = YES;
        
        // TODO: ...
    }
    
    return ret;
}

#pragma mark -

- (void)__internalResetCreate
{
    [_field removeAllObjects];
    [_table removeAllObjects];
    [_index removeAllObjects];
    
    if ( NO == _batch )
    {
        [_classType removeAllObjects];
        [_associate removeAllObjects];
        [_has removeAllObjects];
    }
}

- (void)__internalResetSelect
{
    [_select removeAllObjects];
    [_from removeAllObjects];
    [_where removeAllObjects];
    [_like removeAllObjects];
    [_groupby removeAllObjects];
    [_having removeAllObjects];
    [_orderby removeAllObjects];
    
    if ( NO == _batch )
    {
        [_classType removeAllObjects];
        [_associate removeAllObjects];
        [_has removeAllObjects];
    }
    
    _distinct = NO;
    _limit = 0;
    _offset = 0;
}

- (void)__internalResetWrite
{
    [_set removeAllObjects];
    [_from removeAllObjects];
    [_where removeAllObjects];
    [_like removeAllObjects];
    [_orderby removeAllObjects];
    [_keys removeAllObjects];
    
    if ( NO == _batch )
    {
        [_classType removeAllObjects];
        [_associate removeAllObjects];
        [_has removeAllObjects];
    }
    
    _limit = 0;
}

- (void)__internalResetResult
{
    [_resultArray removeAllObjects];
    
    _resultCount = 0;
    _lastInsertID = -1;
    _lastSucceed = NO;
}

- (void)__internalSetResult:(NSArray *)array
{
    if ( nil == array )
    {
        [_resultArray removeAllObjects];
        
        _resultCount = 0;
    }
    else
    {
        [_resultArray removeAllObjects];
        [_resultArray addObjectsFromArray:array];
        
        _resultCount = array.count;
    }
}

#pragma mark -

- (void)internalGroupBy:(NSString *)by
{
    if ( nil == by )
        return;
    
    [_groupby addObject:by];
}

- (void)internalSelect:(NSString *)select alias:(NSString *)alias type:(NSString *)type
{
    if ( nil == select )
        return;
    
    NSArray * fieldNames = [select componentsSeparatedByString:@","];
    if ( fieldNames.count > 0 )
    {
        for ( NSString * field in fieldNames )
        {
            field = [LionDatabase fieldNameForIdentifier:field];
            
            if ( field && field.length )
            {
                [_select addObject:field];
            }
        }
    }
    else
    {
        NSMutableString * sql = [NSMutableString string];
        
        if ( type && type.length )
        {
            [sql appendFormat:@"%@(%@)", type, [LionDatabase fieldNameForIdentifier:select]];
        }
        else
        {
            [sql appendFormat:@"%@", [LionDatabase fieldNameForIdentifier:select]];
        }
        
        if ( nil == alias || 0 == alias.length )
        {
            alias = [self internalCreateAliasFromTable:alias];
        }
        
        if ( alias )
        {
            alias = [LionDatabase fieldNameForIdentifier:alias];
            [sql appendFormat:@" AS %@", alias];
        }
        
        [_select addObject:sql];
    }
}

- (NSString *)internalCreateAliasFromTable:(NSString *)name
{
    NSRange range = [name rangeOfString:@"."];
    if ( range.length )
    {
        NSArray * array = [name componentsSeparatedByString:@"."];
        if ( array && array.count )
        {
            return array.lastObject;
        }
    }
    
    return name;
}

- (void)internalWhere:(NSString *)key expr:(NSString *)expr value:(NSObject *)value type:(NSString *)type
{
    key = [LionDatabase fieldNameForIdentifier:key];
    
    NSString *			prefix = (0 == _where.count) ? @"" : type;
    NSMutableString *	sql = [NSMutableString string];
    
    if ( nil == value || [value isKindOfClass:[NSNull class]] )
    {
        [sql appendFormat:@"%@ %@ IS NULL", prefix, key];
    }
    else
    {
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            [sql appendFormat:@"%@ %@ %@ %@", prefix, key, expr, value];
        }
        else
        {
            [sql appendFormat:@"%@ %@ %@ '%@'", prefix, key, expr, value];
        }
    }
    
    [_where addObject:sql];
}

- (void)internalWhereIn:(NSString *)key values:(NSArray *)values invert:(BOOL)invert type:(NSString *)type
{
    if ( nil == key || nil == values || 0 == values.count )
        return;
    
    NSMutableString * sql = [NSMutableString string];
    
    if ( _where.count )
    {
        [sql appendFormat:@"%@ ", type];
    }
    
    key = [LionDatabase fieldNameForIdentifier:key];
    [sql appendFormat:@"%@", key];
    
    if ( invert )
    {
        [sql appendString:@" NOT"];
    }
    
    [sql appendString:@" IN ("];
    
    for ( NSInteger i = 0; i < values.count; ++i )
    {
        NSObject * value = [values objectAtIndex:i];
        
        if ( i > 0 )
        {
            [sql appendFormat:@", "];
        }
        
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            [sql appendFormat:@"%@", value];
        }
        else
        {
            [sql appendFormat:@"'%@'", value];
        }
    }
    
    [sql appendString:@")"];
    
    [_where addObject:sql];
}

- (void)internalLike:(NSString *)field match:(NSObject *)match type:(NSString *)type side:(NSString *)side invert:(BOOL)invert
{
    if ( nil == field || nil == match )
        return;
    
    NSString * value = nil;
    
    if ( [side isEqualToString:@"before"] )
    {
        value = [NSString stringWithFormat:@"%%%@", match];
    }
    else if ( [side isEqualToString:@"after"] )
    {
        value = [NSString stringWithFormat:@"%@%%", match];
    }
    else
    {
        value = [NSString stringWithFormat:@"%%%@%%", match];
    }
    
    NSMutableString * sql = [NSMutableString string];
    
    if ( _like.count )
    {
        [sql appendString:type];
    }
    
    field = [LionDatabase fieldNameForIdentifier:field];
    [sql appendFormat:@" %@", field];
    
    if ( invert )
    {
        [sql appendString:@" NOT"];
    }
    
    [sql appendFormat:@" LIKE '%@'", value];
    
    [_like addObject:sql];
}

- (void)internalHaving:(NSString *)key value:(NSObject *)value type:(NSString *)type
{
    if ( nil == key || nil == value )
        return;
    
    [_having addObject:[NSArray arrayWithObjects:key, value, type, nil]];
}

- (void)internalOrderBy:(NSString *)by direction:(NSString *)direction
{
    if ( nil == by || nil == direction )
        return;
    
    [_orderby addObject:[NSArray arrayWithObjects:by, direction, nil]];
}

#pragma mark -

- (NSString *)internalCompileSelect:(NSString *)override
{
    NSMutableString * sql = [NSMutableString string];
    
    if ( override )
    {
        [sql appendString:override];
    }
    else
    {
        if ( _distinct )
        {
            [sql appendString:@"SELECT DISTINCT "];
        }
        else
        {
            [sql appendString:@"SELECT "];
        }
        
        if ( _select.count )
        {
            [_select sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString * left = (NSString *)obj1;
                NSString * right = (NSString *)obj2;
                return [left compare:right options:NSCaseInsensitiveSearch];
            }];
            
            for ( NSInteger i = 0; i < _select.count; ++i )
            {
                NSString * select = [_select objectAtIndex:i];
                
                if ( 0 == i )
                {
                    [sql appendFormat:@"%@", select];
                }
                else
                {
                    [sql appendFormat:@", %@", select];
                }
            }
        }
        else
        {
            [sql appendString:@"*"];
        }
    }
    
    if ( _from.count )
    {
        [sql appendString:@" FROM "];
        
        for ( NSInteger i = 0; i < _from.count; ++i )
        {
            NSString * from = [_from objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendString:from];
            }
            else
            {
                [sql appendFormat:@", %@", from];
            }
        }
    }
    
    if ( _where.count || _like.count )
    {
        [sql appendString:@" WHERE"];
    }
    
    if ( _where.count )
    {
        for ( NSString * where in _where )
        {
            [sql appendFormat:@" %@ ", where];
        }
    }
    
    if ( _like.count )
    {
        if ( _where.count )
        {
            [sql appendString:@" AND "];
        }
        
        for ( NSString * like in _like )
        {
            [sql appendFormat:@" %@ ", like];
        }
    }
    
    if ( _groupby.count )
    {
        [sql appendString:@" GROUP BY "];
        
        for ( NSInteger i = 0; i < _groupby.count; ++i )
        {
            NSString * by = [_groupby objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendFormat:@"%@", by];
            }
            else
            {
                [sql appendFormat:@", %@", by];
            }
        }
    }
    
    if ( _having.count )
    {
        [sql appendString:@" HAVING "];
        
        for ( NSInteger i = 0; i < _having.count; ++i )
        {
            NSArray *	array = [_orderby objectAtIndex:i];
            NSString *	key = [array safeObjectAtIndex:0];
            NSString *	value = [array safeObjectAtIndex:1];
            NSString *	type = [array safeObjectAtIndex:2];
            
            if ( type )
            {
                [sql appendFormat:@"%@ ", type];
            }
            
            if ( [value isKindOfClass:[NSNull class]] )
            {
                [sql appendFormat:@"%@ IS NULL ", key];
            }
            else if ( [value isKindOfClass:[NSNumber class]] )
            {
                [sql appendFormat:@"%@ = %@ ", key, value];
            }
            else if ( [value isKindOfClass:[NSString class]] )
            {
                [sql appendFormat:@"%@ = '%@' ", key, value];
            }
            else
            {
                [sql appendFormat:@"%@ = '%@' ", key, value];
            }
        }
    }
    
    if ( _orderby.count )
    {
        [sql appendString:@" ORDER BY "];
        
        for ( NSInteger i = 0; i < _orderby.count; ++i )
        {
            NSArray *	array = [_orderby objectAtIndex:i];
            NSString *	by = [array safeObjectAtIndex:0];
            NSString *	dir = [array safeObjectAtIndex:1];
            
            if ( 0 == i )
            {
                [sql appendFormat:@"%@ %@", by, dir];
            }
            else
            {
                [sql appendFormat:@", %@ %@", by, dir];
            }
        }
    }
    
    if ( _limit )
    {
        if ( _offset )
        {
            [sql appendFormat:@" LIMIT %llu, %llu", (unsigned long long)_offset, (unsigned long long)_limit];
        }
        else
        {
            [sql appendFormat:@" LIMIT %llu", (unsigned long long)_limit];
        }
    }
    
    return sql;
}

- (NSString *)internalCompileInsert:(NSString *)table values:(NSMutableArray *)allValues
{
    NSMutableString *	sql = [NSMutableString string];
    NSMutableArray *	allKeys = [NSMutableArray arrayWithArray:_set.allKeys];
    
    NSString *			field = nil;
    NSObject *			value = nil;
    
    [allKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)obj1;
        NSString * right = (NSString *)obj2;
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    [sql appendFormat:@"INSERT INTO %@ (", table];
    
    for ( NSInteger i = 0; i < allKeys.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        NSString * key = [allKeys objectAtIndex:i];
        
        field = [LionDatabase fieldNameForIdentifier:key];
        value = [_set objectForKey:key];
        
        [sql appendString:field];
        [allValues addObject:value];
    }
    
    [sql appendString:@") VALUES ("];
    
    for ( NSInteger i = 0; i < allValues.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        [sql appendString:@"?"];
    }
    
    [sql appendString:@")"];
    
    return sql;
}

- (NSString *)internalCompileUpdate:(NSString *)table values:(NSMutableArray *)allValues
{
    NSMutableString *	sql = [NSMutableString string];
    NSMutableArray *	allKeys = [NSMutableArray arrayWithArray:_set.allKeys];
    
    NSString *			field = nil;
    NSString *			key = nil;
    NSObject *			value = nil;
    
    [allKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)obj1;
        NSString * right = (NSString *)obj2;
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    [sql appendFormat:@"UPDATE %@ SET ", table];
    
    for ( NSInteger i = 0; i < allKeys.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        key = [allKeys objectAtIndex:i];
        field = [LionDatabase fieldNameForIdentifier:key];
        value = [_set objectForKey:key];
        
        [sql appendFormat:@"%@ = ?", field];
        [allValues addObject:value];
    }
    
    if ( _where.count )
    {
        [sql appendString:@"\n"];
        [sql appendString:@" WHERE"];
        
        for ( NSString * where in _where )
        {
            [sql appendFormat:@" %@", where];
        }
    }
    
    if ( _orderby.count )
    {
        [sql appendString:@"\n"];
        [sql appendString:@" ORDER BY "];
        
        for ( NSInteger i = 0; i < _orderby.count; ++i )
        {
            NSString * by = [_orderby objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendString:by];
            }
            else
            {
                [sql appendFormat:@", %@", by];
            }
        }
    }
    
    if ( _limit )
    {
        [sql appendString:@"\n"];
        [sql appendFormat:@" LIMIT %lu", (unsigned long)_limit];
    }
    
    return sql;
}

- (NSString *)internalCompileCreate:(NSString *)table
{
    NSMutableString * sql = [NSMutableString string];
    
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", table];
    
    [_field sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)[(NSDictionary *)obj1 objectForKey:@"name"];
        NSString * right = (NSString *)[(NSDictionary *)obj2 objectForKey:@"name"];
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    for ( NSInteger i = 0; i < _field.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        NSDictionary * dict = [_field objectAtIndex:i];
        
        NSString * name = (NSString *)[dict objectForKey:@"name"];
        NSString * type = (NSString *)[dict objectForKey:@"type"];
        NSNumber * size = (NSNumber *)[dict objectForKey:@"size"];
        NSNumber * PK = (NSNumber *)[dict objectForKey:@"primaryKey"];
        NSNumber * AI = (NSNumber *)[dict objectForKey:@"autoIncrement"];
        NSNumber * UN = (NSNumber *)[dict objectForKey:@"unique"];
        NSNumber * NN = (NSNumber *)[dict objectForKey:@"notNull"];
        
        NSObject * defaultValue = [dict objectForKey:@"default"];
        
        [sql appendFormat:@"%@", name];
        
        if ( type )
        {
            [sql appendFormat:@" %@", type];
        }
        
        if ( size && size.intValue )
        {
            [sql appendFormat:@"(%@)", size];
        }
        
        if ( PK && PK.intValue )
        {
            [sql appendString:@" PRIMARY KEY"];
        }
        
        if ( AI && AI.intValue )
        {
            [sql appendString:@" AUTOINCREMENT"];
        }
        
        if ( UN && UN.intValue )
        {
            [sql appendString:@" UNIQUE"];
        }
        
        if ( NN && NN.intValue )
        {
            [sql appendString:@" NOT NULL"];
        }
        
        if ( defaultValue )
        {
            if ( [defaultValue isKindOfClass:[NSNull class]] )
            {
                [sql appendString:@" DEFAULT NULL"];
            }
            else if ( [defaultValue isKindOfClass:[NSNumber class]] )
            {
                [sql appendFormat:@" DEFAULT %@", defaultValue];
            }
            else if ( [defaultValue isKindOfClass:[NSString class]] )
            {
                [sql appendFormat:@" DEFAULT '%@'", defaultValue];
            }
            else
            {
                [sql appendFormat:@" DEFAULT '%@'", defaultValue];
            }
        }
    }
    
    [sql appendString:@" )\n"];
    
    return sql;
}

- (NSString *)internalCompileEmpty:(NSString *)table
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    return sql;
}

- (NSString *)internalCompileDelete:(NSString *)table
{
    NSMutableString * sql = [NSMutableString string];
    
    [sql appendFormat:@"DELETE FROM %@", table];
    
    if ( _where.count || _like.count )
    {
        [sql appendString:@" WHERE "];
        
        if ( _where.count )
        {
            for ( NSString * where in _where )
            {
                [sql appendFormat:@" %@ ", where];
            }
        }
        
        if ( _like.count )
        {
            if ( _where.count )
            {
                [sql appendString:@" AND "];
            }
            
            for ( NSString * like in _like )
            {
                [sql appendFormat:@" %@ ", like];
            }
        }
    }
    
    if ( _limit )
    {
        [sql appendFormat:@" LIMIT %lu", (unsigned long)_limit];
    }
    
    return sql;
}

- (NSString *)internalCompileTrunc:(NSString *)table
{
    NSString * sql = [NSString stringWithFormat:@"TRUNCATE %@", table];
    return sql;
}

- (NSString *)internalCompileIndex:(NSString *)table
{
    NSMutableString * sql = [NSMutableString string];
    
    [sql appendFormat:@"CREATE INDEX IF NOT EXISTS index_%@ ON %@ ( ", table, table];
    
    for ( NSInteger i = 0; i < _index.count; ++i )
    {
        NSString * field = [_index objectAtIndex:i];
        
        if ( 0 == i )
        {
            [sql appendFormat:@"%@", field];
        }
        else
        {
            [sql appendFormat:@", %@", field];
        }
    }
    
    [sql appendString:@" )"];
    
    return sql;
}

- (NSString *)internalCompileExist:(NSString *)table as:(NSString *)value
{
    NSMutableString * sql = [NSMutableString string];
    
    [sql appendFormat:@"SELECT COUNT(*) as '%@'\n", value];
    [sql appendFormat:@"FROM sqlite_master\n"];
    [sql appendFormat:@"WHERE type ='table' AND name = %@", table];
    
    return sql;
}

#pragma mark -

- (void)executeWriteOperations
{
    
}

- (void)executeWriteOperation
{
    
}

#pragma mark -

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier
{
    NSString * name = identifier.trim.unwrap;
    name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return name;
}

+ (NSString *)tableNameForIdentifier:(NSString *)identifier
{
    NSString * name = identifier.trim.unwrap;
    name = [name stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    name = [name stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    return name;
}

+ (NSString *)tableNameForClass:(Class)clazz
{
    if ( [clazz respondsToSelector:@selector(mapTableName)] )
    {
        return [clazz performSelector:@selector(mapTableName)];
    }
    
    return [NSString stringWithFormat:@"table_%@", [clazz description]];
}

- (Class)classType
{
    NSString * className = _classType.lastObject;
    if ( nil == className || 0 == className.length )
        return NULL;
    
    Class classType = NSClassFromString( className );
    if ( nil == classType || NO == [classType conformsToProtocol:@protocol(LionActiveProtocol)] )
        return NULL;
    
    return classType;
}

- (NSArray *)associateObjects
{
    return _associate;
}

- (NSArray *)associateObjectsFor:(Class)clazz
{
    NSMutableArray * array = [NSMutableArray array];
    
    for ( NSObject * obj in _associate )
    {
        if ( [obj isKindOfClass:clazz] )
        {
            [array addObject:obj];
        }
    }
    
    return array;
}

- (NSArray *)hasObjects
{
    return _has;
}

- (NSArray *)hasObjectsFor:(Class)clazz
{
    NSMutableArray * array = [NSMutableArray array];
    
    for ( NSObject * obj in _has )
    {
        if ( [obj isKindOfClass:clazz] )
        {
            [array addObject:obj];
        }
    }
    
    return array;
}

- (void)classType:(Class)clazz
{
    if ( nil == clazz )
        return;
    
    [_classType addObject:[clazz description]];
    
    [self from:[LionDatabase tableNameForClass:clazz]];
}

- (void)associate:(NSObject *)obj
{
    if ( nil == obj )
        return;
    
    [_associate addObject:obj];
}

- (void)has:(NSObject *)obj
{
    if ( nil == obj )
        return;
    
    [_has addObject:obj];
}

#pragma mark -

- (LionDatabaseBlockN)TABLE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self table:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)FIELD
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString *	field = (NSString *)first;
        NSString *	type = va_arg( args, NSString * );
        
        va_end( args );
        
        return [self field:field type:type size:0];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)FIELD_WITH_SIZE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString *	field = (NSString *)first;
        NSString *	type = va_arg( args, NSString * );
        NSUInteger	size = va_arg( args, NSUInteger );
        
        va_end( args );
        
        return [self field:field type:type size:size];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)UNSIGNED
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self unsignedType];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)NOT_NULL
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self notNull];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)PRIMARY_KEY
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self primaryKey];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)AUTO_INREMENT
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self autoIncrement];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)DEFAULT_ZERO
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self defaultZero];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)DEFAULT_NULL
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self defaultNull];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)DEFAULT
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self defaultValue:first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)UNIQUE
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self unique];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)CREATE_IF_NOT_EXISTS
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self createTableIfNotExists] ? self : nil;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)INDEX_ON
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSMutableArray * array = [NSMutableArray array];
        
        for ( ;; field = nil )
        {
            NSObject * name = field ? field : va_arg( args, NSObject * );
            if ( nil == name || NO == [name isKindOfClass:[NSString class]] )
                break;
            
            [array addObject:(NSString *)name];
        }
        
        va_end(args);
        
        return [self indexTable:nil on:array] ? self : nil;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self select:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_MAX
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self selectMax:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_MAX_ALIAS
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * field = (NSString *)first;
        NSString * alias = (NSString *)va_arg( args, NSString * );
        
        va_end( args );
        
        return [self selectMax:field alias:alias];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_MIN
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self selectMin:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_MIN_ALIAS
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * field = (NSString *)first;
        NSString * alias = (NSString *)va_arg( args, NSString * );
        
        va_end(args);
        
        return [self selectMin:field alias:alias];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_AVG
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self selectAvg:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_AVG_ALIAS
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * field = (NSString *)first;
        NSString * alias = (NSString *)va_arg( args, NSString * );
        
        va_end( args );
        
        return [self selectAvg:field alias:alias];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_SUM
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self selectSum:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SELECT_SUM_ALIAS
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * field = (NSString *)first;
        NSString * alias = (NSString *)va_arg( args, NSString * );
        
        va_end( args );
        
        return [self selectSum:field alias:alias];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)DISTINCT
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        return [self distinct:YES];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)FROM
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self from:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)WHERE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self where:key value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_WHERE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self orWhere:key value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)WHERE_OPERATOR
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSString * expr = (NSString *)va_arg( args, NSString * );
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self where:key expr:expr value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_WHERE_OPERATOR
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSString * expr = (NSString *)va_arg( args, NSString * );
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self orWhere:key expr:expr value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)WHERE_IN
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        
        va_end( args );
        
        return [self whereIn:key values:array];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_WHERE_IN
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        
        va_end( args );
        
        return [self orWhereIn:key values:array];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)WHERE_NOT_IN
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        
        va_end( args );
        
        return [self whereNotIn:key values:array];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_WHERE_NOT_IN
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        
        va_end( args );
        
        return [self orWhereNotIn:key values:array];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)LIKE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self like:key match:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)NOT_LIKE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self notLike:key match:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_LIKE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self orLike:key match:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_NOT_LIKE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self orNotLike:key match:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)GROUP_BY
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self groupBy:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)HAVING
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self having:key value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)OR_HAVING
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self orHaving:key value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)ORDER_ASC_BY
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self orderAscendBy:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)ORDER_DESC_BY
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self orderDescendBy:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)ORDER_RAND_BY
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self orderRandomBy:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)ORDER_BY
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * by = (NSString *)first;
        NSString * direction = (NSString *)va_arg( args, NSString * );
        
        va_end( args );
        
        return [self orderBy:by direction:direction];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockU)LIMIT
{
    LionDatabaseBlockU block = ^ LionDatabase * ( NSUInteger value )
    {
        return [self limit:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockU)OFFSET
{
    LionDatabaseBlockU block = ^ LionDatabase * ( NSUInteger value )
    {
        return [self offset:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SET_NULL
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        return [self set:(NSString *)first];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)SET
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        return [self set:key value:value];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseArrayBlock)GET
{
    LionDatabaseArrayBlock block = ^ NSArray * ( void )
    {
        return [self get];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseUintBlock)COUNT
{
    LionDatabaseUintBlock block = ^ NSUInteger ( void )
    {
        return [self count];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseIntBlock)INSERT
{
    LionDatabaseIntBlock block = ^ NSInteger ( void )
    {
        return [self insert];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBoolBlock)UPDATE
{
    LionDatabaseBoolBlock block = ^ BOOL ( void )
    {
        return [self update];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBoolBlock)EMPTY
{
    LionDatabaseBoolBlock block = ^ BOOL ( void )
    {
        return [self empty];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBoolBlock)TRUNCATE
{
    LionDatabaseBoolBlock block = ^ BOOL ( void )
    {
        return [self truncate];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBoolBlock)DELETE
{
    LionDatabaseBoolBlock block = ^ BOOL ( void )
    {
        return [self delete];
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)CLASS_TYPE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        [self classType:(Class)first];
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)ASSOCIATE
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        [self associate:first];
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)BELONG_TO
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        [self associate:first];
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlockN)HAS
{
    LionDatabaseBlockN block = ^ LionDatabase * ( id first, ... )
    {
        [self has:first];
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)BATCH_BEGIN
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        _batch = YES;
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)BATCH_END
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        _batch = NO;
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)LOCK
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        if ( _condition )
        {
            [_condition lock];
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

- (LionDatabaseBlock)UNLOCK
{
    LionDatabaseBlock block = ^ LionDatabase * ( void )
    {
        if ( _condition )
        {
            [_condition unlock];
        }
        
        return self;
    };
    
    return [[block copy] autorelease];
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( LionDatabase )
{
    TIMES( 3 )
    {
        HERE( "open and close DB", {
            [LionDatabase closeSharedDatabase];
            EXPECTED( nil == [LionDatabase sharedDatabase] );
            
            [LionDatabase openSharedDatabase:@"test"];
            EXPECTED( [LionDatabase sharedDatabase] );
        });
    }
    
    TIMES( 0 )
    {
        HERE( "create table", {
            self
            .DB
            .TABLE( @"blogs" )
            .FIELD( @"id", @"INTEGER" ).PRIMARY_KEY().AUTO_INREMENT()
            .FIELD( @"type", @"TEXT" )
            .FIELD( @"date", @"TEXT" )
            .FIELD( @"content", @"TEXT" )
            .CREATE_IF_NOT_EXISTS();
            
            EXPECTED( self.DB.succeed );
        });
        
        HERE( "index table", {
            self
            .DB
            .TABLE( @"blogs" )
            .INDEX_ON( @"id", nil );
            
            EXPECTED( self.DB.succeed );
        });
        
        HERE( "empty", {
            self
            .DB
            .FROM( @"blogs" )
            .EMPTY();
            
            EXPECTED( self.DB.succeed );
        });
        
        HERE( "insert", {
            self
            .DB
            .FROM( @"blogs" )
            .SET( @"type", @"Test" )
            .SET( @"date", [[NSDate date] description] )
            .SET( @"content", @"Hello, world!" )
            .INSERT();	// write once
            
            EXPECTED( self.DB.succeed );
        });
        
        HERE( "delete", {
            self
            .DB
            .FROM( @"blogs" )
            .WHERE( @"id", __INT(self.DB.insertID) )
            .DELETE();
            
            EXPECTED( self.DB.succeed );
        });
        
        HERE( "count", {
            self
            .DB
            .FROM( @"blogs" )
            .COUNT();
            
            EXPECTED( self.DB.succeed );
            EXPECTED( self.DB.resultCount == 0 );
        });
        
        HERE( "insert 30 rows", {
            for ( NSUInteger i = 0; i < 30; ++i )
            {
                self
                .DB
                .FROM( @"blogs" )
                .SET( @"date", [[NSDate date] description] )
                .SET( @"content", [NSString stringWithFormat:@"Some content %u", i] );
                
                if ( 0 == (i % 3) )
                {
                    self.DB.SET( @"type", @"A" );
                }
                else if ( 1 == (i % 3) )
                {
                    self.DB.SET( @"type", @"B" );
                }
                else if ( 2 == (i % 3) )
                {
                    self.DB.SET( @"type", @"C" );
                }
                
                self.DB.INSERT();
                
                EXPECTED( self.DB.succeed );
                EXPECTED( self.DB.insertID > 0 );
            }
        });
        
        HERE( "count all", {
            self
            .DB
            .FROM( @"blogs" )
            .COUNT();
            
            EXPECTED( self.DB.succeed );
            EXPECTED( self.DB.resultCount == 30 );
        });
        
        HERE( "count 'A'", {
            self
            .DB
            .FROM( @"blogs" )
            .WHERE( @"type", @"A" )
            .COUNT();
            
            EXPECTED( self.DB.succeed );
            EXPECTED( self.DB.resultCount == 10 );
        });
        
        HERE( "query", {
            for ( NSUInteger i = 0; i < 3; ++i )
            {
                self
                .DB
                .FROM( @"blogs" )
                .OFFSET( 10 * i )
                .LIMIT( 10 )
                .GET();
                
                EXPECTED( self.DB.succeed );
                EXPECTED( self.DB.resultCount > 0 );
                EXPECTED( self.DB.resultCount == self.DB.resultArray.count );
            }
        });
        
        HERE( "close", {
            [LionDatabase closeSharedDatabase];
        });
    }
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__
