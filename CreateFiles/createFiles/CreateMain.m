//
//  CreateMain.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "CreateMain.h"
#import "BeeSandbox.h"
#import "CreateFile.h"
#import "NSString+LionExtension.h"
#import "Generate_Config.h"
#import "ProjectPaths.h"


@implementation CreateMain

+ (void)createMain
{
    // Create main.m
    NSString *mainPath = [NSString stringWithFormat:@"%@/main.m",[ProjectPaths mainFilePath]];
    
    [BeeSandbox touchFile:mainPath];
    
    NSMutableString * mainContent = [NSMutableString string];
    mainContent.LINE( @"#import <UIKit/UIKit.h>" );
    mainContent.LINE( @"#import \"AppDelegate.h\"" );
    mainContent.LINE( nil );
    mainContent.LINE( @"int main( int argc, const char * argv[] )" );
    mainContent.LINE( @"{" );
    mainContent.LINE( @"	@autoreleasepool {" );
    mainContent.LINE( @"		return UIApplicationMain( argc, argv, nil, NSStringFromClass([AppDelegate class]) );" );
    mainContent.LINE( @"	}" );
    mainContent.LINE( @"	return 0;" );
    mainContent.LINE( @"}" );
    
    NSError *error = NULL;
    
    BOOL succeed = [mainContent writeToFile:mainPath atomically:YES encoding:NSUTF8StringEncoding error:&error];//创建main.m

    if (succeed) {
        
        
    }
    
}


@end
