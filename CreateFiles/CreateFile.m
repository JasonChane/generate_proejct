//
//  CreateFile.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/8.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "CreateFile.h"
#import "BeeSandbox.h"
#import "CreateMain.h"
#import "CreateAppDelegate.h"
#import "CreatePlist.h"
#import "Generate_Config.h"
#import "ProjectPaths.h"
#import "CreatePbxproj.h"


static NSString *projectRootPath = @"/Users/rich/Desktop/test_pro";

@implementation CreateFile

+ (void)createProject
{
    
    [self createFiles];
    
    
}

+ (void)createFiles
{
    [CreatePbxproj createPbxprojectFile];
    
    [self createGroupFiles];
    
    [self createClassFiles];//创建类文件
    

}

+ (void)createGroupFiles
{
    [BeeSandbox touch:[ProjectPaths mainFilePath]];
    
    NSArray *subGroups = [ProjectPaths getGroups];
    for (NSString *groupName in subGroups)
    {
        [BeeSandbox touch:[ProjectPaths subGroupPath:groupName]];
    }
    
}


+ (void)createClassFiles
{
    
    [CreateMain createMain];
    
    [CreateAppDelegate createAppDelegateFile];
    
    [CreatePlist createPlistFile];
    
}




@end
