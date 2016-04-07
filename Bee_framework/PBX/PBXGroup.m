//
//  PBXGroup.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXGroup.h"

@implementation PBXGroup

- (void)load
{
    self.isa = @"PBXGroup";
    self.children = [NSMutableArray array];
    
    [self generateKey];
}

@end
