//
//  PBXProject.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXProject.h"

@implementation PBXProject

- (void)load
{
    self.isa = @"PBXProject";
    self.attributes = [NSMutableDictionary dictionary];
    self.knownRegions = [NSMutableArray array];
    self.targets = [NSMutableArray array];
    
    [self generateKey];
}

@end
