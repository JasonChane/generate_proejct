//
//  ProjectBuilder.h
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectBuilder : NSObject

@property (nonatomic, retain) NSString *			applicationName;
@property (nonatomic, retain) NSString *			organizationName;
@property (nonatomic, retain) NSString *			deploymentTarget;

@property (nonatomic, retain) NSMutableArray *		fileNames;
@property (nonatomic, retain) NSMutableArray *		libraries;
@property (nonatomic, retain) NSMutableArray *		frameworks;
@property (nonatomic, retain) NSMutableArray *		otherFlags;
@property (nonatomic, retain) NSMutableArray *		architectures;
@property (nonatomic, retain) NSMutableArray *		headerSearchPaths;
@property (nonatomic, retain) NSMutableArray *		librarySearchPaths;

@property (nonatomic, retain) NSString *			errorDesc;

- (void)addFile:(NSString *)file;
- (void)addLibrary:(NSString *)lib;
- (void)addFramework:(NSString *)framework;
- (void)addOtherFlag:(NSString *)flag;
- (void)addArchitecture:(NSString *)arch;
- (void)addHeaderSearchPath:(NSString *)path;
- (void)addLibrarySearchPath:(NSString *)path;

- (NSString *)toString;

@end
