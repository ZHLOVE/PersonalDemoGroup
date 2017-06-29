//
//  Verify.m
//  Tesla
//
//  Created by MBP on 16/7/21.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "Verify.h"
#import "MD5.h"

#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation Verify

/**
 *  开关
 */
+ (void)saveShareEnable:(NSString *)share{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:share forKey:@"shareEnable"];
}

/**
 *  开关
 */
+ (NSString *)getShareEnable{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *share = [ud objectForKey:@"shareEnable"];
    return share;
}


/**
 *  新手指引开关
 */
+ (void)setGuideShow:(GuideShow *)show{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:show.mainGuide forKey:@"mainGuide"];
    [ud setBool:show.punchRecordGuide forKey:@"punchRecordGuide"];
    [ud setBool:show.slideGuide forKey:@"slideGuide"];

}

/**
 *  新手指引开关
 */
+ (GuideShow *)getGuideShow{
    GuideShow *show = [[GuideShow alloc]init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    show.mainGuide = [ud boolForKey:@"mainGuide"];
    show.punchRecordGuide = [ud boolForKey:@"punchRecordGuide"];
    show.slideGuide = [ud boolForKey:@"slideGuide"];
    return show;
}

/**
 *  保存手机型号
 */
+(void)savePhoneType:(NSString *)phoneType{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:phoneType forKey:@"phone_Type"];
}

/**
 *  获取沙盒中手机型号
 */
+(NSString *)getPhoneType{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"phone_Type"];
}

/**
 *  从沙盒获取token
 */
+ (TokensM *)getTokenFromSanBox{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    TokensM *tokens = [[TokensM alloc]init];
    tokens.access_token = [ud objectForKey:@"access_token"];
    tokens.refresh_token = [ud objectForKey:@"refresh_token"];
    return tokens;
}


/**
 *  清除token和头像
 */
+ (void)removeToken{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"access_token"];
    [ud removeObjectForKey:@"refresh_token"];
    [ud removeObjectForKey:@"touXiang"];
}

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
 *  存合约ID到沙盒
 */
+ (void)saveContractIDToSandBox:(NSString *)contractID{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:contractID forKey:@"contractID"];
}

/**
 *  存合约状态
 */
+ (void)saveContractStateToSandBox:(NSString *)state{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:state forKey:@"contractState"];
}

/**
 *  取合约状态
 */
+ (NSString *)getContractStateToSandBox{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *state = [ud objectForKey:@"contractState"];
    return state;
}


/**
 *  从沙盒中拿合约ID
 */
+ (NSString *)getContractIDFromSandBox{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *contractID = [ud objectForKey:@"contractID"];
    return contractID;
}

/**
 *  存雇员信息
 */
+ (void)saveEmployee:(EmployeeM *)employee{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:employee.ID forKey:@"employeeID"];
    [ud setObject:employee.avatar_url forKey:@"employeeAvatar_url"];
    [ud setObject:employee.created_at forKey:@"employeeCreated_at"];
    [ud setObject:employee.name forKey:@"employeeName"];
    [ud setObject:employee.phone_number forKey:@"employeePhone_number"];
}
/**
 *  取雇员信息
 */
+ (EmployeeM *)getEmployeeFromSandBox{
    EmployeeM *employee = [[EmployeeM alloc]init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    employee.ID = [ud objectForKey:@"employeeID"];
    employee.avatar_url = [ud objectForKey:@"employeeAvatar_url"];
    employee.created_at = [ud objectForKey:@"employeeCreated_at"];
    employee.name = [ud objectForKey:@"employeeName"];
    employee.phone_number = [ud objectForKey:@"employeePhone_number"];
    return employee;
}

/**
 *  存雇主信息
 */
+  (void)saveEmployerToSH:(EmployerM *)employer{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:employer.ID forKey:@"employerID"];
    [ud setObject:employer.image_url forKey:@"employerImage_url"];
    [ud setObject:employer.address forKey:@"employerAddress"];
    [ud setObject:employer.name forKey:@"employerName"];
    [ud setObject:employer.phone_number forKey:@"employerPhone_number"];
}

/**
 *  取雇主信息
 */
+  (EmployerM *)getEmployerFromSH{
    EmployerM *employer = [[EmployerM alloc]init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    employer.ID = [ud objectForKey:@"employerID"];
    employer.image_url = [ud objectForKey:@"employerImage_url"];
    employer.address = [ud objectForKey:@"employerAddress"];
    employer.name = [ud objectForKey:@"employerName"];
    employer.phone_number = [ud objectForKey:@"employerPhone_number"];
    return employer;
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
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

/**
 *  是否能打卡
 *
 *  @param enable YES则进入打卡，NO就显示未签约
 */

+ (void)setPunchEnable:(BOOL)enable{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:enable forKey:@"punchEnable"];
}

+ (BOOL)getPunchEnable{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"punchEnable"];
}


/**
 *  首次拍照
 *
 *  @param first YES则跳转注册NO就上传打卡
 */
+ (void)setFirstCapture:(BOOL)first{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:first forKey:@"firstCapture"];
}
/**
 *  设置拍照后是否跳转到注册页面
 */
+ (BOOL)getFirstCapture{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:@"firstCapture"];
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

/**
 *  设置经度
 */
+ (void)setLongitude:(NSNumber *)lo{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:lo forKey:@"longitude"];
}

/**
 *  设置纬度
 */
+ (void)setLatitude:(NSNumber *)la{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:la forKey:@"latitude"];
}

/**
 *  获得经度
 */
+ (NSNumber *)getLongitude{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"longitude"];
}
/**
 *  获得纬度
 */
+ (NSNumber *)getLatitude{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"latitude"];
}

/**
 *  保存头像
 */
+ (void)saveEmployeeImage:(NSData *)imgData{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:imgData forKey:@"touXiang"];
}
/**
 *  获得头像
 */
+ (NSData *)getImage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:@"touXiang"];
}

/**
 *  判断Wifi开关
 */
+ (BOOL)isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;

    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}



@end
