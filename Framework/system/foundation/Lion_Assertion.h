//
//  Lion_Assertion.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_SystemConfig.h"
#import "Lion_SystemPackage.h"

#pragma mark -

#if __Lion_DEVELOPMENT__

#undef	ASSERT
#define ASSERT( __expr )	LionAssert( (__expr) ? YES : NO, #__expr, __PRETTY_FUNCTION__, __FILE__, __LINE__ )

#else	// #if __Lion_DEVELOPMENT__

#undef	ASSERT
#define ASSERT( __expr )

#endif	// #if __Lion_DEVELOPMENT__

#if __cplusplus
extern "C" {
#endif
    
    void LionAssertToggle( void );
    void LionAssertEnable( void );
    void LionAssertDisable( void );
    void LionAssert( BOOL flag, const char * expr, const char * function, const char * file, int line );
    
#if __cplusplus
};
#endif
