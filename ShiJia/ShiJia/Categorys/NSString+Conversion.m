//
//  NSString+Conversion.m
//  HiTV
//
//  Created by yy on 15/8/24.
//  Copyright (c) 2015年 Lanbo Zhang. All rights reserved.
//

#import "NSString+Conversion.h"

@implementation NSString (Conversion)

- (NSString *)convertChineseToPinYin
{
    if ([self length]) {
        
        NSString *illegalString = @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€-";
    
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        
        
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        [ms replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
        
        
        for (int i = 0; i<[ms length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [ms substringWithRange:NSMakeRange(i, 1)];
            if ([illegalString rangeOfString:s].location != NSNotFound) {
                [ms replaceOccurrencesOfString:s withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
            }
        }
        
        if (ms.length != 0) {
            return ms;
        }
        return nil;
    }
    else{
        return nil;
    }
}

- (NSString *)lowercaseStringWithoutIllegalcharacters
{
    if ([self length]) {
        
        NSString *illegalString = @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€-";
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:[self lowercaseString]];
        
        
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);
        [ms replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
        
        
        for (int i = 0; i<[ms length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [ms substringWithRange:NSMakeRange(i, 1)];
            if ([illegalString rangeOfString:s].location != NSNotFound) {
                [ms replaceOccurrencesOfString:s withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [ms length])];
            }
        }
        
        if (ms.length != 0) {
            return ms;
        }
        return nil;
    }
    else{
        return nil;
    }
}

+ (NSString *)generateUUID
{
    NSString *result = nil;
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    if (uuid)
    {
        result = (__bridge_transfer NSString *)CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
    }
    
    return [result lowercaseStringWithoutIllegalcharacters];
}


//检查是否包含特殊符合
-(BOOL)isIncludeSpecialCharact: (NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"-~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€-"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

@end
