//
//  NSObject+Utility.h
//  DGUtilityKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject (CDSafeExtension)

- (NSString *)validString;
- (NSNumber *)validNumberString;
- (NSArray *)validArray;
- (NSDictionary *)validDictionary;
- (NSURL *)validURL;

@end

@interface NSDictionary (CDSafeExtension)

- (NSNumber *)validNumberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)validNumberForKey:(NSString *)key;

- (NSString *)validStringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
- (NSString *)validStringForKey:(NSString *)key;

- (NSArray *)validArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;
- (NSArray *)validArrayForKey:(NSString *)key;

- (NSDictionary *)validDictionaryForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;
- (NSDictionary *)validDictionaryForKey:(NSString *)key;

@end

@interface NSArray (CDSafeExtension)

- (NSNumber *)validNumberAtIndex:(NSInteger)index defaultValue:(NSNumber *)defaultValue;
- (NSNumber *)validNumberAtIndex:(NSInteger)index;

- (NSString *)validStringAtIndex:(NSInteger)index defaultValue:(NSString *)defaultValue;
- (NSString *)validStringAtIndex:(NSInteger)index;

- (NSArray *)validArrayAtIndex:(NSInteger)index defaultValue:(NSArray *)defaultValue;
- (NSArray *)validArrayAtIndex:(NSInteger)index;

- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index defaultValue:(NSDictionary *)defaultValue;
- (NSDictionary *)validDictionaryAtIndex:(NSInteger)index;

- (id)safeObjectAtIndex:(NSInteger)index;

@end

@interface NSMutableDictionary (CDSafeExtension)

- (void)setSafeObject:(id)object forKey:(id<NSCopying>)key;

@end

@interface NSMutableArray (CDSafeExtension)

- (void)addSafeObject:(id)object;
- (void)removeSafeObjectAtIndex:(NSUInteger)index;
- (void)insertSafeObject:(id)object atIndex:(NSUInteger)index;

@end


@interface NSObject (Swizzle)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end

@interface NSObject (NSNull)

- (BOOL)containsNull;

@end
