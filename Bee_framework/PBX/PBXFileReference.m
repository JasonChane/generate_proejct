//
//  PBXFileReference.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXFileReference.h"


@implementation PBXFileReference
{
    PBXFileReferenceType	_type;
}

- (void)load
{
    self.isa = @"PBXFileReference";
    
    [self generateKey];
}

+ (instancetype)node:(NSString *)path
{
    
    PBXFileReference * fileRef = [PBXFileReference node];
    
    NSString * pathExtension = [path pathExtension];
    if ( [pathExtension matchAnyOf:@[@"app"]] )
    {
        fileRef.explicitFileType = @"wrapper.application";
        fileRef.includeInIndex = @0;
        fileRef.path = path;
        fileRef.sourceTree = @"BUILT_PRODUCTS_DIR";
        
        [fileRef setType:PBXFileReferenceTypeProduct];
    }
    else if ( [pathExtension matchAnyOf:@[@"plist"]] )
    {
        fileRef.lastKnownFileType = @"text.plist.xml";
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        fileRef.includeInIndex = @1;
        
        [fileRef setType:PBXFileReferenceTypeResource];
    }
    else if ( [pathExtension matchAnyOf:@[@"pch"]] )
    {
        fileRef.lastKnownFileType = @"sourcecode.c.h";
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        
        [fileRef setType:PBXFileReferenceTypeSource];
    }
    else if ( [pathExtension matchAnyOf:@[@"h"]] )
    {
        fileRef.lastKnownFileType = @"sourcecode.c.h";
//        fileRef.fileEncoding = @4;
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        fileRef.includeInIndex = @1;
        
        [fileRef setType:PBXFileReferenceTypeSource];
    }
    else if ( [pathExtension matchAnyOf:@[@"m", @"mm"]] )
    {
        fileRef.lastKnownFileType = @"sourcecode.c.objc";
//        fileRef.fileEncoding = @4;
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        fileRef.includeInIndex = @1;
        fileRef.isBuildFile = YES;
        
        [fileRef setType:PBXFileReferenceTypeSource];
    }
    else if ( [pathExtension matchAnyOf:@[@"png"]] )
    {
        fileRef.lastKnownFileType = @"image.png";
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        fileRef.isBuildFile = YES;
        
        [fileRef setType:PBXFileReferenceTypeResource];
    }
    else if ( [pathExtension matchAnyOf:@[@"jpg", @"jpeg"]] )
    {
        fileRef.path = path;
        fileRef.sourceTree = @"<group>";
        fileRef.isBuildFile = YES;
        
        [fileRef setType:PBXFileReferenceTypeResource];
    }
    else
    {
        fileRef.path = [NSString stringWithFormat:@"%@/%@",RootGroupName,path];
        fileRef.sourceTree = @"SOURCE_ROOT";
        [fileRef setType:PBXFileReferenceTypeSubGroup];
        
    }
        
    return fileRef;
}

- (BOOL)isBuildable
{
    if ( PBXFileReferenceTypeSource == _type || PBXFileReferenceTypeResource == _type )
    {
        return YES;
    }
    
    return NO;
}

- (PBXFileReferenceType)type
{
    return _type;
}

- (void)setType:(PBXFileReferenceType)type
{
    _type = type;
}

@end
