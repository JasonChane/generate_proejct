//
//  Lion_ActiveObject.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_ActiveProtocol.h"

#pragma mark -

@interface LionNonValue : NSObject
+ (LionNonValue *)value;
@end

#pragma mark -

@interface LionActiveObject : NSObject
- (BOOL)validate;
@end

#pragma mark -

@interface NSObject(LionActiveObject)

+ (BOOL)isRelationMapped;
+ (void)mapRelation;						// for subclass
+ (void)mapRelationForClass:(Class)clazz;	// for subclass

+ (void)mapPropertyAsKey:(NSString *)name;
+ (void)mapPropertyAsKey:(NSString *)name defaultValue:(id)value;
+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path;
+ (void)mapPropertyAsKey:(NSString *)name atPath:(NSString *)path defaultValue:(id)value;

+ (void)mapProperty:(NSString *)name;
+ (void)mapProperty:(NSString *)name defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name atPath:(NSString *)path;
+ (void)mapProperty:(NSString *)name atPath:(NSString *)path defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path;
+ (void)mapProperty:(NSString *)name forClass:(NSString *)className atPath:(NSString *)path defaultValue:(id)value;
+ (void)mapProperty:(NSString *)name associateTo:(NSString *)clazz;
+ (void)mapProperty:(NSString *)name associateTo:(NSString *)clazz defaultValue:(id)value;

+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className;
+ (void)mapPropertyAsArray:(NSString *)name forClass:(NSString *)className defaultValue:(id)value;

+ (void)mapPropertyAsArray:(NSString *)name;
+ (void)mapPropertyAsArray:(NSString *)name defaultValue:(id)value;

+ (void)mapPropertyAsDictionary:(NSString *)name;
+ (void)mapPropertyAsDictionary:(NSString *)name defaultValue:(id)value;

#pragma mark -

+ (NSString *)mapTableName;					// for subclass

#pragma mark -

+ (void)useAutoIncrement;
+ (void)useAutoIncrementFor:(Class)clazz;
+ (BOOL)usingAutoIncrement;
+ (BOOL)usingAutoIncrementFor:(Class)clazz;

+ (void)useAutoIncrementFor:(Class)clazz andProperty:(NSString *)name;
+ (BOOL)usingAutoIncrementFor:(Class)clazz andProperty:(NSString *)name;

+ (void)useAutoIncrementForProperty:(NSString *)name;
+ (BOOL)usingAutoIncrementForProperty:(NSString *)name;

+ (void)useUniqueFor:(Class)clazz andProperty:(NSString *)name;
+ (BOOL)usingUniqueFor:(Class)clazz andProperty:(NSString *)name;

+ (void)useUniqueForProperty:(NSString *)name;
+ (BOOL)usingUniqueForProperty:(NSString *)name;

+ (void)useJSON;
+ (void)useJSONFor:(Class)clazz;
+ (BOOL)usingJSON;
+ (BOOL)usingJSONFor:(Class)clazz;

#pragma mark -

- (NSString *)activePrimaryKey;
- (NSString *)activeJSONKey;

+ (NSString *)activePrimaryKey;
+ (NSString *)activePrimaryKeyFor:(Class)clazz;

+ (NSString *)activeJSONKey;
+ (NSString *)activeJSONKeyFor:(Class)clazz;

- (NSMutableDictionary *)activePropertySet;
+ (NSMutableDictionary *)activePropertySet;
+ (NSMutableDictionary *)activePropertySetFor:(Class)clazz;

#pragma mark -

+ (NSString *)fieldNameForIdentifier:(NSString *)string;
+ (NSString *)identifierForFieldName:(NSString *)string;

@end
