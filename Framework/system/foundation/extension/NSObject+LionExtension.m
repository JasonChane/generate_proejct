//
//  NSObject+LionExtension.m
//  generate
//
//  Created by guang on 15/4/20.
//  Copyright (c) 2015年 ifangchou. All rights reserved.
//


#import "NSObject+LionExtension.h"
#import "Lion_UnitTest.h"

// ----------------------------------
// Source code
// ----------------------------------

#pragma mark -

@implementation NSObject(LionExtension)

+ (instancetype)object
{
    return [[[self alloc] init] autorelease];
}

+ (instancetype)disposable
{
    return [[[self alloc] init] autorelease];
}

- (void)load
{
    
}

- (void)unload
{
}

- (void)performLoad
{
    [self performSelectorAlongChainReversed:@selector(load)];
}

- (void)performUnload
{
    [self performSelectorAlongChain:@selector(unload)];
}

- (void)performSelectorAlongChain:(SEL)sel
{
    NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack addObject:thisClass];
    }
    
    for ( Class thisClass in classStack )
    {
        Method method = class_getInstanceMethod( thisClass, sel );
        if ( method )
        {
            IMP imp = method_getImplementation( method );
            if ( imp )
            {
//                imp( self, sel, nil );
            }
        }
    }
}

- (void)performSelectorAlongChainReversed:(SEL)sel
{
    NSMutableArray * classStack = [NSMutableArray nonRetainingArray];
    
    for ( Class thisClass = [self class]; nil != thisClass; thisClass = class_getSuperclass( thisClass ) )
    {
        [classStack insertObject:thisClass atIndex:0];
    }
    
    for ( Class thisClass in classStack )
    {
        Method method = class_getInstanceMethod( thisClass, sel );
        if ( method )
        {
            IMP imp = method_getImplementation( method );
            if ( imp )
            {
//                imp( self, sel, nil );
            }
        }
    }
}

- (void)copyPropertiesFrom:(id)obj
{
    for ( Class clazzType = [obj class]; clazzType != [NSObject class]; )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	properties = class_copyPropertyList( clazzType, &propertyCount );
        
        for ( NSUInteger i = 0; i < propertyCount; i++ )
        {
            const char *	name = property_getName(properties[i]);
            NSString *		propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            
            [self setValue:[obj valueForKey:propertyName] forKey:propertyName];
        }
        
        free( properties );
        
        clazzType = class_getSuperclass( clazzType );
        if ( nil == clazzType )
            break;
    }
}

@end

// ----------------------------------
// Unit test
// ----------------------------------

#pragma mark -

#if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

TEST_CASE( NSObject_LionExtension )
{
}
TEST_CASE_END

#endif	// #if defined(__Lion_UNITTEST__) && __Lion_UNITTEST__

