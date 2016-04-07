//
//  PBXNativeTarget.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNativeTarget.h"

@implementation PBXNativeTarget

- (void)load
{
    self.isa = @"PBXNativeTarget";
    self.buildPhases = [NSMutableArray array];
    self.buildRules = [NSMutableArray array];
    self.dependencies = [NSMutableArray array];
    
    [self generateKey];
}

@end
