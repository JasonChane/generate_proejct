//
//  PBXBuildFile.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"


@interface PBXBuildFile : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			fileRef;

@end
