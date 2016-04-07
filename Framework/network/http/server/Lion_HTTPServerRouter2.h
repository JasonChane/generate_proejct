//
//  Lion_HTTPServerRouter2.h
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
#import "Lion_HTTPServer2.h"

#pragma mark -

AS_PACKAGE( LionHTTPServer2, LionHTTPServerRouter2, urls );
AS_PACKAGE( LionHTTPServer2, LionHTTPServerRouter2, router );

#pragma mark -

typedef void (^LionHTTPServerRouter2Block)( void );

#pragma mark -

@interface LionHTTPServerRouter2 : NSObject

AS_SINGLETON( LionHTTPServerRouter2 )

@property (nonatomic, copy) LionHTTPServerRouter2Block	index;
@property (nonatomic, retain) NSMutableDictionary *		routes;

- (BOOL)routes:(NSString *)url;

- (void)indexAction:(LionHTTPServerRouter2Block)block;
- (void)otherAction:(LionHTTPServerRouter2Block)block url:(NSString *)url;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
