//
//  ProjectPaths.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectPaths : NSObject

+ (NSString*)mainFilePath;

+ (NSArray*)getGroups;

+ (NSString *)subGroupPath:(NSString*)groupName;

@end
