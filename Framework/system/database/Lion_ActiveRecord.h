//
//  Lion_ActiveRecord.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Database.h"
#import "Lion_ActiveObject.h"
#import "Lion_ActiveProtocol.h"

#pragma mark -

@interface LionActiveRecord : LionActiveObject<LionActiveProtocol>

AS_NUMBER( INVALID_ID )

+ (id)record;
+ (id)record:(NSObject *)otherObject;

+ (id)recordWithKey:(NSNumber *)key;
+ (id)recordWithObject:(NSObject *)otherObject;
+ (id)recordWithDictionary:(NSDictionary *)dict;
+ (id)recordsWithArray:(NSArray *)array;
+ (id)recordWithJSONData:(NSData *)data;
+ (id)recordWithJSONString:(NSString *)string;

+ (id)recordFromNumber:(NSNumber *)key;				// alias
+ (id)recordFromObject:(NSObject *)otherObject;		// alias
+ (id)recordFromDictionary:(NSDictionary *)dict;	// alias
+ (id)recordsFromArray:(NSArray *)array;			// alias
+ (id)recordFromJSONData:(NSData *)data;			// alias
+ (id)recordFromJSONString:(NSString *)string;		// alias

@end
