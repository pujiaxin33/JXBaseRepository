//
//  CDJsonKit.h
//  CodoonSport
//
//  Created by LeoKing on 15/5/20.
//  Copyright (c) 2015年 Codoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (CDJsonKit)

- (NSString *)cd_JSONString;
- (NSData *)cd_JSONData;

@end

@interface NSArray (CDJsonKit)

- (NSString *)cd_JSONString;
- (NSData *)cd_JSONData;

@end

@interface NSString (CDJsonKit)

- (id)cd_objectFromJSONString;

@end