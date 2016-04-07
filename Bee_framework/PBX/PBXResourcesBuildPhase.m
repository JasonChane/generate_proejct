//
//  PBXResourcesBuildPhase.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXResourcesBuildPhase.h"

@implementation PBXResourcesBuildPhase

- (void)load
{
    self.isa = @"PBXResourcesBuildPhase";
    
    self.files = [NSMutableArray array];
    
    [self generateKey];
}

@end
