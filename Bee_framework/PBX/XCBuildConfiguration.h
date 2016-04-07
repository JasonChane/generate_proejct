//
//  XCBuildConfiguration.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface XCBuildConfiguration : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableDictionary *	buildSettings;
@property (nonatomic, retain) NSString *			name;

+ (instancetype)node;

@end
