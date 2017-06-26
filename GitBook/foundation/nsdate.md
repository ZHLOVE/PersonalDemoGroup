# NSDate

```objc
#pragma mark - NSDate 日期时间类 NSDateFormatter NSCalendar 日期格式类
// 得到当前时间
NSDate *now = [NSDate date];
NSLog(@"%@",now);

// 了解
// 时区
//NSTimeZone *zone = [NSTimeZone systemTimeZone];
//NSLog(@"%@",zone);
//// 计算时区和伦敦时区的时差
//NSInteger interval = [zone secondsFromGMTForDate:now];
//// 伦敦时间加上
//NSDate *locale = [now dateByAddingTimeInterval:interval];
//NSLog(@"%@",locale);

// NSDate <--> NSString
NSDateFormatter *f = [[NSDateFormatter alloc] init];

// 1.系统定义的格式 NSDateFormatter
//[f setDateStyle:NSDateFormatterFullStyle];// 日期
//[f setTimeStyle:NSDateFormatterNoStyle];// 时间

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
//NSDate *date1 = [NSDate date];// 时间1
//for(int i=0;i<100000000;i++)
//{
//    float i= pow(M_PI, 5);
//}
//NSDate *date2 = [NSDate date];// 时间2
//NSTimeInterval second = [date2 timeIntervalSinceDate:date1];
//NSLog(@"这个循环总共运行了:%g秒",second);

// NSCalendar 日历类
NSCalendar *calendar = [NSCalendar currentCalendar];
NSCalendarUnit type = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;
NSDateComponents *components = [calendar components:type fromDate:now];
NSLog(@"%i-%i-%i %i:%i",components.year,components.month,components.day,components.hour,components.minute);
```


字母  日期或时间元素    表示     示例       
G     Era   标志符     Text     AD       
y     年     Year     1996 96       
M     年中的月份     Month     July;   Jul; 07       
w     年中的周数     Number     27       
W     月份中的周数        Number     2       
D     年中的天数     Number     189       
d     月份中的天数        Number        10       
F     月份中的星期     Number        2       
E     星期中的天数    Text     Tuesday;   Tue       
a     Am/pm   标记        Text     PM       
H     一天中的小时数（0-23）     Number       0       
k     一天中的小时数（1-24）      Number     24       
K     am/pm   中的小时数（0-11）     Number    0       
h     am/pm   中的小时数（1-12）     Number    12       
m     小时中的分钟数        Number     30       
s     分钟中的秒数         Number     55       
S     毫秒数         Number     978       
z     时区     General   time   zone     Pacific   Standard   Time;   PST;   GMT-08:00       
Z     时区     RFC   822   time   zone     -0800       