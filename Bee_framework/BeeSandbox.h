//
//  BeeSandbox.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeeSandbox : NSObject

+ (BOOL)touch:(NSString *)path;

+ (BOOL)touchFile:(NSString *)file;

@end
