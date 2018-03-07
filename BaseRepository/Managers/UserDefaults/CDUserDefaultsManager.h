//
//  CDUserDefaultsManager.h
//  CodoonSport
//
//  Created by Leo on 14-5-7.
//  Copyright (c) 2014年 codoon.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CDUserDefaultsManager : NSObject
/**
 *  保存整型
 *
 *  @param aValue 整型值
 *  @param aKey 键值
 */
+ (void)setInteger:(NSInteger)aValue forKey:(NSString *)aKey;

/**
 *  保存浮点型
 *
 *  @param aValue 浮点型值
 *  @param aKey   键值
 */
+ (void)setFloat:(float)aValue forKey:(NSString *)aKey;

/**
 *  保存双精度浮点
 *
 *  @param aValue double
 *  @param aKey   键值
 */
+ (void)setDouble:(double)aValue forKey:(NSString *)aKey;

/**
 *  保存bool型
 *
 *  @param aValue bool型
 *  @param aKey   键值
 */
+ (void)setBool:(BOOL)aValue forKey:(NSString *)aKey;

/**
 *  保存对象
 *
 *  @param aValue 任何object对象，如果不支持直接保存的，内部会做处理
 *  @param aKey   键值
 */
+ (void)setObject:(id)aValue forKey:(NSString *)aKey;

/**
 *  保存对象
 *
 *  @param aObject 序列化后 再保存NSData
 *  @param aKey    键值
 */
+ (void)archivedDataWithObject:(id<NSCoding>)aObject forKey:(NSString *)aKey;

/**
 *  删除对象
 *
 *  @param aKey 键值
 */
+ (void)removeObjectForKey:(NSString *)aKey;

/**
 *  取得整型
 *
 *  @param aKey 键值
 *
 *  @return 整型
 */
+ (NSInteger)integerForKey:(NSString *)aKey;

/**
 *  取得浮点型
 *
 *  @param aKey 键值
 *
 *  @return 浮点型
 */
+ (float)floatForKey:(NSString *)aKey;

/**
 *  取得double型
 *
 *  @param aKey 键值
 *
 *  @return double
 */
+ (double)doubleForKey:(NSString *)aKey;

/**
 *  取得bool型
 *
 *  @param aKey 键值
 *
 *  @return bool型
 */
+ (BOOL)boolForKey:(NSString *)aKey;

/**
 *  取得对象
 *
 *  @param aKey 键值
 *
 *  @return 返回对象，不存在返回nil
 */
+ (id)objectForKey:(NSString *)aKey;

/**
 *  取得对象
 *
 *  @param aKey 键值
 *
 *  @return 反序列化之后 返回对象
 */
+ (id)unarchiveObjectWithDataForKey:(NSString *)aKey;
@end
