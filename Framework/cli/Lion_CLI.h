//
//  Lion_CLI.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"

#if (TARGET_OS_MAC)

#pragma mark -

AS_PACKAGE( LionPackage, LionCLI, cli );

#pragma mark -

@class LionCLI;
typedef LionCLI * (^LionCLIBlock)( void );
typedef LionCLI * (^LionCLIBlockS)( NSString * text );
typedef LionCLI * (^LionCLIBlockN)( id first, ... );

#pragma mark -

@interface LionCLI : NSObject

AS_SINGLETON( LionCLI );

@property (nonatomic, retain) NSString *		color;
@property (nonatomic, assign) BOOL				autoChangeBack;

@property (nonatomic, readonly) LionCLIBlockN	ECHO;
@property (nonatomic, readonly) LionCLIBlockN	LINE;
@property (nonatomic, readonly) LionCLIBlock		RED;
@property (nonatomic, readonly) LionCLIBlock		BLUE;
@property (nonatomic, readonly) LionCLIBlock		CYAN;
@property (nonatomic, readonly) LionCLIBlock		GREEN;
@property (nonatomic, readonly) LionCLIBlock		YELLOW;
@property (nonatomic, readonly) LionCLIBlock		LIGHT_RED;
@property (nonatomic, readonly) LionCLIBlock		LIGHT_BLUE;
@property (nonatomic, readonly) LionCLIBlock		LIGHT_CYAN;
@property (nonatomic, readonly) LionCLIBlock		LIGHT_GREEN;
@property (nonatomic, readonly) LionCLIBlock		LIGHT_YELLOW;
@property (nonatomic, readonly) LionCLIBlock		NO_COLOR;

@property (nonatomic, retain) NSString *		workingDirectory;
@property (nonatomic, retain) NSString *		execPath;
@property (nonatomic, retain) NSString *		execName;
@property (nonatomic, retain) NSMutableArray *	arguments;

- (void)argc:(int)argc argv:(const char * [])argv;

- (NSString *)pathArgumentAtIndex:(NSUInteger)index;
- (NSString *)fileArgumentAtIndex:(NSUInteger)index;

@end

#endif	// #if (TARGET_OS_MAC)

