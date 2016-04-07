//
//  Lion_Socket.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"

#pragma mark -

#undef	BEFORE_SOCKET
#define BEFORE_SOCKET( __sock ) \
- (void)prehandleSocket:(LionSocket *)__sock

#undef	AFTER_SOCKET
#define AFTER_SOCKET( __sock ) \
- (void)posthandleSocket:(LionSocket *)__sock

#undef	ON_SOCKET
#define ON_SOCKET( __sock ) \
- (void)handleSocket:(LionSocket *)__sock

#pragma mark -

@class LionSocket;

@interface NSObject(LionSocket)
- (BOOL)isSocketResponder;
- (BOOL)prehandleSocket:(LionSocket *)socket;
- (void)posthandleSocket:(LionSocket *)socket;
- (void)handleSocket:(LionSocket *)socket;
@end

#pragma mark -

typedef void (^LionSocketBlock)( void );

#pragma mark -

@interface LionSocket : NSObject

AS_INT( ROLE_CLIENT );
AS_INT( ROLE_SERVER );
AS_INT( ROLE_DAEMON );

AS_INT( STATE_CREATED );
AS_INT( STATE_CONNECTING );
AS_INT( STATE_CONNECTED );
AS_INT( STATE_READY );
AS_INT( STATE_DISCONNECTING );
AS_INT( STATE_DISCONNECTED );

AS_INT( ERROR_OK );
AS_INT( ERROR_IO );
AS_INT( ERROR_RESOLVE_HOST );
AS_INT( ERROR_CONNECTION_TIMEOUT );
AS_INT( ERROR_CONNECTION_RESET );
AS_INT( ERROR_UNKNOWN );

@property (nonatomic, assign) NSUInteger				role;
@property (nonatomic, readonly) BOOL					isClient;
@property (nonatomic, readonly) BOOL					isServer;
@property (nonatomic, readonly) BOOL					isDaemon;

@property (nonatomic, assign) NSUInteger				state;
@property (nonatomic, readonly) BOOL					created;
@property (nonatomic, readonly) BOOL					connecting;
@property (nonatomic, readonly) BOOL					connected;
@property (nonatomic, readonly) BOOL					accepting;
@property (nonatomic, readonly) BOOL					accepted;
@property (nonatomic, readonly) BOOL					disconnecting;
@property (nonatomic, readonly) BOOL					disconnected;
@property (nonatomic, readonly) BOOL					stopping;
@property (nonatomic, readonly) BOOL					stopped;
@property (nonatomic, readonly) BOOL					listenning;
@property (nonatomic, readonly) BOOL					acceptable;
@property (nonatomic, readonly) BOOL					writable;
@property (nonatomic, readonly) BOOL					readable;
@property (nonatomic, readonly) BOOL					heartBeat;

@property (nonatomic, retain) NSMutableArray *			responders;
//@property (nonatomic, assign) id						responder;

@property (nonatomic, assign) NSInteger					errorCode;
@property (nonatomic, retain) NSMutableDictionary *		userInfo;
@property (nonatomic, retain) NSObject *				userObject;

@property (nonatomic, copy) LionSocketBlock				whenUpdate;
@property (nonatomic, copy) LionSocketBlock				whenConnecting;
@property (nonatomic, copy) LionSocketBlock				whenConnected;
@property (nonatomic, copy) LionSocketBlock				whenAccepting;
@property (nonatomic, copy) LionSocketBlock				whenAccepted;
@property (nonatomic, copy) LionSocketBlock				whenDisconnecting;
@property (nonatomic, copy) LionSocketBlock				whenDisconnected;
@property (nonatomic, copy) LionSocketBlock				whenStopping;
@property (nonatomic, copy) LionSocketBlock				whenStopped;
@property (nonatomic, copy) LionSocketBlock				whenListenning;
@property (nonatomic, copy) LionSocketBlock				whenAcceptable;
@property (nonatomic, copy) LionSocketBlock				whenWritable;
@property (nonatomic, copy) LionSocketBlock				whenReadable;
@property (nonatomic, copy) LionSocketBlock				whenHeartBeat;

@property (nonatomic, retain) NSString *				host;
@property (nonatomic, assign) NSUInteger				port;

@property (nonatomic, readonly) NSMutableData *			readBuffer;
@property (nonatomic, readonly) NSMutableData *			sendBuffer;

@property (nonatomic, readonly) NSUInteger				readableSize;
@property (nonatomic, readonly) NSData *				readableData;
@property (nonatomic, readonly) NSString *				readableString;

@property (nonatomic, assign) BOOL						autoConsume;
@property (nonatomic, assign) BOOL						autoReconnect;
@property (nonatomic, assign) BOOL						autoHeartbeat;

@property (nonatomic, readonly) NSUInteger				readBytes;
@property (nonatomic, readonly) NSUInteger				sentBytes;

+ (LionSocket *)socket;
+ (LionSocket *)socket:(int)sock;
+ (LionSocket *)socket:(int)sock responder:(id)responder;

+ (NSArray *)sockets;

- (BOOL)hasResponder:(id)responder;
- (void)addResponder:(id)responder;
- (void)removeResponder:(id)responder;
- (void)removeAllResponders;

// client

- (BOOL)connect:(NSString *)addr;
- (BOOL)connect:(NSString *)addr port:(NSUInteger)port;
- (void)disconnect;

- (BOOL)send:(id)data;
- (BOOL)send:(id)data encoding:(NSStringEncoding)encoding;
- (BOOL)send:(void *)bytes length:(NSUInteger)length;
- (BOOL)sendEOL;
- (BOOL)sendEOF;

- (NSData *)read;
- (NSData *)read:(NSUInteger)length;
- (NSData *)read:(NSUInteger)length remove:(BOOL)remove;
- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset;
- (NSData *)read:(NSUInteger)length offset:(NSUInteger)offset remove:(BOOL)remove;

// server

- (BOOL)listen:(NSUInteger)port;
- (void)stop;

- (void)refuse;
- (void)refuseAll;

- (LionSocket *)accept;

@end
