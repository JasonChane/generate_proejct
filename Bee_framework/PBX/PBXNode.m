//
//  PBXNode.m
//  GeneratePbxproj
//
//  Created by Rich on 16/3/10.
//  Copyright © 2016年 Rich. All rights reserved.
//

#import "PBXNode.h"


@implementation PBXNode
{
    NSString * _key;
}

+ (instancetype)node
{
    return [[self alloc] init];
}

- (NSString *)key
{
    return _key;
}

- (void)generateKey
{
    CFUUIDRef	uuidObj = CFUUIDCreate( nil );
    NSString *	uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString( nil, uuidObj ));
    
    _key = [uuid MD5];
    
    CFRelease(uuidObj);
}

- (id)init
{
    self = [super init];
    if ( self )
    {
//        if ( nil == __nodes )
//        {
//            __nodes = [[NSMutableArray nonRetainingArray] retain];
//        }
//        
//        [__nodes addObject:self];
        
        [self load];
//        [self generateKey];
        
        
    }
    return self;
}

@end
