//
//  XCConfigurationList.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface XCConfigurationList : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableArray *		buildConfigurations;
@property (nonatomic, retain) NSNumber *			defaultConfigurationIsVisible;
@property (nonatomic, retain) NSString *			defaultConfigurationName;

@end
