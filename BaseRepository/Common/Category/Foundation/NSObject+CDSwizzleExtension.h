//
//  NSObject+Utility.h
//  DGUtilityKit
//
//  Created by Jinxiao on 9/1/13.
//  Copyright (c) 2013 debugeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CDSwizzleExtension)

+ (BOOL)swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_;
+ (BOOL)swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_;

@end
