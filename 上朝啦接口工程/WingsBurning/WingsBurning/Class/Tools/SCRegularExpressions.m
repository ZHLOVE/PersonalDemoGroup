//
//  SCRegularExpressions.m
//  WingsBurning
//
//  Created by MBP on 16/8/23.
//  Copyright © 2016年 leqi. All rights reserved.
//
#import "SCRegularExpressions.h"
#import "sys/utsname.h"
@implementation SCRegularExpressions
//邮箱
+ (BOOL) validateEmail:(NSString *)email

{

    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

    return [emailTest evaluateWithObject:email];

}
//手机号码验证
+ (BOOL)validateMobile:(NSString *)phone{

    NSString *MOBILE = @"^1[34578]\\d{9}$";

    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];

    if ([regexTestMobile evaluateWithObject:phone]) {

        return YES;

    }else {

        return NO;
    }

}
//车牌号验证

+ (BOOL) validateCarNo:(NSString *)carNo

{

    NSString *carRegex = @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$";

    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];

    NSLog(@"carTest is %@",carTest);

    return [carTest evaluateWithObject:carNo];

}
//车型

+ (BOOL) validateCarType:(NSString *)CarType

{

    NSString *CarTypeRegex = @"^[\u4E00-\u9FFF]+$";

    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CarTypeRegex];

    return [carTest evaluateWithObject:CarType];

}
//用户名

+ (BOOL) validateUserName:(NSString *)name

{

    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";

    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];

    BOOL B = [userNamePredicate evaluateWithObject:name];

    return B;

}
//密码

+ (BOOL) validatePassword:(NSString *)passWord

{

    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";

    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];

    return [passWordPredicate evaluateWithObject:passWord];

}

//昵称

+ (BOOL) validateNickname:(NSString *)nickname

{

    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";

    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];

    return [passWordPredicate evaluateWithObject:nickname];

}
//身份证号

+ (BOOL) validateIdentityCard: (NSString *)identityCard

{

    BOOL flag;

    if (identityCard.length <= 0) {

        flag = NO;

        return flag;

    }

    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";

    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];

    return [identityCardPredicate evaluateWithObject:identityCard];

}
//判断是否有特殊符号

- (BOOL)effectivePassword

{

    //    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"&\"< >\\/*/null & /* /NULL"];

    //    NSString *trimmedString = [self stringByTrimmingCharactersInSet:set];

    //    return trimmedString;

    NSString *regex = @"[a-zA-Z0-9]{6,20}";

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

    return [predicate evaluateWithObject:self];

}
//判断手机型号

+ (NSString *)deviceString

{

    // 需要#import "sys/utsname.h"

    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";

    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";

    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";

    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";

    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";

    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";

    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";

    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";

    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";

    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";

    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";

    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";

    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";

    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";

    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";

    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";

    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";

    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";

    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";

    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";

    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";

    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";

    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";

    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";

    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";

    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";

    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";

    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";

    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";

    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";

    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";

    if ([deviceString isEqualToString:@"iPad4,4"])      return @"iPad Mini 2G (WiFi)";

    if ([deviceString isEqualToString:@"iPad4,5"])      return @"iPad Mini 2G (Cellular)";

    if ([deviceString isEqualToString:@"iPad4,6"])      return @"iPad Mini 2G";

    if ([deviceString isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";

    if ([deviceString isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (Cellular)";

    if ([deviceString isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (China)";

    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";

    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (Cellular)";

    if ([deviceString isEqualToString:@"AppleTV2,1"])  return @"Apple TV 2G";

    if ([deviceString isEqualToString:@"AppleTV3,1"])  return @"Apple TV 3";

    if ([deviceString isEqualToString:@"AppleTV3,2"])  return @"Apple TV 3 (2013)";

    if ([deviceString isEqualToString:@"i386"])        return @"Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])      return @"Simulator";
    
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    
    return deviceString;
    
}

@end
