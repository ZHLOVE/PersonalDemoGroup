//
//  main.m
//  其他常用结构体和类
//
//  Created by niit on 16/1/6.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import <Foundation/Foundation.h>



int main(int argc, const char * argv[]) {
    @autoreleasepool {

#pragma mark - 常用结构体
        // 二维坐标系
        // 1 CGPoint和NSPoint 保存坐标信息(xy)
        NSPoint point1 = NSMakePoint(10, 20);
        CGPoint point2 = CGPointMake(10, 20);
        CGPoint point3 = {10,20};
        
//        NSLog(@"x=%f,y=%f",point1.x,point1.y);
//        NSLog(@"%@",NSStringFromPoint(point1));
        
        // 2 CGSize与NSSize 保存尺寸信息(width和height)
        NSSize size1 = NSMakeSize(100, 50);
        CGSize size2 = CGSizeMake(100, 50);
        CGSize size3 = {100,50};
        
//        NSLog(@"width=%f,height=%f",size1.width,size1.height);
//        NSLog(@"%@",NSStringFromSize(size1));
        
        // 3 CGRect和NSRect 保存界面上对象的起始坐标和宽高
        NSRect rect1 = NSMakeRect(10, 20, 100, 50);
        CGRect rect2 = CGRectMake(100, 20, 150, 250);
        CGRect rect3 = {{10,20},{100,50}};
        
//        NSLog(@"x=%f,y=%f,width=%f,height=%f",rect1.origin.x,rect1.origin.y,rect1.size.width,rect1.size.height);
//        NSLog(@"%@",NSStringFromRect(rect1));
        
        // 4 苹果建议使用CG
        
#pragma mark - NSValue类
        
        // 用处:结构体不是对象,不能放入NSArray等容器，必须通过NSValue变成对象才可以
        
        // 主要功能把结构体封装到对象里
        // 1.封装
//        + (NSValue *)valueWithBytes:(const void *)value    //要封装变量的地址
//                           objCType:(const char *)type;    //@encode(类型名)
        // 2.提取
        // - (void)getValue:(void *)value;                   //提取到变量的地址
        
        NSValue *v1 = [NSValue valueWithBytes:&rect1 objCType:@encode(CGRect)];//将rect1的值封装到v1
        NSValue *v2 = [NSValue valueWithBytes:&rect2 objCType:@encode(CGRect)];
        NSArray *arr = @[v1,v2];
        
        for(NSValue *v in arr)
        {
            CGRect tmpRect;
            [v getValue:&tmpRect];// 把值提取到tmpRect
            NSLog(@"%@",NSStringFromRect(tmpRect));
        }
        
#pragma mark - NSDate 日期时间类 NSDateFormatter NSCalendar 日期格式类
        // 得到当前时间
        NSDate *now = [NSDate date];
        NSLog(@"%@",now);
        
        // 了解
//        // 时区
//        NSTimeZone *zone = [NSTimeZone systemTimeZone];
//        NSLog(@"%@",zone);
//        // 计算时区和伦敦时区的时差
//        NSInteger interval = [zone secondsFromGMTForDate:now];
//        // 伦敦时间加上
//        NSDate *locale = [now dateByAddingTimeInterval:interval];
//        NSLog(@"%@",locale);
        
        // NSDate <--> NSString
        NSDateFormatter *f = [[NSDateFormatter alloc] init];
        
        // 1.系统定义的格式 NSDateFormatter
//        [f setDateStyle:NSDateFormatterFullStyle];// 日期
//        [f setTimeStyle:NSDateFormatterNoStyle];// 时间
        
        // 2.自定义格式
        //y 年
        //M 月
        //d 日
        //H m s 时分秒
        [f setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        // NSDate -> NSString
        NSString *dateStr = [f stringFromDate:now];
        NSLog(@"%@",dateStr);
        
        // NSString -> NSDate
        NSDate *d2 = [f dateFromString:@"2020-10-1 12:12:13"];
        NSLog(@"%@",d2);
        
        NSDate *tomorrow = [NSDate dateWithTimeIntervalSinceNow:24*60*60];// 得到明天的这个时候的时间
        NSLog(@"%@",tomorrow);
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-24*60*60];// 得到昨天的这个时候的时间
        NSLog(@"%@",yesterday);
        NSDate *d3 = [NSDate dateWithTimeInterval:8*60*60 sinceDate:now];// 过8小时后的时间
        NSLog(@"%@",d3);
        
        // 时间比较
        if([now isEqualToDate:tomorrow])
        {
            NSLog(@"两个时间一样");
        }
        if([now earlierDate:tomorrow])
        {
            NSLog(@"现在比明天早");
        }
        if([now laterDate:tomorrow])
        {
            NSLog(@"现在比明天晚");
        }
        
        // 计算时间的间隔
//        NSDate *date1 = [NSDate date];// 时间1
//        for(int i=0;i<100000000;i++)
//        {
//            float i= pow(M_PI, 5);
//        }
//        NSDate *date2 = [NSDate date];// 时间2
//        NSTimeInterval second = [date2 timeIntervalSinceDate:date1];
//        NSLog(@"这个循环总共运行了:%g秒",second);
        
        // NSCalendar 日历类
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit type = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
        NSDateComponents *components = [calendar components:type fromDate:now];
        NSLog(@"%i-%i-%i %i:%i",components.year,components.month,components.day,components.hour,components.minute);
        
#pragma mark - NSData 数据类
        
        NSString *str = @"abc123";
        NSString *d = @"中文啊";
        NSLog(@"%@",d);
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        NSData *strData1 = [str dataUsingEncoding:NSUTF8StringEncoding];// NSString -> NSData
        NSData *strData2 = [d dataUsingEncoding:NSUTF8StringEncoding];// NSString -> NSData
        NSData *strData3 = [d dataUsingEncoding:enc];//GB2312方式 NSString -> NSData
        
        NSLog(@"%@",strData1);//@"abc123"
        NSLog(@"%@",strData2);//@"中文啊"  UTF-8    9个字节 1个中文->3个字节
        NSLog(@"%@",strData3);//@"中文啊"  GB2312   6个字节 1个中文->2个字节
        
        Byte *byte = [strData1 bytes];// 得到字节数组
        for(int i=0;i<strData1.length;i++)
        {
            printf("%i",byte[i]);
        }
        printf("\n");
        
        // 编码 文字->数据 一种文字转换二进制数据的规定和协议。 不同的编码方式，得到二进制制数据是不同的
        //NSUTF8StringEncoding UTF8编码方式
//        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);// GB2312编码方式
        
//        NSString *str = [[NSString alloc] initWithCString: pstr
//                                                 encoding: enc];    //或者直接使用其数值
        
#pragma mark - NSNull(空值)
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:@15];
        [array addObject:@16];
//        [array addObject:nil];// 运行到这里会造成程序crash ，nil代表空指针，数组和字典不能添加空指针
        [array addObject:[NSNull null]];// 表示一个空的值,只是值为空
        [array addObject:@18];
        
// uncaught exception         运行时异常错误
//        Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSArrayM insertObject:atIndex:]: object cannot be nil'

// 错误类型:
// 1 编译错误 (编译阶段 语法错误)
// 2 链接错误 (链接阶段 比如方法没有具体的定义,重复模块)
// 3 运行时异常错误 uncaught exception(运行过程中出错)
        
#pragma mark - 练习
        // 1 将以下坐标点用NSValue封装放入一个OC数组中,遍历输出
        //(100,50)
        //(100,150)
        //(200,150)
        //(200,50)
        
        
    }
    return 0;
}
