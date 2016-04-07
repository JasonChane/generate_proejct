//
//  PBXBuildPhase.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXBuildPhase.h"

@implementation PBXBuildPhase

- (void)load
{
    self.isa = @"PBXBuildPhase";
    self.files = [NSMutableArray array];
    
    [self generateKey];
}

@end
