//
//  ViewController.m
//  TestQiangFramework
//
//  Created by niit on 16/4/20.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

#import <QiangFramework/QiangFramework.h>

// 资料参考网址: http://www.cocoachina.com/ios/20141126/10322.html
// 查看支持的cpu
// lipo -info ./QiangFramework.framework/QiangFramework

// 步骤:
// 1. 将QiangFramework.framework拉入项目
// 2. 项目设置 General 中 Embedded Library 中添加 QiangFramework.framework
// 3. 引入头文件 #import <QiangFramework/QiangFramework.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 测试库中方法
    NSLog(@"%i ",[MySuperUtil addA:5 andB:3]);
}

@end
