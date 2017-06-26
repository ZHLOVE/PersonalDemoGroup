//
//  ViewController.m
//  HellodLabel
//
//  Created by MBP on 2016/12/16.
//  Copyright © 2016年 leqi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 50)];
    label.text = @"今天下午全市多云到阴有阵雨或雷雨，今天夜里到明天阴有阵雨，雨量可达大雨。 东北风5-6级阵风7级，逐渐增强到6-7级阵风8级。 今天最高气温:26左右， 明晨最低气温:22左右。 今晨最低气温:21。 今日紫外线等级:2级，照射强度弱，适当防护。 明日洗车指数:4级，天气有雨，不宜洗车。";
//    label.text = @"今天下午全市多云到阴有阵雨或雷雨，今天夜里到明天阴有阵雨，雨量可达大雨。 东北风5-6级阵风7级，逐渐增强到6-7级阵风8级。";
    //清空背景颜色
    label.backgroundColor = [UIColor clearColor];
    //设置字体颜色为白色
    label.textColor = [UIColor whiteColor];
    //设置label的背景色为黑色
    label.backgroundColor = [UIColor blackColor];
    //文字居中显示
    label.textAlignment = UITextAlignmentCenter;
    //自动折行设置
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.numberOfLines = 0;

    //自适应高度
    CGRect txtFrame = label.frame;

    label.frame = CGRectMake(10, 100, 300,
                             txtFrame.size.height =[label.text boundingRectWithSize:
                                                    CGSizeMake(txtFrame.size.width, CGFLOAT_MAX)
                                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                         attributes:[NSDictionary dictionaryWithObjectsAndKeys:label.font,NSFontAttributeName, nil] context:nil].size.height);
    label.frame = CGRectMake(10, 100, 300, txtFrame.size.height);
    label.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:label];}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
