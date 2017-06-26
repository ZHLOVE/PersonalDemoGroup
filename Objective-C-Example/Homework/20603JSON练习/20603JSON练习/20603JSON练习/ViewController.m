//
//  ViewController.m
//  20603JSON练习
//
//  Created by student on 16/3/25.
//  Copyright © 2016年 马千里. All rights reserved.
//
// 练习:
// 1. 获取并解析无锡的天气信息:
// http://www.weather.com.cn/adat/cityinfo/101190201.html

// 2. 获取并解析今日比特币行情信息:
//https://www.okcoin.cn/api/ticker.do

// 3. 获取并解析股票信息
// http://api.money.126.net/data/feed/100002,1000001,1000881,money.api
// (提示:需要先转换成字符串,去掉不必要的字符串,再转换回data，再进行解析

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *city;
@property (weak, nonatomic) IBOutlet UILabel *cityId;
@property (weak, nonatomic) IBOutlet UILabel *ptime;
@property (weak, nonatomic) IBOutlet UILabel *temp1;
@property (weak, nonatomic) IBOutlet UILabel *temp2;
@property (weak, nonatomic) IBOutlet UILabel *weather;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSString *urlStr = @"http://www.weather.com.cn/adat/cityinfo/101190201.html";
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *weatherinfo = [[dict objectForKey:@"weatherinfo"] copy];
//    for (NSString *key in weatherinfo.allKeys) {
//        NSLog(@"%@",weatherinfo[key]);
//    }
    NSLog(@"%@",weatherinfo);
    self.city.text = weatherinfo[@"city"];
    self.cityId.text = weatherinfo[@"cityid"];
    self.temp1.text = weatherinfo[@"temp1"];
    self.temp2.text = weatherinfo[@"temp2"];
    self.weather.text = weatherinfo[@"weather"];
    self.ptime.text = weatherinfo[@"ptime"];
    NSString *imgUrlStr = @"http://www.weather.com.cn/adat/cityinfo/101190201.html/d7.gif";
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrlStr]];
    self.img1 = [[UIImageView alloc]initWithImage:[UIImage imageWithData:imgData]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
