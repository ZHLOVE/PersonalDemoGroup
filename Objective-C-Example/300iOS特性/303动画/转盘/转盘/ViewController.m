//
//  ViewController.m
//  转盘
//
//  Created by qiang on 16/3/21.
//  Copyright © 2016年 Qiangtech. All rights reserved.
//

#import "ViewController.h"

#import "WheelView.h"

// 流程
// 1. 自定义控件
// 2. 添加底板
// 2. 添加中间转盘
// 3. 添加按钮
// 4. 转起来
// 5. 添加转盘上按钮

@interface ViewController ()

@property (nonatomic,strong) WheelView *whellView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.whellView = [WheelView wheelView];
    self.whellView.center = self.view.center;
    
    [self.view addSubview:self.whellView];
}

- (IBAction)startRotation:(id)sender
{
    [self.whellView start];
}

- (IBAction)stopRotation:(id)sender
{
    [self.whellView stop];
}


@end
