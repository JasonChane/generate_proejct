//
//  Lion_Runtime.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"
#import "NSObject+LionProperty.h"

#pragma mark -

AS_PACKAGE( LionPackage_System, LionRuntime, runtime );

#pragma mark -

#undef	PRINT_CALLSTACK
#define PRINT_CALLSTACK( __n )	[LionRuntime printCallstack:__n]

#undef	BREAK_POINT
#define BREAK_POINT()			[LionRuntime breakPoint];

#undef	BREAK_POINT_IF
#define BREAK_POINT_IF( __x )	if ( __x ) { [LionRuntime breakPoint]; }

#undef	BB
#define BB						[LionRuntime breakPoint];

#pragma mark -

@interface LionTypeEncoding : NSObject

AS_INT( UNKNOWN )
AS_INT( OBJECT )
AS_INT( NSNUMBER )
AS_INT( NSSTRING )
AS_INT( NSARRAY )
AS_INT( NSDICTIONARY )
AS_INT( NSDATE )

+ (BOOL)isReadOnly:(const char *)attr;

+ (NSUInteger)typeOf:(const char *)attr;
+ (NSUInteger)typeOfAttribute:(const char *)attr;
+ (NSUInteger)typeOfObject:(id)obj;

+ (NSString *)classNameOf:(const char *)attr;
+ (NSString *)classNameOfAttribute:(const char *)attr;

+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;

@end

#pragma mark -

@interface LionCallFrame : NSObject

AS_INT( TYPE_UNKNOWN )
AS_INT( TYPE_OBJC )
AS_INT( TYPE_NATIVEC )

@property (nonatomic, assign) NSUInteger	type;
@property (nonatomic, retain) NSString *	process;
@property (nonatomic, assign) NSUInteger	entry;
@property (nonatomic, assign) NSUInteger	offset;
@property (nonatomic, retain) NSString *	clazz;
@property (nonatomic, retain) NSString *	method;

+ (id)parse:(NSString *)line;
+ (id)unknown;

@end

#pragma mark -

@interface LionRuntime : NSObject

@property (nonatomic, readonly) NSArray *	allClasses;
@property (nonatomic, readonly) NSArray *	callstack;
@property (nonatomic, readonly) NSArray *	callframes;

AS_SINGLETON( LionRuntime )

+ (id)allocByClass:(Class)clazz;
+ (id)allocByClassName:(NSString *)clazzName;

+ (NSArray *)allClasses;
+ (NSArray *)allSubClassesOf:(Class)clazz;

+ (NSArray *)allInstanceMethodsOf:(Class)clazz;
+ (NSArray *)allInstanceMethodsOf:(Class)clazz withPrefix:(NSString *)prefix;

+ (NSArray *)callstack:(NSUInteger)depth;
+ (NSArray *)callframes:(NSUInteger)depth;

+ (void)printCallstack:(NSUInteger)depth;
+ (void)breakPoint;

@end
