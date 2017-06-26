//
//  ViewController.m
//  正则表达式
//
//  Created by student on 16/5/3.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnPressed:(id)sender {
    NSString *str = @"@jack12:【动物尖叫合辑】#肥猪流#猫头鹰这么尖叫[偷笑]、@船长: 老鼠这么尖叫、兔子这么尖叫[吃惊]、@花满楼: 莫名奇#小笼包#妙的笑到最后[好爱哦]！~ http://www.jianshu.com 电话: 17334332342";
    // 1.匹配@名字:
    // NSString *pattern = @"@.*?:";
    
    // 2.匹配URL
    // NSString *pattern = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?";
    
    // 3.匹配话题 #....#
    // NSString *pattern = @"#.*?#";
    
    // 4.手机号码匹配
        NSString *pattern = @"1[3578]\\d{9}$";
    
    NSError *error = nil ;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (result) {
        for (int i = 0; i<result.count; i++) {
            NSTextCheckingResult *res = result[i];
            NSLog(@"str == %@", [str substringWithRange:res.range]);
        }
    }else{
        NSLog(@"error == %@",error.description);
    }

}






















@end
