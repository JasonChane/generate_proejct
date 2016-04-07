//
//  PBXNativeTarget.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface PBXNativeTarget : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			buildConfigurationList;
@property (nonatomic, retain) NSMutableArray *		buildPhases;
@property (nonatomic, retain) NSMutableArray *		buildRules;
@property (nonatomic, retain) NSMutableArray *		dependencies;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			productName;
@property (nonatomic, retain) NSString *			productReference;
@property (nonatomic, retain) NSString *			productType;

@end
