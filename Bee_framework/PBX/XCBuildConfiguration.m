//
//  XCBuildConfiguration.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "XCBuildConfiguration.h"

@implementation XCBuildConfiguration

- (void)load
{
    self.isa = @"XCBuildConfiguration";
    self.buildSettings = [NSMutableDictionary dictionary];
    
    [self generateKey];
}


@end
