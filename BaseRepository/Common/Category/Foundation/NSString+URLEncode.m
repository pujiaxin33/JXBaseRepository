//
//  NSString+URLEncode.m
//  CodoonSport
//
//  Created by CHEN on 15/9/22.
//  Copyright © 2015年 Codoon. All rights reserved.
//

#import "NSString+URLEncode.h"

@implementation NSString(URLEncode)

- (NSString *)cd_URLEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@":/?#[]@!$&'()*+,;="]];
}

- (NSString *)cd_URLDecode
{
    return self.stringByRemovingPercentEncoding;
}

@end
