//
//  PBXGroup.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface PBXGroup : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			name;
@property (nonatomic, retain) NSString *			path;
@property (nonatomic, retain) NSMutableArray *		children;
@property (nonatomic, retain) NSString *			sourceTree;

@end
