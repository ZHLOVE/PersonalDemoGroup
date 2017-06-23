//
//  ViewController.m
//  Timer
//
//  Created by qiang on 5/3/16.
//  Copyright © 2016 QiangTech. All rights reserved.
//

#import "ViewController.h"


#import "MyThread.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 创建一个定时器 方法1
//    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doSomething) userInfo:nil repeats:YES];
    
    
    // 方法2
//    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doSomething) userInfo:nil repeats:YES];
////    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];// 默认模式
////    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];// 拖动scrollView的时候的模式
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];// 综合2种模式
    
    // 线程
    MyThread *thread = [[MyThread alloc] initWithTarget:self selector:@selector(doSomething2) object:nil];
    [thread start];
    
    // 显示一下NSRunLoop信息
//    NSLog(@"%@",[NSRunLoop currentRunLoop]);
//    NSLog(@"%@",[NSRunLoop mainRunLoop]);
//    
//    NSLog(@"%@",CFRunLoopGetCurrent());
//    NSLog(@"%@",CFRunLoopGetMain());
    
}

- (IBAction)btnPressed:(id)sender
{
    NSLog(@"%s",__func__);
}


- (void)doSomething
{
    NSLog(@"%s",__func__);
}


- (void)doSomething2
{
    NSLog(@"%s",__func__);
    
    NSLog(@"%@",[NSRunLoop currentRunLoop]);
    
    NSTimer *t = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(doSomething) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
    
    // RunLoop 如果不run，不会启动
    // RunLoop中如果没哟加入定时器，也不处理任何事件，也不会跑起来
    
    [[NSRunLoop currentRunLoop] run];
    //
    NSLog(@"运行完了");
}
@end
