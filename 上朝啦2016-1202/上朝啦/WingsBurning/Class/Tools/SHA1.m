//
//  SHA1.m
//  WingsBurning
//
//  Created by MBP on 16/8/22.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "SHA1.h"

#import<CommonCrypto/CommonDigest.h>


@implementation SHA1


+ (NSString *)getSHA1:(NSData *)data
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    //NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];

    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(data.bytes, (unsigned int)data.length, digest);

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];

    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }

    return output;
}

@end
