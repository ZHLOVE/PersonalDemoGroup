//
//  ViewController.m
//  Lock练习
//
//  Created by student on 16/3/23.
//  Copyright © 2016年 马千里. All rights reserved.
//
// 练习:
// 一个盒子里有100块奶酪,有个鼠洞通到盒子
// 3只老鼠,老鼠需要把奶酪叼回自己的窝里，每只老鼠搬得速度不同。(起始的时候，每只老鼠窝里有10块奶酪)
// 鼠洞很小，每一刻只能有一只老鼠在里面通行。（搬奶酪过程，线程互斥）
// 每只老鼠跑动速度不同(来回搬一次时间为3s 4s 5s)
// 老鼠如果不在叼奶酪，就是在窝里吃奶酪(每秒吃0.1块)，显示最后3只老鼠窝里的奶酪数量，如果没得吃，那只老鼠饿死。
// 线程结束条件:盒子里奶酪没了,或者饿死了。

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,assign) int cheese;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cheese = 100;
}




@end
