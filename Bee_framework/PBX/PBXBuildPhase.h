//
//  PBXBuildPhase.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface PBXBuildPhase : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			buildActionMask;
@property (nonatomic, retain) NSMutableArray *		files;
@property (nonatomic, retain) NSNumber *			runOnlyForDeploymentPostprocessing;

@end
