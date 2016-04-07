//
//  Lion_Service.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Foundation.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

AS_PACKAGE_( LionPackage, LionPackage_Service, services );

#pragma mark -

@class LionService;

typedef	void	(^LionServiceBlock)( void );
typedef	void	(^LionServiceBlockN)( id first, ... );

#pragma mark -

#undef	AS_SERVICE
#define	AS_SERVICE( __class, __name ) \
AS_PACKAGE( LionPackage_Service, __class, __name )

#undef	DEF_SERVICE
#define	DEF_SERVICE( __class, __name ) \
DEF_PACKAGE( LionPackage_Service, __class, __name )

#undef	AS_SUB_SERVICE
#define	AS_SUB_SERVICE( __parent, __class, __name ) \
AS_PACKAGE( __parent, __class, __name )

#undef	DEF_SUB_SERVICE
#define	DEF_SUB_SERVICE( __parent, __class, __name ) \
DEF_PACKAGE( __parent, __class, __name )

#pragma mark -

#undef	SERVICE_AUTO_LOADING
#define SERVICE_AUTO_LOADING( __flag ) \
+ (BOOL)serviceAutoLoading { return __flag; }

#undef	SERVICE_AUTO_POWERON
#define SERVICE_AUTO_POWERON( __flag ) \
+ (BOOL)serviceAutoPowerOn { return __flag; }

#pragma mark -

@protocol LionServiceExecutor<NSObject>

- (void)powerOn;
- (void)powerOff;

- (void)serviceWillActive;
- (void)serviceDidActived;
- (void)serviceWillDeactive;
- (void)serviceDidDeactived;

@end

#pragma mark -

@interface LionService : NSObject<LionServiceExecutor>

@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSBundle *			bundle;
@property (nonatomic, retain) NSDictionary *		launchParameters;

@property (nonatomic, readonly) BOOL				running;
@property (nonatomic, readonly) BOOL				activating;

@property (nonatomic, readonly) LionServiceBlock		ON;
@property (nonatomic, readonly) LionServiceBlock		OFF;

+ (instancetype)sharedInstance;

+ (BOOL)serviceAutoLoading;
+ (BOOL)serviceAutoPowerOn;

+ (BOOL)servicePreLoad;
+ (void)serviceDidLoad;

- (NSArray *)loadedServices;

@end

