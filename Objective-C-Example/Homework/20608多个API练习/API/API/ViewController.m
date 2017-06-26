//
//  ViewController.m
//  API
//
//  Created by 马千里 on 16/3/29.
//  Copyright © 2016年 马千里. All rights reserved.
//
/*
 1. 查询身份证
 2. 汇率查询接口
 3. 手机号归属地
 4. 天气
 */

#import "ViewController.h"

#import "NetManageer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *phoneResult;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activeView;

//@property (weak, nonatomic) IBOutlet UITextField *cnyTextField;
@property (weak, nonatomic) IBOutlet UITextView *rateTextView;
@property (weak, nonatomic) IBOutlet UITextField *cityName;
@property (weak, nonatomic) IBOutlet UITextView *cityWeather;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)phoneBtnPressed:(UIButton *)sender {
    [self.activeView startAnimating];
    [NetManageer requestInfoByPhone:self.phoneTextField.text successBlock:^(NSString *result) {
        self.phoneResult.text = result;
        [self.activeView stopAnimating];
    } failBlock:^(NSError *error) {
        self.phoneResult = [error localizedDescription];
        [self.activeView stopAnimating];
    }];
}


- (IBAction)rateBtnPressed:(UIButton *)sender {
    [self.activeView startAnimating];

    [NetManageer requestInfoByCNY:@"CNY" successBlock:^(NSDictionary *result) {
        NSMutableString *mStr = [NSMutableString string];
        NSDictionary *dictList = [NSDictionary dictionary];
        for (int i=0; i<result.allKeys.count; i++) {
            NSString *str = result.allKeys[i];
            dictList = [result objectForKey:str];
//            NSLog(@"%@",dictList);
////            for (NSDictionary *dict in dictList) {
//                [mStr stringByAppendingString:dictList[@"name"]];
//                [mStr stringByAppendingString:dictList[@"rate"]];
//                [mStr stringByAppendingString:dictList[@"updatetime"]];
////            }
        }
        self.rateTextView.text = [mStr copy];
        [self.activeView stopAnimating];
    } failBlock:^(NSError *error) {
        NSLog(@"连接错误");
        self.rateTextView.text = [error localizedDescription];
        [self.activeView stopAnimating];
    }];
}
//city: "北京", //城市
//pinyin: "beijing", //城市拼音
//citycode: "101010100",  //城市编码
//date: "15-02-11", //日期
//time: "11:00", //发布时间
//postCode: "100000", //邮编
//longitude: 116.391, //经度
//latitude: 39.904, //维度
//altitude: "33", //海拔
//weather: "晴",  //天气情况
//temp: "10", //气温
//l_tmp: "-4", //最低气温
//h_tmp: "10", //最高气温
//WD: "无持续风向",	 //风向
//WS: "微风(<10m/h)", //风力
//sunrise: "07:12", //日出时间
//sunset: "17:44" //日落时间

- (IBAction)weatherBtnPressed:(id)sender {
    [self.activeView startAnimating];
    [NetManageer requestWeatherInfoByCityName:self.cityName.text successBlock:^(NSDictionary *result) {
        NSLog(@"%@",result);
//        NSMutableString *mStr = [NSMutableString string];1
        NSString *str = [NSString stringWithFormat:@"城市:%@\n邮编:%@\n日期:%@\n发布时间:%@\n海拔:%@\n天气情况:%@\n气温:%@\n最低气温:%@\n最高气温:%@\n风向:%@\n风力:%@\n日出时间:%@\n日落时间:%@\n",result[@"city"],result[@"citycode"],result[@"date"],result[@"time"],result[@"altitude"],result[@"weather"],result[@"temp"],result[@"l_tmp"],result[@"h_tmp"],result[@"WD"],result[@"WS"],result[@"sunrise"],result[@"sunset"]];
        self.cityWeather.text = str;
        [self.activeView stopAnimating];
    } failBlock:^(NSError *error) {
        self.cityWeather.text = [error localizedDescription];
        [self.activeView stopAnimating];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
