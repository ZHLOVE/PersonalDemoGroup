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

/**
 *  保存token到沙盒
 */
+ (void)saveToken:(TokensM *)tokens{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:tokens.access_token forKey:@"access_token"];
    [ud setObject:tokens.refresh_token forKey:@"refresh_token"];
}


/**
 *  检查accessToken
 */
+ (BOOL)checkAccessToken{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    if (token != nil) {
        return YES;
    }
    return NO;
}

/**
 *  从沙盒中拿accessToken
 */
+ (NSString *)getAccessTokenFromSandBox{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"access_token"];
    return token;
}

/**
 *  从沙盒中拿refreshToken
 */
+ (NSString *)getRefreshTokenFromSandBox{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *token = [ud objectForKey:@"refreshToken"];
    return token;
}

/**
 *  获取星期几
 *
 *  @param inputDateStr yyyy-MM-dd
 */
+ (NSString*)weekdayStringFromDate:(NSDate *)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}





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
    return [MD5 md5:str];
}
@end
