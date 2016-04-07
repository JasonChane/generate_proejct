//
//  PListBuilder.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/11.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PListBuilder : NSObject

+ (NSString *)objectToString:(id)obj indent:(int)indent;

@end
