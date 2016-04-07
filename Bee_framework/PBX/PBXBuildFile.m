//
//  PBXBuildFile.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXBuildFile.h"

@implementation PBXBuildFile

- (void)load
{
    self.isa = @"PBXBuildFile";
    
    [self generateKey];
}




@end
