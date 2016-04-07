//
//  NSDictionary+LionActiveRecord.h
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "Lion_Precompile.h"
#import "Lion_Foundation.h"
#import "Lion_ActiveRecord.h"

#pragma mark -

@interface NSDictionary(LionActiveRecord)
- (LionActiveRecord *)objectToActiveRecord:(Class)clazz;
@end
