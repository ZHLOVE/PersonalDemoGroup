//
//  ViewController.m
//  TouchEvent
//
//  Created by niit on 16/3/17.
//  Copyright © 2016年 NIIT. All rights reserved.
//

#import "ViewController.h"

// 如果点击了红的一块
// 事件传递链 从左到右 -> (如果某一级userTouchEnabled为NO,则不再向下传递)
// UIApplication -> ViewController -> self.view -> yellowview -> blueView -> redview
// 事件相应链 从右到左 <- (如果不处理则交给前一级处理)
// UIApplication <- ViewController <- self.view <- yellowview <- blueView <- redview

// 不能相应事件的情况:
// 1. 用户交互 userInteractionEnabled == NO
// 2. 隐藏 hidden == YES
// 3. 透明度 alpha 0~0.01

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}
- (void)touchesCancelled:(nullable NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    NSLog(@"%s",__func__);
}

@end
