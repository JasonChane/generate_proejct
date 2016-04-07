//
//  Lion_HTTPRouter2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_HTTPPackage.h"
#import "Lion_HTTPConnection2.h"

#pragma mark -

AS_PACKAGE( LionPackage_HTTP, LionHTTPRouter2, router );

#pragma mark -

typedef void (^LionHTTPRouter2Block)( void );

#pragma mark -

@interface LionHTTPRouter2 : NSObject

AS_SINGLETON( LionHTTPRouter2 )

@property (nonatomic, retain) NSMutableDictionary *	routes;
@property (nonatomic, copy) LionHTTPRouter2Block		index;

- (void)route:(NSString *)url;
- (void)route:(NSString *)url action:(LionHTTPRouter2Block)block;
- (void)index:(LionHTTPRouter2Block)block;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
