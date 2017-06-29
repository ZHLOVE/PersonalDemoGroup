//
//  TokensM.m
//  WingsBurning
//
//  Created by MBP on 16/8/19.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "TokensM.h"
#import "MJExtension.h"

@implementation TokensM

MJExtensionLogAllProperties
- (NSString *)refresh_token{
    if (_refresh_token == nil) {
        return @"refreshToken_nil";
    }
    return _refresh_token;
}
@end
