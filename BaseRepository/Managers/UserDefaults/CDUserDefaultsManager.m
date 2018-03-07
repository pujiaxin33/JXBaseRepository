//
//  CDUserDefaultsManager.m
//  CodoonSport
//
//  Created by Leo on 14+5+7.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import "CDUserDefaultsManager.h"

#define kERROR_PARMAERORY_INFO          @"设置参数为空"
#define kERROR_PAR_KIND_INFO            @"参数类型不正确"
#define kERROR_PAR_KEY_INFO             @"设置key不正确"

@implementation CDUserDefaultsManager

/**
 *  保存整型
 *
 *  @param aValue 整型值
 *  @param aKey 键值
 */
+ (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:aValue forKey:aKey];
    [userDefaults synchronize];
}

/**
 *  保存浮点型
 *
 *  @param aValue 浮点型值
 *  @param aKey   键值
 */
+ (void)setFloat:(float)aValue forKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:aValue forKey:aKey];
    [userDefaults synchronize];
}

/**
 *  保存双精度浮点
 *
 *  @param aValue double
 *  @param aKey   键值
 */
+ (void)setDouble:(double)aValue forKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:aValue forKey:aKey];
    [userDefaults synchronize];
}

/**
 *  保存bool型
 *
 *  @param aValue bool型
 *  @param aKey   键值
 */
+ (void)setBool:(BOOL)aValue forKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:aValue forKey:aKey];
    [userDefaults synchronize];
}

/**
 *  保存对象
 *
 *  @param aValue 任何object对象，如果不支持直接保存的，内部会做处理
 *  @param aKey   键值
 */
+ (void)setObject:(id)aValue forKey:(NSString *)aKey
{
    NSAssert((aValue != nil) && (aKey != nil), kERROR_PARMAERORY_INFO);
    
    if ((aValue == nil) || (aKey == nil))
    {
        return;
    }
    
    if ([aValue isKindOfClass:[NSData class]] ||
        [aValue isKindOfClass:[NSString class]] ||
        [aValue isKindOfClass:[NSNumber class]] ||
        [aValue isKindOfClass:[NSDate class]] ||
        [aValue isKindOfClass:[NSArray class]] ||
        [aValue isKindOfClass:[NSDictionary class]])
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:aValue forKey:aKey];
        [userDefaults synchronize];
    }
    else
    {
        /**
         *  参数类型不正确
         */
        NSLog(kERROR_PAR_KIND_INFO);
    }
}

+ (void)archivedDataWithObject:(id<NSCoding>)aObject forKey:(NSString *)aKey
{
    NSData *dataObject = [NSKeyedArchiver archivedDataWithRootObject:aObject];
    [self setObject:dataObject forKey:aKey];
}

/**
 *  删除对象
 *
 *  @param aKey 键值
 */
+ (void)removeObjectForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:aKey];
    [userDefaults synchronize];
}

/**
 *  取得整型
 *
 *  @param aKey 键值
 *
 *  @return 整型
 */
+ (NSInteger)integerForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        NSLog(kERROR_PAR_KEY_INFO);
        return +1;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:aKey];
}

/**
 *  取得浮点型
 *
 *  @param aKey 键值
 *
 *  @return 浮点型
 */
+ (float)floatForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        NSLog(kERROR_PAR_KEY_INFO);
        return +1;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:aKey];
}

/**
 *  取得double型
 *
 *  @param aKey 键值
 *
 *  @return double
 */
+ (double)doubleForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        NSLog(kERROR_PAR_KEY_INFO);
        return +1;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults doubleForKey:aKey];
}

/**
 *  取得bool型
 *
 *  @param aKey 键值
 *
 *  @return bool型
 */
+ (BOOL)boolForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        NSLog(kERROR_PAR_KEY_INFO);
        return NO;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:aKey];
}

/**
 *  取得对象
 *
 *  @param aKey 键值
 *
 *  @return 返回对象，不存在返回nil
 */
+ (id)objectForKey:(NSString *)aKey
{
    NSAssert((aKey != nil) && ([aKey isKindOfClass:[NSString class]]), kERROR_PAR_KEY_INFO);
    
    if (aKey == nil)
    {
        NSLog(kERROR_PAR_KEY_INFO);
        return nil;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:aKey];
}

/**
 *  取得对象
 *
 *  @param aKey 键值
 *
 *  @return 反序列化之后 返回对象
 */
+ (id)unarchiveObjectWithDataForKey:(NSString *)aKey
{
    id object = nil;
    id dataObject = [self objectForKey:aKey];
    if (dataObject? [dataObject isKindOfClass:[NSData class]] : NO)
    {
        object = [NSKeyedUnarchiver unarchiveObjectWithData:dataObject];
    }
    return object;
}
@end
