//
//  ViewController.m
//  JSON
//
//  Created by niit on 16/3/25.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import "Video.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray *list;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 获取数据
    NSString *urlStr = @"http://120.25.226.186:32812/video?type=JSON";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];// 二进制数据
    
    // NSData -> NSString // 如果有问题,这里可以先转换为NSString打印出来看看获得的数据对不对
//    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",result);
    
    // 大多数网页一般是UTF-8编码,少部分中文网页是GB2312,国外还有其他格式编码
    // UTF-8  NSUTF8StringEncoding
    // GB2312 CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
    
    // 2. 解析数据转换为OC对象
    // NSData -> OC对象(NSDictionary NSArrray)
    NSError *error;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"%@",resultDict);
    
    // 3. 转换成模型放入列表数组
    NSArray *videosArr = resultDict[@"videos"];
    self.list = [NSMutableArray array];
    for (NSDictionary *dict in videosArr)
    {
        Video *v = [Video videoWithDict:dict];
        [self.list addObject:v];
    }
    
    // 练习:以下只需显示数据，不用转换为模型
    // 1. 获取并解析无锡的天气信息:
    // http://www.weather.com.cn/adat/cityinfo/101190201.html
    
    // 2. 获取并解析今日比特币行情信息:
    //https://www.okcoin.cn/api/ticker.do
    
    // 3. 获取并解析股票信息
    // http://api.money.126.net/data/feed/100002,1000001,1000881,money.api
    // 这里面包含了3只股票的信息
    // (提示:需要先转换成字符串,去掉不必要的字符串,再转换回data，再进行解析
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    Video *v = self.list[indexPath.row];
    cell.textLabel.text = v.name;
    cell.detailTextLabel.text = v.url;

    NSString *imageUrlStr = [@"http://120.25.226.186:32812/" stringByAppendingString:v.image];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlStr]];// 获取图片数据,当前是同步请求方式，会卡，需要改进成异步
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image = image;
    
    return cell;
}

@end
