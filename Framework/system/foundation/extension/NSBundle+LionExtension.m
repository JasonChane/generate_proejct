//
//  NSBundle+LionExtension.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//

#import "NSBundle+LionExtension.h"
#import "Lion_SystemInfo.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

@implementation NSBundle(LionExntension)

@dynamic fullPath;
@dynamic pathName;

- (NSString *)fullPath
{
    return [self.resourcePath stringByDeletingLastPathComponent];
}

- (NSString *)pathName
{
    return [[self.resourcePath lastPathComponent] stringByDeletingPathExtension];
}

- (NSData *)data:(NSString *)resName
{
    NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
    NSData *	data = [NSData dataWithContentsOfFile:path];
    
    return data;
}

- (UIImage *)image:(NSString *)resName
{
    NSString *	extension = [resName pathExtension];
    NSString *	fullName = [resName substringToIndex:(resName.length - extension.length - 1)];
    UIImage *	image = nil;
    
    if ( nil == image && [LionSystemInfo isDevicePad] )
    {
        NSString *	path = [NSString stringWithFormat:@"%@/%@@2x.%@", self.resourcePath, fullName, extension];
        NSString *	path2 = [NSString stringWithFormat:@"%@/%@.%@", self.resourcePath, fullName, extension];
        
        image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
        if ( nil == image )
        {
            image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
        }
    }
    
    if ( nil == image && [LionSystemInfo isPhoneRetina4] )
    {
        NSString *	path = [NSString stringWithFormat:@"%@/%@-568h@2x.%@", self.resourcePath, fullName, extension];
        NSString *	path2 = [NSString stringWithFormat:@"%@/%@-568h.%@", self.resourcePath, fullName, extension];
        
        image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
        if ( nil == image )
        {
            image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
        }
    }
    
    if ( nil == image )
    {
        NSString *	path = [NSString stringWithFormat:@"%@/%@@2x.%@", self.resourcePath, fullName, extension];
        NSString *	path2 = [NSString stringWithFormat:@"%@/%@.%@", self.resourcePath, fullName, extension];
        
        image = [[[UIImage alloc] initWithContentsOfFile:path] autorelease];
        if ( nil == image )
        {
            image = [[[UIImage alloc] initWithContentsOfFile:path2] autorelease];
        }
    }
    
    return image;
}

- (NSString *)string:(NSString *)resName
{
    NSString *	path = [NSString stringWithFormat:@"%@/%@", self.resourcePath, resName];
    NSString *	data = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    
    return data;
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
