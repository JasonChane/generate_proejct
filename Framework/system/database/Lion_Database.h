//
//  Lion_Database.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionDatabase, db );

#pragma mark -

@class FMDatabase;
@class LionDatabase;

typedef LionDatabase *	(^LionDatabaseBlockI)( NSInteger val );
typedef LionDatabase *	(^LionDatabaseBlockU)( NSUInteger val );
typedef LionDatabase *	(^LionDatabaseBlockN)( id key, ... );
typedef LionDatabase *	(^LionDatabaseBlockB)( BOOL flag );
typedef LionDatabase *	(^LionDatabaseBlock)( void );
typedef NSArray *		(^LionDatabaseArrayBlock)( void );
typedef NSArray *		(^LionDatabaseArrayBlockU)( NSUInteger val );
typedef NSArray *		(^LionDatabaseArrayBlockUN)( NSUInteger val, ... );
typedef id				(^LionDatabaseObjectBlock)( void );
typedef id				(^LionDatabaseObjectBlockN)( id key, ... );
typedef BOOL			(^LionDatabaseBoolBlock)( void );
typedef NSInteger		(^LionDatabaseIntBlock)( void );
typedef NSUInteger		(^LionDatabaseUintBlock)( void );

#pragma mark -

@interface LionDatabase : NSObject

AS_NOTIFICATION( SHARED_DB_OPEN )
AS_NOTIFICATION( SHARED_DB_CLOSE )

@property (nonatomic, assign) BOOL						autoOptimize;	// TO BE DONE
@property (nonatomic, retain) NSString *				filePath;

@property (nonatomic, assign) BOOL						shadow;
@property (atomic, retain) FMDatabase *					database;

@property (nonatomic, readonly) NSUInteger				total;
@property (nonatomic, readonly) BOOL					ready;
@property (nonatomic, readonly) NSInteger				identifier;

@property (nonatomic, readonly) LionDatabaseBlockN		TABLE;
@property (nonatomic, readonly) LionDatabaseBlockN		FIELD;
@property (nonatomic, readonly) LionDatabaseBlockN		FIELD_WITH_SIZE;
@property (nonatomic, readonly) LionDatabaseBlock		UNSIGNED;
@property (nonatomic, readonly) LionDatabaseBlock		NOT_NULL;
@property (nonatomic, readonly) LionDatabaseBlock		PRIMARY_KEY;
@property (nonatomic, readonly) LionDatabaseBlock		AUTO_INREMENT;
@property (nonatomic, readonly) LionDatabaseBlock		DEFAULT_ZERO;
@property (nonatomic, readonly) LionDatabaseBlock		DEFAULT_NULL;
@property (nonatomic, readonly) LionDatabaseBlockN		DEFAULT;
@property (nonatomic, readonly) LionDatabaseBlock		UNIQUE;
@property (nonatomic, readonly) LionDatabaseBlock		CREATE_IF_NOT_EXISTS;

@property (nonatomic, readonly) LionDatabaseBlockN		INDEX_ON;

@property (nonatomic, readonly) LionDatabaseBlockN		SELECT;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_MAX;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_MAX_ALIAS;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_MIN;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_MIN_ALIAS;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_AVG;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_AVG_ALIAS;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_SUM;
@property (nonatomic, readonly) LionDatabaseBlockN		SELECT_SUM_ALIAS;

@property (nonatomic, readonly) LionDatabaseBlock		DISTINCT;
@property (nonatomic, readonly) LionDatabaseBlockN		FROM;

@property (nonatomic, readonly) LionDatabaseBlockN		WHERE;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_WHERE;

@property (nonatomic, readonly) LionDatabaseBlockN		WHERE_OPERATOR;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_WHERE_OPERATOR;

@property (nonatomic, readonly) LionDatabaseBlockN		WHERE_IN;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_WHERE_IN;
@property (nonatomic, readonly) LionDatabaseBlockN		WHERE_NOT_IN;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_WHERE_NOT_IN;

@property (nonatomic, readonly) LionDatabaseBlockN		LIKE;
@property (nonatomic, readonly) LionDatabaseBlockN		NOT_LIKE;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_LIKE;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_NOT_LIKE;

@property (nonatomic, readonly) LionDatabaseBlockN		GROUP_BY;

@property (nonatomic, readonly) LionDatabaseBlockN		HAVING;
@property (nonatomic, readonly) LionDatabaseBlockN		OR_HAVING;

@property (nonatomic, readonly) LionDatabaseBlockN		ORDER_ASC_BY;
@property (nonatomic, readonly) LionDatabaseBlockN		ORDER_DESC_BY;
@property (nonatomic, readonly) LionDatabaseBlockN		ORDER_RAND_BY;
@property (nonatomic, readonly) LionDatabaseBlockN		ORDER_BY;

@property (nonatomic, readonly) LionDatabaseBlockU		LIMIT;
@property (nonatomic, readonly) LionDatabaseBlockU		OFFSET;

@property (nonatomic, readonly) LionDatabaseBlockN		SET;
@property (nonatomic, readonly) LionDatabaseBlockN		SET_NULL;

@property (nonatomic, readonly) LionDatabaseArrayBlock	GET;
@property (nonatomic, readonly) LionDatabaseUintBlock	COUNT;

@property (nonatomic, readonly) LionDatabaseIntBlock		INSERT;
@property (nonatomic, readonly) LionDatabaseBoolBlock	UPDATE;
@property (nonatomic, readonly) LionDatabaseBoolBlock	EMPTY;
@property (nonatomic, readonly) LionDatabaseBoolBlock	TRUNCATE;
@property (nonatomic, readonly) LionDatabaseBoolBlock	DELETE;

@property (nonatomic, readonly) LionDatabaseBlock		BATCH_BEGIN;
@property (nonatomic, readonly) LionDatabaseBlock		BATCH_END;

@property (nonatomic, readonly) LionDatabaseBlockN		CLASS_TYPE;	// for activeRecord
@property (nonatomic, readonly) LionDatabaseBlockN		ASSOCIATE;	// for activeRecord
@property (nonatomic, readonly) LionDatabaseBlockN		BELONG_TO;	// for activeRecord
@property (nonatomic, readonly) LionDatabaseBlockN		HAS;		// for activeRecord

@property (nonatomic, readonly) LionDatabaseBlock		LOCK;		// for multi-thread
@property (nonatomic, readonly) LionDatabaseBlock		UNLOCK;		// for multi-thread

@property (nonatomic, readonly) NSArray *				resultArray;
@property (nonatomic, readonly) NSUInteger				resultCount;
@property (nonatomic, readonly) NSInteger				insertID;
@property (nonatomic, readonly) BOOL					succeed;

@property (nonatomic, readonly) NSTimeInterval			lastQuery;
@property (nonatomic, readonly) NSTimeInterval			lastUpdate;

+ (BOOL)openSharedDatabase:(NSString *)path;
+ (BOOL)existsSharedDatabase:(NSString *)path;
+ (void)closeSharedDatabase;

+ (void)setSharedDatabase:(LionDatabase *)db;
+ (LionDatabase *)sharedDatabase;
+ (LionDatabase *)sharedInstance;	// same as sharedDatabase

+ (void)scopeEnter;
+ (void)scopeLeave;

- (id)initWithPath:(NSString *)path;
- (id)initWithDatabase:(FMDatabase *)db;

+ (BOOL)exists:(NSString *)path;
- (BOOL)open:(NSString *)path;
- (void)close;
- (void)clearState;

+ (NSString *)fieldNameForIdentifier:(NSString *)identifier;
+ (NSString *)tableNameForClass:(Class)clazz;

- (Class)classType;

- (NSArray *)associateObjects;
- (NSArray *)associateObjectsFor:(Class)clazz;

- (NSArray *)hasObjects;
- (NSArray *)hasObjectsFor:(Class)clazz;

// internal user only
- (void)__internalResetCreate;
- (void)__internalResetSelect;
- (void)__internalResetWrite;
- (void)__internalResetResult;
- (void)__internalSetResult:(NSArray *)array;

@end
