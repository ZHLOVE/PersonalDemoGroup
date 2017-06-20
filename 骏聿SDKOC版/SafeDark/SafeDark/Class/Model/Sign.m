//
//  Sign.m
//  SafeDarkVC
//
//  Created by M on 16/6/20.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Sign.h"
#import "define.h"
#import "MD5.h"

@interface Sign()



@end
@implementation Sign


- (NSDictionary *)creatSignWithAppKey:(NSString *)appKey
                            appSecret:(NSString *)appSecret
                               params:(NSDictionary *)params


{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval delta = [zone secondsFromGMTForDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] + delta];
    NSString *timestamp = [[string componentsSeparatedByString:@"."]objectAtIndex:0];//时间戳
    NSDictionary *ext_params = @{@"app_key": appKey,
                                 @"app_secret": appSecret,
                                 @"timestamp": timestamp};

    NSMutableArray *mArray = [@[@"app_key",@"app_secret",@"timestamp"] mutableCopy];
    NSMutableDictionary *mDict = [ext_params mutableCopy];
    //将params拼接到数组中
    for (NSString *key in params) {
        [mDict setObject:params[key] forKey:key];
        [mArray addObject:key];
    }
    //根据所有的key按首字母排序
    NSArray *sortedArray = [mArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableString *mStr = [[NSMutableString alloc]init];
    //排序后拼接成字符串进行加密
    for (NSString *key in sortedArray) {
        [mStr appendString:key];
        NSString *value = [NSString stringWithFormat:@"%@",mDict[key]];
        [mStr appendString:value];
    }
    NSString *payload = [MD5 md5:mStr];
    NSDictionary *out_params = @{X_App_Key: appKey,
                                 X_App_Signature: payload,
                                 X_Timestamp: timestamp};

    return out_params;
}


@end
