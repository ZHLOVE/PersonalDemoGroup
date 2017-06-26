//
//  DateSaver.m
//  文件操作
//
//  Created by niit on 16/1/12.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "DateSaver.h"

@implementation DateSaver

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(saveCurDate) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)saveCurDate
{
    // 1 得到时间 NSDate
    NSDate  *now = [NSDate date];
    
    // 2 时间对象 NSDate -> NSString
    // NSDate <--> NSString
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [f stringFromDate:now];
    NSLog(@"%@",dateStr);
    
    // 3 打开文件 把NSString 写入文件  关闭文件
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"date.txt"];
    if(![fm fileExistsAtPath:filePath])
    {
        [fm createFileAtPath:filePath contents:nil attributes:nil];
    }
    NSLog(@"%@",filePath);
    NSFileHandle *f2 = [NSFileHandle fileHandleForWritingAtPath:filePath];// 写入方式打开
    [f2 seekToEndOfFile];// 操作指针移到文件最后
    dateStr = [dateStr stringByAppendingString:@"\n"];
    NSData *data = [dateStr dataUsingEncoding:NSUTF8StringEncoding];// NSString -> NSData
    [f2 writeData:data];// 写入文件
    [f2 closeFile];
}

@end
