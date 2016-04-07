//
//  Lion_HTTPConnection2.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_Socket.h"

#import "Lion_HTTPPackage.h"
#import "Lion_HTTPProtocol2.h"
#import "Lion_HTTPRequest2.h"
#import "Lion_HTTPResponse2.h"

#pragma mark -

@interface LionHTTPConnection2 : NSObject

@property (nonatomic, retain) LionSocket *			socket;
@property (nonatomic, retain) LionHTTPRequest2 *		request;
@property (nonatomic, retain) LionHTTPResponse2 *	response;

- (BOOL)acceptFrom:(LionSocket *)listener;

@end
