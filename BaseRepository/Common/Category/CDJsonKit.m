//
//  CDJsonKit.m
//  CodoonSport
//
//  Created by LeoKing on 15/5/20.
//  Copyright (c) 2015年 Codoon. All rights reserved.
//

#import "CDJsonKit.h"

@implementation NSDictionary (CDJsonKit)

- (NSString *)cd_JSONString
{
    NSData *jsonData = [self cd_JSONData];
    if (!jsonData)
    {
        return @"";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSData *)cd_JSONData
{
    if (![NSJSONSerialization isValidJSONObject:self])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil)
    {
        return nil;
    }
    
    return jsonData;
}

@end

@implementation NSArray (CDJsonKit)

- (NSString *)cd_JSONString
{
    NSData *jsonData = [self cd_JSONData];
    if (!jsonData)
    {
        return @"";
    }
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSData *)cd_JSONData
{
    if (![NSJSONSerialization isValidJSONObject:self])
    {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:kNilOptions error:&error];
    if (error != nil)
    {
        return nil;
    }
    
    return jsonData;
}

@end

@implementation NSString (CDJsonKit)

- (id)cd_objectFromJSONString
{
    if (!self.length) return nil;
    
    NSError* error = nil;
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error !=nil)
    {
        return nil;
    }
    
    return result;
}

@end
