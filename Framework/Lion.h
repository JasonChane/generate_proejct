//
//  Lion.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Package.h"
#import "Lion_Version.h"
#import "Lion_Vendor.h"

#import "Lion_CLI.h"
//#import "Lion_MVC.h"
#import "Lion_System.h"

#pragma mark -

@class LionPackage;
extern LionPackage *	Lion;

#pragma mark -

AS_PACKAGE_( LionPackage, LionPackage_External, ext );

#undef	AS_EXTERNAL
#define	AS_EXTERNAL( __class, __name ) \
AS_PACKAGE( LionPackage_External, __class, __name )

#undef	DEF_EXTERNAL
#define	DEF_EXTERNAL( __class, __name ) \
DEF_PACKAGE( LionPackage_External, __class, __name )

#pragma mark -

AS_PACKAGE_( LionPackage, LionPackage_Library, lib );

#undef	AS_LIBRARY
#define	AS_LIBRARY( __class, __name ) \
AS_PACKAGE( LionPackage_Library, __class, __name )

#undef	DEF_LIBRARY
#define	DEF_LIBRARY( __class, __name ) \
DEF_PACKAGE( LionPackage_Library, __class, __name )
