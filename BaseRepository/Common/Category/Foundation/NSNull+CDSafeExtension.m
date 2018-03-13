//
//  NSNull+CDSafeExtension.m
//  CDExtensionKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import "NSNull+CDSafeExtension.h"

@implementation NSNull (CDSafeExtension)

- (NSArray *)alternativeObjects
{
    static NSArray *alternativeObjects;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alternativeObjects = @[@{}, @[], @"", @(0)];
    });
    return alternativeObjects;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    __block NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if(signature == nil)
    {
        [[self alternativeObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            signature = [obj methodSignatureForSelector:aSelector];
            *stop = (signature != nil);
        }];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL aSelector = [anInvocation selector];
    
    __block BOOL forwarded = NO;
    
    [[self alternativeObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj respondsToSelector:aSelector])
        {
            [anInvocation invokeWithTarget:obj];
            forwarded = YES;
        }
        
        *stop = forwarded;
    }];
    
    if(!forwarded)
    {
        [self doesNotRecognizeSelector:aSelector];
    }
}

@end

@implementation NSObject (CDSafeExtension_Null)

- (BOOL)containsNull
{
    if([self isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if([self isKindOfClass:[NSArray class]])
    {
        __block BOOL contains = NO;
        [(NSArray *)self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            contains = [obj containsNull];
            *stop = contains;
        }];
        return contains;
    }
    else if([self isKindOfClass:[NSDictionary class]])
    {
        __block BOOL contains = NO;
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            contains = [obj containsNull];
            *stop = contains;
        }];
        return contains;
    }
    else
    {
        return NO;
    }
}

@end

