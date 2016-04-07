//
//  ProjectBuilder.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "ProjectBuilder.h"
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
#import "PListBuilder.h"

static NSString *projectRootPath = @"/Users/rich/Desktop/test_pro";

@implementation ProjectBuilder

- (id)init
{
    self = [super init];
    if (self) {
        _fileNames = [NSMutableArray array];
        _libraries = [NSMutableArray array];
        _frameworks = [NSMutableArray array];
        _otherFlags = [NSMutableArray array];
        _architectures = [NSMutableArray array];
        _headerSearchPaths = [NSMutableArray array];
        _librarySearchPaths = [NSMutableArray array];

    }
    return self;
}


- (void)addFile:(NSString *)file
{
    [self.fileNames addObject:file];
}

- (void)addLibrary:(NSString *)lib
{
    [self.libraries addObject:lib];
}

- (void)addFramework:(NSString *)framework
{
    [self.frameworks addObject:framework];
}

- (void)addOtherFlag:(NSString *)flag
{
    [self.otherFlags addObject:flag];
}

- (void)addArchitecture:(NSString *)arch
{
    [self.architectures addObject:arch];
}

- (void)addHeaderSearchPath:(NSString *)path
{
    [self.headerSearchPaths addObject:path];
}

- (void)addLibrarySearchPath:(NSString *)path
{
    [self.librarySearchPaths addObject:path];
}

- (NSArray *)linkFlags
{
    NSMutableArray * linkFlags = [NSMutableArray array];
    
    for ( NSString * flag in self.otherFlags )
    {
        [linkFlags addObject:[NSString stringWithFormat:@"-%@", flag]];
    }
    
    for ( NSString * lib in self.libraries )
    {
        [linkFlags addObject:[NSString stringWithFormat:@"-l%@", lib]];
    }
    
    for ( NSString * framework in self.frameworks )
    {
        [linkFlags addObject:@"-framework"];
        [linkFlags addObject:framework];
    }
    
    return linkFlags;
}

- (NSDictionary *)defaultProjectSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ALWAYS_SEARCH_USER_PATHS"]			= @"NO";
    buildSetting[@"CLANG_CXX_LANGUAGE_STANDARD"]		= @"gnu++0x";
    buildSetting[@"CLANG_CXX_LIBRARY"]					= @"libc++";
    buildSetting[@"CLANG_WARN_CONSTANT_CONVERSION"]		= @"YES";
    buildSetting[@"CLANG_WARN_EMPTY_BODY"]				= @"YES";
    buildSetting[@"CLANG_WARN_ENUM_CONVERSION"]			= @"YES";
    buildSetting[@"CLANG_WARN_INT_CONVERSION"]			= @"YES";
    buildSetting[@"CLANG_WARN__DUPLICATE_METHOD_MATCH"]	= @"YES";
    buildSetting[@"CODE_SIGN_IDENTITY[sdk=iphoneos*]"]	= @"iPhone Developer";
    buildSetting[@"COPY_PHASE_STRIP"]					= @"NO";
    buildSetting[@"GCC_C_LANGUAGE_STANDARD"]			= @"gnu99";
    buildSetting[@"GCC_WARN_ABOUT_RETURN_TYPE"]			= @"YES";
    buildSetting[@"GCC_WARN_UNINITIALIZED_AUTOS"]		= @"YES";
    buildSetting[@"GCC_WARN_UNUSED_VARIABLE"]			= @"YES";
    buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]			= @"6.1";
    buildSetting[@"SDKROOT"]							= @"iphoneos";
    
    return buildSetting;
}

- (NSDictionary *)debugProjectSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    [buildSetting addEntriesFromDictionary:[self defaultProjectSetting]];
    
    buildSetting[@"GCC_DYNAMIC_NO_PIC"]					= @"NO";
    buildSetting[@"GCC_OPTIMIZATION_LEVEL"]				= @0;
    buildSetting[@"GCC_PREPROCESSOR_DEFINITIONS"]		= @[@"DEBUG=1", @"$(inherited)"];
    buildSetting[@"GCC_SYMBOLS_PRIVATE_EXTERN"]			= @"NO";
    buildSetting[@"ONLY_ACTIVE_ARCH"]					= @"YES";
    
    return buildSetting;
}

- (NSDictionary *)releaseProjectSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    [buildSetting addEntriesFromDictionary:[self defaultProjectSetting]];
    
    buildSetting[@"OTHER_CFLAGS"]						= @"-DNS_BLOCK_ASSERTIONS=1";
    buildSetting[@"VALIDATE_PRODUCT"]					= @"YES";
    
    return buildSetting;
}

- (NSDictionary *)defaultTargetSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ARCHS"]							= self.architectures;
    buildSetting[@"GCC_PRECOMPILE_PREFIX_HEADER"]	= @"YES";
    buildSetting[@"HEADER_SEARCH_PATHS"]			= self.headerSearchPaths;
    buildSetting[@"LIBRARY_SEARCH_PATHS"]			= self.librarySearchPaths;
//    buildSetting[@"GCC_PREFIX_HEADER"]				= [NSString stringWithFormat:@"%@/%@-Prefix.pch", self.applicationName, self.applicationName];
    buildSetting[@"INFOPLIST_FILE"]					= [NSString stringWithFormat:@"%@/%@-Info.plist", self.applicationName, self.applicationName];
    buildSetting[@"INFOPLIST_FILE"]                 = @"./Example/Info.plist";//暂时写死路径
    buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]		= self.deploymentTarget;
    buildSetting[@"OTHER_LDFLAGS"]					= [self linkFlags];
    buildSetting[@"PRODUCT_NAME"]					= @"$(TARGET_NAME)";
    buildSetting[@"WRAPPER_EXTENSION"]				= @"app";
    
    return buildSetting;
}

- (NSDictionary *)debugTargetSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    [buildSetting addEntriesFromDictionary:[self defaultTargetSetting]];
    return buildSetting;
}

- (NSDictionary *)releaseTargetSetting
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    [buildSetting addEntriesFromDictionary:[self defaultTargetSetting]];
    return buildSetting;
}

- (NSDictionary *)releaseProjectSetting_new
{
    //    ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
    //    "CODE_SIGN_IDENTITY[sdk=iphoneos*]" = "iPhone Developer";
    //    ENABLE_STRICT_OBJC_MSGSEND = YES;
    //    INFOPLIST_FILE = ./Example/Info.plist;
    //    IPHONEOS_DEPLOYMENT_TARGET = 9.0;
    //    LD_RUNPATH_SEARCH_PATHS = "$(inherited) @executable_path/Frameworks";
    //    MTL_ENABLE_DEBUG_INFO = NO;
    //    PRODUCT_BUNDLE_IDENTIFIER = com.ifangchou.Example;
    //    PRODUCT_NAME = "$(TARGET_NAME)";
    //    SDKROOT = iphoneos;
    
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ASSETCATALOG_COMPILER_APPICON_NAME"]		= @"NO";
    buildSetting[@"CODE_SIGN_IDENTITY[sdk=iphoneos*]"]      = @"iPhone Developer";
    buildSetting[@"ENABLE_STRICT_OBJC_MSGSEND"]             = @"YES";
    buildSetting[@"INFOPLIST_FILE"]                         = @"./Example/Info.plist";
    buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]				= @"9.0";
    buildSetting[@"LD_RUNPATH_SEARCH_PATHS"]                = @"$(inherited) @executable_path/Frameworks";
    buildSetting[@"MTL_ENABLE_DEBUG_INFO"]                  = @"NO";
    buildSetting[@"PRODUCT_BUNDLE_IDENTIFIER"]              = @"com.ifangchou.Example";
    buildSetting[@"PRODUCT_NAME"]                           = @"$(TARGET_NAME)";
    buildSetting[@"SDKROOT"]                                = @"iphoneos";
    
    return buildSetting;
}

- (NSDictionary *)releaseTargetSetting_new
{
    
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ALWAYS_SEARCH_USER_PATHS"]		= @"NO";
    buildSetting[@"CLANG_CXX_LANGUAGE_STANDARD"]    = @"gnu++0x";
    buildSetting[@"CLANG_CXX_LIBRARY"]              = @"libc++";
    buildSetting[@"CLANG_ENABLE_OBJC_ARC"]              = @"YES";
    buildSetting[@"CLANG_ENABLE_MODULES"]               = @"YES";
    buildSetting[@"CLANG_WARN_BOOL_CONVERSION"]         = @"YES";
    buildSetting[@"CLANG_WARN_CONSTANT_CONVERSION"]     = @"YES";
    buildSetting[@"CLANG_WARN_DIRECT_OBJC_ISA_USAGE"]   = @"YES";
    buildSetting[@"CLANG_WARN_EMPTY_BODY"]              = @"YES";
    buildSetting[@"CLANG_WARN_ENUM_CONVERSION"]         = @"YES";
    buildSetting[@"CLANG_WARN_INT_CONVERSION"]          = @"YES";
    buildSetting[@"CLANG_WARN_OBJC_ROOT_CLASS"]         = @"YES";
    buildSetting[@"CLANG_WARN_UNREACHABLE_CODE"]        = @"YES";
    buildSetting[@"CLANG_WARN__DUPLICATE_METHOD_MATCH"] = @"YES";
    buildSetting[@"COPY_PHASE_STRIP"]                   = @"YES";
    buildSetting[@"ENABLE_NS_ASSERTIONS"]               = @"NO";
    buildSetting[@"GCC_C_LANGUAGE_STANDARD"]            = @"gnu99";
    buildSetting[@"GCC_WARN_64_TO_32_BIT_CONVERSION"]   = @"YES";
    buildSetting[@"GCC_WARN_ABOUT_RETURN_TYPE"]         = @"YES";
    buildSetting[@"GCC_WARN_UNDECLARED_SELECTOR"]       = @"YES";
    buildSetting[@"GCC_WARN_UNINITIALIZED_AUTOS"]       = @"YES";
    buildSetting[@"GCC_WARN_UNUSED_FUNCTION"]           = @"YES";
    buildSetting[@"GCC_WARN_UNUSED_VARIABLE"]           = @"YES";
    buildSetting[@"VALIDATE_PRODUCT"]                   = @"YES";
    
    
    return buildSetting;
    
}

- (NSDictionary *)debugProjSetting_new
{

    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ASSETCATALOG_COMPILER_APPICON_NAME"]          = @"AppIcon";
    buildSetting[@"CODE_SIGN_IDENTITY[sdk=iphoneos*]"]           = @"iPhone Developer";
    buildSetting[@"ENABLE_STRICT_OBJC_MSGSEND"]                  = @"YES";
    buildSetting[@"INFOPLIST_FILE"]                              = @"./Example/Info.plist";
    buildSetting[@"IPHONEOS_DEPLOYMENT_TARGET"]                  = @"9.0";
    buildSetting[@"LD_RUNPATH_SEARCH_PATHS"]                     = @"$(inherited) @executable_path/Frameworks";
    buildSetting[@"MTL_ENABLE_DEBUG_INFO"]                       = @"YES";
    buildSetting[@"PRODUCT_BUNDLE_IDENTIFIER"]                   = @"com.ifangchou.Example";
    buildSetting[@"PRODUCT_NAME"]                                = @"$(TARGET_NAME)";
    buildSetting[@"SDKROOT"]                                     = @"iphoneos";
    
    return buildSetting;
    
}

- (NSDictionary *)debugTargetSetting_new
{
    NSMutableDictionary * buildSetting = [NSMutableDictionary dictionary];
    
    buildSetting[@"ALWAYS_SEARCH_USER_PATHS"]               = @"NO";
    buildSetting[@"CLANG_CXX_LANGUAGE_STANDARD"]            = @"gnu++0x";
    buildSetting[@"CLANG_CXX_LIBRARY"]                      = @"libc++";
    buildSetting[@"CLANG_ENABLE_MODULES"]                   = @"YES";
    buildSetting[@"CLANG_ENABLE_OBJC_ARC"]                  = @"YES";
    buildSetting[@"CLANG_WARN_BOOL_CONVERSION"]             = @"YES";
    buildSetting[@"CLANG_WARN_CONSTANT_CONVERSION"]         = @"YES";
    buildSetting[@"CLANG_WARN_DIRECT_OBJC_ISA_USAGE"]       = @"YES";
    buildSetting[@"CLANG_WARN_EMPTY_BODY"]                  = @"YES";
    buildSetting[@"CLANG_WARN_ENUM_CONVERSION"]             = @"YES";
    buildSetting[@"CLANG_WARN_INT_CONVERSION"]              = @"YES";
    buildSetting[@"CLANG_WARN_OBJC_ROOT_CLASS"]             = @"YES";
    buildSetting[@"CLANG_WARN_UNREACHABLE_CODE"]            = @"YES";
    buildSetting[@"CLANG_WARN__DUPLICATE_METHOD_MATCH"]     = @"YES";
    buildSetting[@"COPY_PHASE_STRIP"]                       = @"NO";
    buildSetting[@"GCC_C_LANGUAGE_STANDARD"]                = @"gnu99";
    buildSetting[@"GCC_DYNAMIC_NO_PIC"]                     = @"NO";
    buildSetting[@"GCC_OPTIMIZATION_LEVEL"]                 = @0;
    buildSetting[@"GCC_PREPROCESSOR_DEFINITIONS"]           = @[@"DEBUG=1",@"$(inherited)"];
    buildSetting[@"GCC_SYMBOLS_PRIVATE_EXTERN"]             = @"YES";
    buildSetting[@"GCC_WARN_64_TO_32_BIT_CONVERSION"]       = @"YES";
    buildSetting[@"GCC_WARN_ABOUT_RETURN_TYPE"]             = @"YES";
    buildSetting[@"GCC_WARN_UNDECLARED_SELECTOR"]           = @"YES";
    buildSetting[@"GCC_WARN_UNINITIALIZED_AUTOS"]           = @"YES";
    buildSetting[@"GCC_WARN_UNUSED_FUNCTION"]               = @"YES";
    buildSetting[@"GCC_WARN_UNUSED_VARIABLE"]               = @"YES";
    buildSetting[@"ONLY_ACTIVE_ARCH"]                       = @"YES";

    
    return buildSetting;
    
}

- (NSString*)toString
{
    
    // release
    XCBuildConfiguration * projReleaseConfig = [XCBuildConfiguration node];
    projReleaseConfig.name = @"Release";
    [projReleaseConfig.buildSettings addEntriesFromDictionary:[self releaseProjectSetting_new]];
    
    XCBuildConfiguration * targetReleaseConfig = [XCBuildConfiguration node];
    targetReleaseConfig.name = @"Release";
    [targetReleaseConfig.buildSettings addEntriesFromDictionary:[self releaseTargetSetting_new]];
    
    // debug
    XCBuildConfiguration * projDebugConfig = [XCBuildConfiguration node];
    projDebugConfig.name = @"Debug";
    [projDebugConfig.buildSettings addEntriesFromDictionary:[self debugProjSetting_new]];
    
//    [projDebugConfig.buildSettings addEntriesFromDictionary:[self debugProjectSetting]];
//    [projDebugConfig.buildSettings addEntriesFromDictionary:[self releaseProjectSetting]];
    
    XCBuildConfiguration * targetDebugConfig = [XCBuildConfiguration node];
    targetDebugConfig.name = @"Debug";
    [targetDebugConfig.buildSettings addEntriesFromDictionary:[self debugTargetSetting_new]];
    
//    [targetDebugConfig.buildSettings addEntriesFromDictionary:[self debugTargetSetting]];
    
    
    XCConfigurationList * projectConfigList = [XCConfigurationList node];
    projectConfigList.defaultConfigurationIsVisible = @0;
    projectConfigList.defaultConfigurationName = @"Debug";
    [projectConfigList.buildConfigurations addObject:projDebugConfig.key];
    [projectConfigList.buildConfigurations addObject:projReleaseConfig.key];
    
    XCConfigurationList * targetConfigList = [XCConfigurationList node];
    targetConfigList.defaultConfigurationIsVisible = @0;
    targetConfigList.defaultConfigurationName = @"Debug";
    [targetConfigList.buildConfigurations addObject:targetDebugConfig.key];
    [targetConfigList.buildConfigurations addObject:targetReleaseConfig.key];
    
    // Add build phases
    
    PBXSourcesBuildPhase * sourcesBuildPhase = [PBXSourcesBuildPhase node];
    sourcesBuildPhase.buildActionMask = @"2147483647";
    sourcesBuildPhase.runOnlyForDeploymentPostprocessing = @0;
    
    PBXResourcesBuildPhase * resourcesBuildPhase = [PBXResourcesBuildPhase node];
    resourcesBuildPhase.buildActionMask = @"2147483647";
    resourcesBuildPhase.runOnlyForDeploymentPostprocessing = @0;
    
    PBXFrameworksBuildPhase * frameworksBuildPhase = [PBXFrameworksBuildPhase node];
    frameworksBuildPhase.buildActionMask = @"2147483647";
    frameworksBuildPhase.runOnlyForDeploymentPostprocessing = @0;
    
    // Add target
    
    PBXNativeTarget * target = [PBXNativeTarget node];
    target.name = self.applicationName;
    target.productName = self.applicationName;
    target.productType = @"com.apple.product-type.application";
    target.buildConfigurationList = targetConfigList.key;
    [target.buildPhases addObject:sourcesBuildPhase.key];
    [target.buildPhases addObject:frameworksBuildPhase.key];
    [target.buildPhases addObject:resourcesBuildPhase.key];
    
    // Create groups
    
    PBXGroup * applicationGroup = [PBXGroup node];//根 group
    applicationGroup.path = [NSString stringWithFormat:@"./%@",self.applicationName];
    applicationGroup.name = self.applicationName;
    applicationGroup.sourceTree = @"<group>";
    
    PBXGroup * productsGroup = [PBXGroup node];//product group
    productsGroup.name = @"Products";
    productsGroup.sourceTree = @"<group>";
    
    PBXGroup * mainGroup = [PBXGroup node];//主 group
    mainGroup.sourceTree = @"<group>";
    [mainGroup.children addObject:applicationGroup.key];
    [mainGroup.children addObject:productsGroup.key];
    
    NSArray *subGroups = [ProjectPaths getGroups];
    NSMutableArray *subPBXGroup = [NSMutableArray array];
    for (NSString *subGroupName in subGroups)
    {
        PBXGroup *fileGroup = [PBXGroup node];
        fileGroup.path =  subGroupName;
        fileGroup.sourceTree = @"<group>";
        [subPBXGroup addObject:fileGroup];
        [applicationGroup.children addObject:fileGroup.key];//加入根group
    }

// Add source files
    
    NSMutableArray * fileReferences = [NSMutableArray array];
    NSMutableArray * buildFiles = [NSMutableArray array];
    
    for ( NSString * fileName in self.fileNames )
    {
        PBXFileReference * fileRef = [PBXFileReference node:fileName];//用文件名创建索引
        if ( fileRef )
        {
            if ( PBXFileReferenceTypeSubGroup != [fileRef type] )
            {
                [fileReferences addObject:fileRef];//将索引加进索引组
            }
            
            
            if ( PBXFileReferenceTypeSource == [fileRef type] ||
                PBXFileReferenceTypeResource == [fileRef type] )
            {//资源文件
                [applicationGroup.children addObject:fileRef.key];
            }
            else if ( PBXFileReferenceTypeProduct == [fileRef type] )
            {//build产物
                [productsGroup.children addObject:fileRef.key];
                target.productReference = fileRef.key;
            }
            
            
            if ( [fileRef isBuildable] )
            {//可以build的文件（资源文件）
                PBXBuildFile * buildFile = [PBXBuildFile node];
                if ( buildFile )
                {
                    if( fileRef.isBuildFile )
                    {
                        buildFile.fileRef = fileRef.key;
                        [buildFiles addObject:buildFile];
                    }
                    if( fileRef.isBuildFile )
                    {//加到源文件
                        [sourcesBuildPhase.files addObject:buildFile.key];
                    }
                    else if ( PBXFileReferenceTypeFramework == [fileRef type] )
                    {//加到framework文件
                        [frameworksBuildPhase.files addObject:buildFile.key];
                    }
                    else if ( PBXFileReferenceTypeResource == [fileRef type] )
                    {//加到资源文件
                        [resourcesBuildPhase.files addObject:buildFile.key];
                    }
                    else if( PBXFileReferenceTypeSubGroup == [fileRef type] )
                    {
                        
                        
                    }
                }
            }
        }
    }
    
    // Add project
    
    PBXProject * project = [PBXProject node];
    project.attributes[@"LastUpgradeCheck"] = @"0700";
    project.attributes[@"LastSwiftUpdateCheck"] = @"0700";
//    project.attributes[@"ORGANIZATIONNAME"] = self.organizationName;
    project.buildConfigurationList = projectConfigList.key;
    project.compatibilityVersion = @"Xcode 3.2";
    project.developmentRegion = @"English";
    project.hasScannedForEncodings = @0;
    project.mainGroup = mainGroup.key;
    project.productRefGroup = productsGroup.key;
    project.projectDirPath = @"";
    project.projectRoot = @"";
    [project.knownRegions addObject:@"en"];
    [project.targets addObject:target.key];
    
    
    // Build string
    
    NSMutableString * content = [NSMutableString string];
    
    content.LINE( @"// !$*UTF8*$!" );
    content.LINE( @"{" );
    content.LINE( @"	archiveVersion = 1;" );
    content.LINE( @"	classes = {" );
    content.LINE( @"	};" );
    content.LINE( @"	objectVersion = 46;" );
    content.LINE( @"	objects = {" );
    content.LINE( nil );
    
    int indent = 2;
    
    //518
    
    content.LINE( @"	/* Begin PBXBuildFile section */" );
    for ( PBXBuildFile * buildFile in buildFiles )
    {
        content.APPEND( [PListBuilder objectToString:buildFile indent:indent] );
    }
    content.LINE( @"	/* End PBXBuildFile section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXFileReference section */" );
    for ( PBXFileReference * fileRef in fileReferences )
    {
        content.APPEND( [PListBuilder objectToString:fileRef indent:indent] );
    }
    content.LINE( @"	/* End PBXFileReference section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXFrameworksBuildPhase section */" );
    {
        content.APPEND( [PListBuilder objectToString:frameworksBuildPhase indent:indent] );
    }
    content.LINE( @"	/* End PBXFrameworksBuildPhase section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXGroup section */" );
    {
        content.APPEND( [PListBuilder objectToString:mainGroup indent:indent] );
        content.APPEND( [PListBuilder objectToString:applicationGroup indent:indent] );
        content.APPEND( [PListBuilder objectToString:productsGroup indent:indent] );
        for (PBXGroup *subGroup in subPBXGroup)
        {
            content.APPEND( [PListBuilder objectToString:subGroup indent:indent]  );
        }
    }
    content.LINE( @"	/* End PBXGroup section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXNativeTarget section */" );
    {
        content.APPEND( [PListBuilder objectToString:target indent:indent] );
    }
    content.LINE( @"	/* End PBXNativeTarget section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXProject section */" );
    {
        content.APPEND( [PListBuilder objectToString:project indent:indent] );
    }
    content.LINE( @"	/* End PBXProject section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXResourcesBuildPhase section */" );
    {
        content.APPEND( [PListBuilder objectToString:resourcesBuildPhase indent:indent] );
    }
    content.LINE( @"	/* End PBXResourcesBuildPhase section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin PBXSourcesBuildPhase section */" );
    {
        content.APPEND( [PListBuilder objectToString:sourcesBuildPhase indent:indent] );
    }
    content.LINE( @"	/* End PBXSourcesBuildPhase section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin XCBuildConfiguration section */" );
    {
        content.APPEND( [PListBuilder objectToString:projReleaseConfig indent:indent] );
        content.APPEND( [PListBuilder objectToString:targetReleaseConfig indent:indent] );
        content.APPEND( [PListBuilder objectToString:projDebugConfig indent:indent] );
        content.APPEND( [PListBuilder objectToString:targetDebugConfig indent:indent] );

    }
    content.LINE( @"	/* End XCBuildConfiguration section */" );
    content.LINE( nil );
    
    content.LINE( @"	/* Begin XCConfigurationList section */" );
    {
        content.APPEND( [PListBuilder objectToString:projectConfigList indent:indent] );
        content.APPEND( [PListBuilder objectToString:targetConfigList indent:indent] );
    }
    content.LINE( @"	/* End XCConfigurationList section */" );
    content.LINE( nil );
    
    content.LINE( @"	};" );
    content.LINE( @"	rootObject = %@;", project.key );
    content.LINE( @"}" );
    content.LINE( nil );

    
    
    return content;
    
}

//- (void)generateKey
//{
//    CFUUIDRef	uuidObj = CFUUIDCreate( nil );
//    NSString *	uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString( nil, uuidObj ));
//    
//    _key = [uuid MD5];
//    
//    CFRelease(uuidObj);
//}

@end
