//
//  CreatePbxproj.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "CreatePbxproj.h"
#import "BeeSandbox.h"
#import "CreateFile.h"
#import "NSString+LionExtension.h"
#import "Generate_Config.h"
#import "ProjectPaths.h"
#import "PBXNode.h"
#import "PBXBuildFile.h"
#import "PBXFileReference.h"
#import "PBXBuildPhase.h"
#import "PBXFrameworksBuildPhase.h"
#import "PBXResourcesBuildPhase.h"
#import "PBXSourcesBuildPhase.h"
#import "PBXGroup.h"
#import "PBXNativeTarget.h"
#import "PBXProject.h"
#import "XCBuildConfiguration.h"
#import "XCConfigurationList.h"
#import "ProjectBuilder.h"

static NSString *projectRootPath = @"/Users/rich/Desktop/test_pro";


@implementation CreatePbxproj

+ (void)createPbxprojectFile
{
    NSString *projPath = [NSString stringWithFormat:@"%@/Example.xcodeproj/",projectRootPath];
    NSString *projFile = [NSString stringWithFormat:@"%@/project.pbxproj",projPath];
    
    [BeeSandbox touch:projPath];//创建project.xcodeproj（工程文件）
    
    NSError* error = NULL;
    
    ProjectBuilder *builder = [self createProjectBuiderClass];
    
    NSString* projContent = [builder toString];
    
    BOOL succeed = [projContent writeToFile:projFile atomically:YES encoding:NSUTF8StringEncoding error:&error];//创建project.pbxproj(配置文件)
    if (succeed) {
        
        
    }
    
}

+ (ProjectBuilder*)createProjectBuiderClass
{
    NSString *applicationName = @"Example";
    
    ProjectBuilder * builder = [[ProjectBuilder alloc] init];
    builder.applicationName = applicationName;
    builder.organizationName = @"YourCompany";
    builder.deploymentTarget = @"5.0";
    
    [builder addFile:[NSString stringWithFormat:@"%@.app", applicationName]];
    [builder addFile:@"Info.plist"];
    [builder addFile:@"main.m"];
    [builder addFile:@"AppDelegate.h"];
    [builder addFile:@"AppDelegate.m"];
    
    [builder addFile:@"Model"];
    [builder addFile:@"View"];
    [builder addFile:@"Controller"];
    [builder addFile:@"System"];
    [builder addFile:@"Security"];
    [builder addFile:@"Theme"];
    [builder addFile:@"Config"];
    
    [builder addOtherFlag:@"ObjC"];
    
    
    
//    [builder addLibrary:@"xml2"];
//    [builder addLibrary:@"xml2.2"];
//    [builder addLibrary:@"sqlite3"];
//    [builder addLibrary:@"z"];
//    [builder addLibrary:@"z.1"];
    
//    [builder addFramework:@"AudioToolbox"];
//    [builder addFramework:@"CoreGraphics"];
//    [builder addFramework:@"CFNetwork"];
//    [builder addFramework:@"CoreFoundation"];
//    [builder addFramework:@"CoreMedia"];
//    [builder addFramework:@"CoreText"];
//    [builder addFramework:@"CoreVideo"];
//    [builder addFramework:@"Foundation"];
//    [builder addFramework:@"MobileCoreServices"];
//    [builder addFramework:@"Security"];
//    [builder addFramework:@"SystemConfiguration"];
//    [builder addFramework:@"UIKit"];
//    [builder addFramework:@"QuartzCore"];
    
    return builder;
}

@end
