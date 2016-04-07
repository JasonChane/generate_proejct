//
//  PBXSourcesBuildPhase.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXSourcesBuildPhase.h"

@implementation PBXSourcesBuildPhase

- (void)load
{
    //	[super load];
    
    self.isa = @"PBXSourcesBuildPhase";
    
    self.files = [NSMutableArray array];
    
    [self generateKey];
}

@end
