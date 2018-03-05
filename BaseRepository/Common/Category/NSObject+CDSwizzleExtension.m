//
//  NSObject+Utility.m
//  DGUtilityKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import "NSObject+CDSwizzleExtension.h"

#include <objc/runtime.h>

@implementation NSObject (CDSwizzleExtension)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_
{
    Method origMethod = class_getInstanceMethod(self, origSel_);
    if(!origMethod)
    {
        return NO;
    }
    
    Method altMethod = class_getInstanceMethod(self, altSel_);
    if(!altMethod)
    {
        return NO;
    }
    
    class_addMethod(self, origSel_, class_getMethodImplementation(self, origSel_), method_getTypeEncoding(origMethod));
    class_addMethod(self, altSel_, class_getMethodImplementation(self, altSel_), method_getTypeEncoding(altMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
    return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_
{
    return [object_getClass(self) swizzleMethod:origSel_ withMethod:altSel_ error:error_];
}

@end
