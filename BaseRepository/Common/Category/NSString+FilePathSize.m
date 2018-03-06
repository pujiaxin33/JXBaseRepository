//
//  NSString+FilePathSize.m
//  BaseRepository
//
//  Created by Imp on 2018/3/6.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import "NSString+FilePathSize.h"

@implementation NSString (FilePathSize)

- (uint64_t)filePathSize {
    uint64_t size = 0;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL fileExist = [fileManager fileExistsAtPath:self isDirectory:&isDir];
    if (fileExist) {
        if (isDir) {
            NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:self];
            for (NSString *subPath in enumerator) {
                NSString *fullPath = [self stringByAppendingPathComponent:subPath];
                size += [fileManager attributesOfItemAtPath:fullPath error:nil].fileSize;
            }
        } else {
            size += [fileManager attributesOfItemAtPath:self error:nil].fileSize;
        }
    }
    return size;
}

@end
