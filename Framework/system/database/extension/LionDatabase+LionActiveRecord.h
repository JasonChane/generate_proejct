//
//  LionDatabase+LionActiveRecord.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Database.h"
#import "Lion_ActiveProtocol.h"
#import "Lion_ActiveRecord.h"

#pragma mark -

@interface LionDatabase(LionActiveRecord)

@property (nonatomic, readonly) LionDatabaseObjectBlockN		SAVE;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		SAVE_DATA;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		SAVE_STRING;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		SAVE_ARRAY;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		SAVE_DICTIONARY;

@property (nonatomic, readonly) LionDatabaseArrayBlock		GET_RECORDS;
@property (nonatomic, readonly) LionDatabaseObjectBlock		FIRST_RECORD;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		FIRST_RECORD_BY_ID;
@property (nonatomic, readonly) LionDatabaseObjectBlock		LAST_RECORD;
@property (nonatomic, readonly) LionDatabaseObjectBlockN		LAST_RECORD_BY_ID;

- (id)saveData:(NSData *)data;
- (id)saveString:(NSString *)string;
- (id)saveArray:(NSArray *)array;
- (id)saveDictionary:(NSDictionary *)dict;

- (id)firstRecord;
- (id)firstRecord:(NSString *)table;
- (id)firstRecordByID:(id)key;
- (id)firstRecord:(NSString *)table byID:(id)key;

- (id)lastRecord;
- (id)lastRecord:(NSString *)table;
- (id)lastRecordByID:(id)key;
- (id)lastRecord:(NSString *)table byID:(id)key;

- (NSArray *)getRecords;
- (NSArray *)getRecords:(NSString *)table;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit;
- (NSArray *)getRecords:(NSString *)table limit:(NSUInteger)limit offset:(NSUInteger)offset;

@end
