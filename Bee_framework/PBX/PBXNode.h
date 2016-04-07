//
//  PBXNode.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+LionExtension.h"


@interface PBXNode : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) BOOL     isBuildFile;


- (void)generateKey;

+ (instancetype)node;

- (void)load;

@end
