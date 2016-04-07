//
//  Lion_ActiveProtocol.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Database.h"

#pragma mark -

@protocol LionActiveProtocol<NSObject>

@property (nonatomic, readonly) LionDatabaseBoolBlock	EXISTS;		// COUNT WHERE '<your primary key>' = id
@property (nonatomic, readonly) LionDatabaseBoolBlock	LOAD;		// GET
@property (nonatomic, readonly) LionDatabaseBoolBlock	SAVE;		// INSERT if failed to UPDATE
@property (nonatomic, readonly) LionDatabaseBoolBlock	INSERT;
@property (nonatomic, readonly) LionDatabaseBoolBlock	UPDATE;
@property (nonatomic, readonly) LionDatabaseBoolBlock	DELETE;

@property (nonatomic, readonly) NSString *				primaryKey;
@property (nonatomic, retain) NSNumber *				primaryID;

@property (nonatomic, readonly) BOOL					inserted;
@property (nonatomic, readonly) BOOL					deleted;
@property (nonatomic, assign) BOOL						changed;

@property (nonatomic, retain) NSMutableDictionary *		JSON;
@property (nonatomic, retain) NSData *					JSONData;
@property (nonatomic, retain) NSString *				JSONString;

- (id)initWithKey:(id)key;
- (id)initWithObject:(NSObject *)object;
- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithJSONData:(NSData *)data;
- (id)initWithJSONString:(NSString *)string;

- (void)setDictionary:(NSDictionary *)dict;

@end
