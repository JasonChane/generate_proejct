//
//  PBXFileReference.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"

typedef enum
{
    PBXFileReferenceTypeUnknown = 0,
    PBXFileReferenceTypeFramework,
    PBXFileReferenceTypeSource,
    PBXFileReferenceTypeResource,
    PBXFileReferenceTypeProduct,
    PBXFileReferenceTypeSubGroup
} PBXFileReferenceType;

@interface PBXFileReference : PBXNode
@property (nonatomic, retain) NSString *			isa;
@property (nonatomic, retain) NSString *			explicitFileType;
@property (nonatomic, retain) NSString *			lastKnownFileType;
@property (nonatomic, retain) NSNumber *			includeInIndex;
@property (nonatomic, retain) NSNumber *			fileEncoding;
@property (nonatomic, retain) NSString *			path;
@property (nonatomic, retain) NSString *			sourceTree;

+ (instancetype)node:(NSString *)path;

- (PBXFileReferenceType)type;

- (BOOL)isBuildable;

@end


//37B2F320CF4B6638124033D4 /* main.m */ = {
//    isa = PBXFileReference;
//    includeInIndex = 1;
//    lastKnownFileType = sourcecode.c.objc;
//    path = main.m;
//    sourceTree = "<group>"; };
//4017060980DD7555FD127529 /* AppDelegate.h */ = {
//    isa = PBXFileReference;
//    includeInIndex = 1;
//    lastKnownFileType = sourcecode.c.h;
//    path = AppDelegate.h;
//    sourceTree = "<group>"; };
//841952E9B4C4AADABA2F2258 /* Example.app */ = {
//    isa = PBXFileReference;
//    explicitFileType = wrapper.application;
//    includeInIndex = 0;
//    path = Example.app;
//    sourceTree = BUILT_PRODUCTS_DIR; };
//A5BC9672E4CA9194882C2C49 /* Info.plist */ = {
//    isa = PBXFileReference;
//    includeInIndex = 1;
//    lastKnownFileType = text.plist.xml;
//    path = Info.plist;
//    sourceTree = "<group>"; };
//C98DD7C136CC60A1EDE40796 /* AppDelegate.m */ = {
//    isa = PBXFileReference;
//    includeInIndex = 1;
//    lastKnownFileType = sourcecode.c.objc;
//    path = AppDelegate.m;
//    sourceTree = "<group>";
//};
