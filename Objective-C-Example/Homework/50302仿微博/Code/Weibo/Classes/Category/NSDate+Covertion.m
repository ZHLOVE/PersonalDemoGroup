//
//  NSDate+Covertion.m
//  Weibo
//
//  Created by qiang on 5/9/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "NSDate+Covertion.h"

@implementation NSDate (Covertion)

//Mon May 09 14:24:06 +0800 2016
+ (NSDate *)dateWithString:(NSString *)str
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"EEE MMM dd HH:mm:ss Z yyy";
    df.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
    
    NSDate *date = [df dateFromString:str];
    return date;
}

- (NSString *)descDate
{
    // 临时测试，修改实现

    
    // 1分钟以内 显示 刚刚
    // 60分钟以内 显示 多少分钟之前
    // 60分钟之前 显示 几小时之前
    // 昨天      显示 昨天 07:59
    // 更早的时间 显示 04-05 07:59
    // 去年      显示 15-12-09 07:59
    
    // 计算发布的时间到现在过了多久
    NSTimeInterval toNow = [[NSDate date] timeIntervalSinceDate:self];
    
    // 日历对象
    NSCalendar *c = [NSCalendar currentCalendar];
    
    // 日期格式化对象
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSString *formatStr = @"HH:mm";
    
    if([c isDateInToday:self])// 判断是否是今天
    {
        if(toNow < 60) // 一分钟之内
        {
            return @"刚刚";
        }
        if(toNow < 60 * 60) //1小时分钟之内
        {
            return [NSString stringWithFormat:@"%.0f分钟前",toNow/60];
        }
        return [NSString stringWithFormat:@"%.0f小时前 ",toNow/60/60];// 今天之内，但是1小时以上
    }
    else if([c isDateInYesterday:self])// 是否是昨天
    {
        formatStr = [@"昨天 " stringByAppendingString:formatStr];
    }
    else // 更早的时间
    {
        // 当前时间的年份
        NSDateComponents *nowCmps = [c components:NSCalendarUnitYear fromDate:[NSDate date]];
        // 发表时间的年份
        NSDateComponents *selfCmps = [c components:NSCalendarUnitYear fromDate:self];
        
        if(nowCmps.year == selfCmps.year)
        {
            formatStr = [@"MM-dd " stringByAppendingString:formatStr];
        }
        else
        {
            formatStr = [@"yyyy-MM-dd " stringByAppendingString:formatStr];
        }
    }
    df.dateFormat = formatStr;
    return [df stringFromDate:self];
}
@end
