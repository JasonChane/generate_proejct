//
//  CreatePlist.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/9.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "CreatePlist.h"
#import "BeeSandbox.h"
#import "CreateFile.h"
#import "NSString+LionExtension.h"
#import "Generate_Config.h"
#import "ProjectPaths.h"


@implementation CreatePlist

+ (void)createPlistFile
{
    NSString *applicationName = @"test";
    
    // Create info.plist
    NSString *plistFile = [NSString stringWithFormat:@"%@/Info.plist",[ProjectPaths mainFilePath]];
    
    [BeeSandbox touchFile:plistFile];
    
    NSMutableString * plistContent = [NSMutableString string];
    plistContent.LINE( @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" );
    plistContent.LINE( @"<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" );
    plistContent.LINE( @"<plist version=\"1.0\">" );
    plistContent.LINE( @"<dict>" );
    plistContent.LINE( @"<key>CFBundleDevelopmentRegion</key>" );
    plistContent.LINE( @"<string>en</string>" );
    plistContent.LINE( @"<key>CFBundleDisplayName</key>" );
    plistContent.LINE( @"<string>%@</string>", applicationName );
    plistContent.LINE( @"<key>CFBundleExecutable</key>" );
    plistContent.LINE( @"<string>${EXECUTABLE_NAME}</string>" );
    plistContent.LINE( @"<key>CFBundleIdentifier</key>" );
    plistContent.LINE( @"<string>Your Bundle Identifier</string>" );
    plistContent.LINE( @"<key>CFBundleInfoDictionaryVersion</key>" );
    plistContent.LINE( @"<string>6.0</string>" );
    plistContent.LINE( @"<key>CFBundleName</key>" );
    plistContent.LINE( @"<string>%@</string>", applicationName );
    plistContent.LINE( @"<key>CFBundlePackageType</key>" );
    plistContent.LINE( @"<string>APPL</string>" );
    plistContent.LINE( @"<key>CFBundleShortVersionString</key>" );
    plistContent.LINE( @"<string>1.0</string>" );
    plistContent.LINE( @"<key>CFBundleSignature</key>" );
    plistContent.LINE( @"<string>????</string>" );
    plistContent.LINE( @"<key>CFBundleVersion</key>" );
    plistContent.LINE( @"<string>1.0</string>" );
    plistContent.LINE( @"<key>LSRequiresIPhoneOS</key>" );
    plistContent.LINE( @"<true/>" );
    plistContent.LINE( @"<key>UIPrerenderedIcon</key>" );
    plistContent.LINE( @"<true/>" );
    plistContent.LINE( @"<key>UIRequiredDeviceCapabilities</key>" );
    plistContent.LINE( @"<array>" );
//    for ( NSString * arch in builder.architectures )
//    {
//        plistContent.LINE( @"<string>%@</string>", arch );
//    }
    plistContent.LINE( @"</array>" );
    plistContent.LINE( @"<key>UIStatusBarHidden</key>" );
    plistContent.LINE( @"<false/>" );
    plistContent.LINE( @"<key>UIStatusBarStyle</key>" );
    plistContent.LINE( @"<string>UIStatusBarStyleBlackOpaque</string>" );
    plistContent.LINE( @"<key>UISupportedInterfaceOrientations</key>" );
    plistContent.LINE( @"<array>" );
    plistContent.LINE( @"<string>UIInterfaceOrientationPortrait</string>" );
    plistContent.LINE( @"</array>" );
    plistContent.LINE( @"</dict>" );
    plistContent.LINE( @"</plist>" );
    

    NSError *error;
    
    BOOL succeed = [plistContent writeToFile:plistFile atomically:YES encoding:NSUTF8StringEncoding error:&error];//创建main.m
    
    if (succeed) {
        
        
    }
    
}




@end
