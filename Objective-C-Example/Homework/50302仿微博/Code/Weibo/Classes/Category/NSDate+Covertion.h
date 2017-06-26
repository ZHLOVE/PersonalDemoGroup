//
//  NSDate+Covertion.h
//  Weibo
//
//  Created by qiang on 5/9/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import <Foundation/Foundation.h>


// 1 当前:(要处理的字符串:)
//    Mon May 09 14:24:06 +0800 2016

// 2 结果:(转换成的字符串)
// 1分钟以内 显示 刚刚
// 60分钟以内 显示 多少分钟之前
// 60分钟之前 显示 几小时之前
// 昨天      显示 昨天
// 更早的时间 显示 04-05
// 去年      显示 15-12-09


@interface NSDate (Covertion)

// Mon May 09 14:26:45 +0800 2016 -> NSDate
+ (NSDate *)dateWithString:(NSString *)str;
// NSDate -> 刚刚
- (NSString *)descDate;

@end
