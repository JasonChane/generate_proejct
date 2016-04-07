//
//  PBXFrameworksBuildPhase.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXFrameworksBuildPhase.h"

@implementation PBXFrameworksBuildPhase

- (void)load
{
    self.isa = @"PBXFrameworksBuildPhase";
    
    self.files = [NSMutableArray array];
    
    [self generateKey];
}

@end
