//
//  Verify.m
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Verify.h"
#import "MD5.h"
@implementation Verify

//获取时间戳
+ (NSString *)getTimestamp{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval delta = [zone secondsFromGMTForDate:[NSDate date]];
    NSString *string = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] + delta];
    NSString *timestamp = [[string componentsSeparatedByString:@"."]objectAtIndex:0];//时间戳
    return timestamp;
}


//获取签名Verify
+ (NSString *)getVerifyWithApiAccount:(NSString *)apiAccount
                            apiPasswd:(NSString *)apiPasswd
                                uuid:(NSString *)uuuid
                                 time:(NSString *)time{

    NSString *str = [[[apiAccount stringByAppendingString:apiPasswd]stringByAppendingString:uuuid]stringByAppendingString:time];
//    NSLog(@"%@",str);
    return [MD5 md5:str];
}
@end
