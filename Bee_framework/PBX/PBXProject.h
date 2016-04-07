//
//  PBXProject.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

@interface PBXProject : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSMutableDictionary *	attributes;
@property (nonatomic, retain) NSString *			buildConfigurationList;
@property (nonatomic, retain) NSString *			compatibilityVersion;
@property (nonatomic, retain) NSString *			developmentRegion;
@property (nonatomic, retain) NSNumber *			hasScannedForEncodings;
@property (nonatomic, retain) NSMutableArray *		knownRegions;
@property (nonatomic, retain) NSString *			mainGroup;
@property (nonatomic, retain) NSString *			productRefGroup;
@property (nonatomic, retain) NSString *			projectDirPath;
@property (nonatomic, retain) NSString *			projectRoot;
@property (nonatomic, retain) NSMutableArray *		targets;

@end
