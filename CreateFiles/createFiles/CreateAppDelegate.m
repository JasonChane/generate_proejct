//
//  CreateAppDelegate.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "CreateAppDelegate.h"
#import "BeeSandbox.h"
#import "CreateFile.h"
#import "NSString+LionExtension.h"
#import "Generate_Config.h"
#import "ProjectPaths.h"

@implementation CreateAppDelegate

+ (void)createAppDelegateFile
{
    [self createAppDelegate_h];
    [self createAppDelegate_m];
    
}

+ (void)createAppDelegate_h
{
    NSString *appDelegate_h = [NSString stringWithFormat:@"%@/AppDelegate.h",[ProjectPaths mainFilePath]];
    [BeeSandbox touchFile:appDelegate_h];

    NSMutableString * delegateContent_h = [NSMutableString string];
    delegateContent_h.LINE( @"#import <UIKit/UIKit.h>" );
    delegateContent_h.LINE( @"@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>" );
    delegateContent_h.LINE( nil );
    delegateContent_h.LINE( @"@property (strong, nonatomic) UIWindow *window;" );
    delegateContent_h.LINE( nil );
    delegateContent_h.LINE( @"@end" );
    
    NSError *error = NULL;
    
    BOOL succeed = [delegateContent_h writeToFile:appDelegate_h atomically:YES encoding:NSUTF8StringEncoding error:&error];//创建main.m
    
    if (succeed) {
        
        
    }

}

+ (void)createAppDelegate_m
{
    NSString *appDelegate_m = [NSString stringWithFormat:@"%@/AppDelegate.m",[ProjectPaths mainFilePath]];
    [BeeSandbox touchFile:appDelegate_m];

    NSMutableString * delegateContent_m = [NSMutableString string];
    delegateContent_m.LINE( @"#import \"AppDelegate.h\"" );
    delegateContent_m.LINE( @"@interface AppDelegate ()" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"@end" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"@implementation AppDelegate" );
    
    delegateContent_m.LINE( @"- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {" );
    delegateContent_m.LINE( @"   UIViewController *vc = [[UIViewController alloc]init];" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"   vc.view.backgroundColor = [UIColor redColor];" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"   self.window.rootViewController = vc;" );

    delegateContent_m.LINE( @"   return YES;" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"}" );
    delegateContent_m.LINE( nil );
    delegateContent_m.LINE( @"@end" );


    NSError *error = NULL;
    
    BOOL succeed = [delegateContent_m writeToFile:appDelegate_m atomically:YES encoding:NSUTF8StringEncoding error:&error];//创建main.m
    
    if (succeed) {
        
        
    }
    
}

@end
