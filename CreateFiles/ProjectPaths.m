//
//  ProjectPaths.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "ProjectPaths.h"

static NSString *projectRootPath = @"/Users/rich/Desktop/test_pro";


@implementation ProjectPaths

+ (NSArray*)getGroups
{
    return @[@"Controller",@"View",@"Model",@"Theme",@"System",@"Security",@"Config",@"Test"];
    
}


+ (NSString*)mainFilePath
{
//    return projectRootPath;
    return [NSString stringWithFormat:@"%@/%@", projectRootPath,RootGroupName];
    
}

+ (NSString *)subGroupPath:(NSString*)groupName
{
    NSString *mainFilePath = [self mainFilePath];
    return [NSString stringWithFormat:@"%@/%@",mainFilePath,groupName];
    
}

@end
