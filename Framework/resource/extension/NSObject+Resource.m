//
//  NSObject+Resource.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSObject+Resource.h"
#import "NSObject+LionJSON.h"

#pragma mark -

@implementation NSObject(Resource)

+ (NSString *)stringFromResource:(NSString *)resName
{
    if ( nil == resName )
        return nil;
    
    NSString * extension = [resName pathExtension];
    NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    
    return [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:NULL];
}

- (NSString *)stringFromResource:(NSString *)resName
{
    return [NSObject stringFromResource:resName];
}

+ (NSData *)dataFromResource:(NSString *)resName
{
    if ( nil == resName )
        return nil;
    
    NSString * extension = [resName pathExtension];
    NSString * fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    NSString * resPath = [[NSBundle mainBundle] pathForResource:fullName ofType:extension];
    
    return [NSData dataWithContentsOfFile:resPath];
}

- (NSData *)dataFromResource:(NSString *)resName
{
    return [NSObject dataFromResource:resName];
}

+ (id)objectFromResource:(NSString *)resName
{
    NSString * content = [self stringFromResource:resName];
    if ( nil == content )
        return nil;
    
    NSObject * decodedObject = [self objectFromString:content];
    if ( nil == decodedObject )
        return nil;
    
    return decodedObject;
}

@end

// TODO: 0.5
