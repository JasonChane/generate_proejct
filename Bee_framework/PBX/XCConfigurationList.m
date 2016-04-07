//
//  XCConfigurationList.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "XCConfigurationList.h"

@implementation XCConfigurationList

- (void)load
{
    self.isa = @"XCConfigurationList";
    self.buildConfigurations = [NSMutableArray array];
    
    [self generateKey];
}

@end
