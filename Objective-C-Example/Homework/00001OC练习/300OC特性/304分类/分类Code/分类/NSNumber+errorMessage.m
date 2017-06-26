//
//  NSNumber+errorMessage.m
//  分类
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "NSNumber+errorMessage.h"

@implementation NSNumber(errorMessage)

- (NSString *)errorInfo
{
    switch ([self intValue]) {
        case 401:
            return @"未经授权";
            break;
        case 403:
            return @"未经授权";
            break;
        case 404:
            return @"找不到网页";
            break;
        case 500:
            return @"服务器错误";
            break;
        case 501:
            return @"没有响应";
            break;
        case 503:
            return @"服务不可用";
            break;
        case 502:
            return @"错误网管";
            break;
        default:
            return @"未知错误";
            break;
    }
}
@end
