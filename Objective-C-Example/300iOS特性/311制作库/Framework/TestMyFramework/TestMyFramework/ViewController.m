//
//  ViewController.m
//  TestMyFramework
//
//  Created by qiang on 16/4/19.
//  Copyright © 2016年 QiangTech. All rights reserved.
//

#import "ViewController.h"

#import <QiangFramework/QiangFramework.h>
#import <QiangFramework/MyUtils.h>

//lipo -info ./MyFramework.framework/MyFramework
// 原文: http://www.cocoachina.com/ios/20141126/10322.html

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MyUtils *u = [[MyUtils alloc] init];
    [u log:@"abc"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
