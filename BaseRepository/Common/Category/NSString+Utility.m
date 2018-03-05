//
//  NSString+Utility.m
//  CodoonSport
//
//  Created by Jinxiao on 12/29/15.
//  Copyright © 2015 Codoon. All rights reserved.
//

#import "NSString+Utility.h"

#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Utility)

+ (NSString *)uuid
{
    NSString *uuid = nil;
    
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuidRef));
    CFRelease(uuidRef);
    
    return uuid;
}

- (BOOL)isWhitespace
{
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for(NSInteger i = 0; i < self.length; ++i)
    {
        unichar c = [self characterAtIndex:i];
        if(![whitespace characterIsMember:c])
        {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)isEmptyOrWhitespace
{
    return self.length == 0 || [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
}

- (BOOL)isEmptyWhitespaceOrNewLines
{
    return self.length == 0 || [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0;
}

- (NSString *)md5
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];

    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    CC_MD5_Update(&md5, [data bytes], (CC_LONG)[data length]);

    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);

    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x", digest[0], digest[1], digest[2], digest[3], digest[4], digest[5], digest[6], digest[7], digest[8], digest[9], digest[10], digest[11], digest[12], digest[13], digest[14], digest[15]];

    return md5String;
}

- (NSString *)cd_safeSubstringWithRange:(NSRange)range
{
    if (self.length < (range.location + 1) || self.length < (range.length + range.location)) return nil;
    
    return [self substringWithRange:range];
}

@end
